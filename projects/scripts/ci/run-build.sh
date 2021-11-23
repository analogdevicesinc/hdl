#!/bin/bash
set -e

# cd to docker build dir if it exists
if [ -d /docker_build_dir ] ; then
	cd /docker_build_dir
fi

. ./projects/scripts/ci/lib.sh

MAIN_BRANCH=${MAIN_BRANCH:-add_pr_check}

if [ -f "${FULL_BUILD_DIR}/env" ] ; then
	echo_blue "Loading environment variables"
	cat "${FULL_BUILD_DIR}/env"
	. "${FULL_BUILD_DIR}/env"
fi

# Run once for the entire script
sudo apt-get -qq update

apt_install() {
	sudo apt-get install -y $@
}

if [ -z "$NUM_JOBS" ] ; then
	NUM_JOBS=$(getconf _NPROCESSORS_ONLN)
	NUM_JOBS=${NUM_JOBS:-1}
fi

APT_LIST="make bc u-boot-tools flex bison libssl-dev"

if [ "$ARCH" = "arm64" ] ; then
	if [ -z "$CROSS_COMPILE" ] ; then
		CROSS_COMPILE=aarch64-linux-gnu-
		export CROSS_COMPILE
	fi

	APT_LIST="$APT_LIST gcc-aarch64-linux-gnu"
fi

if [ "$ARCH" = "arm" ] ; then
	if [ -z "$CROSS_COMPILE" ] ; then
		CROSS_COMPILE=arm-linux-gnueabihf-
		export CROSS_COMPILE
	fi

	APT_LIST="$APT_LIST gcc-arm-linux-gnueabihf"
fi

apt_update_install() {
	apt_install $@
	adjust_kcflags_against_gcc
}

__get_all_c_files() {
	git grep -i "$@" | cut -d: -f1 | sort | uniq  | grep "\.c"
}

check_all_adi_files_have_been_built() {
	# Collect all .c files that contain the 'Analog Devices' string/name
	local c_files=$(__get_all_c_files "Analog Devices")
	local ltc_c_files=$(__get_all_c_files "Linear Technology")
	local o_files
	local exceptions_file="ci/travis/${DEFCONFIG}_compile_exceptions"
	local ret=0

	c_files="drivers/misc/mathworks/*.c $c_files $ltc_c_files"

	# Convert them to .o files via sed, and extract only the filenames
	for file in $c_files ; do
		file1=$(echo $file | sed 's/\.c/\.o/g')
		if [ -f "$exceptions_file" ] ; then
			if grep -q "$file1" "$exceptions_file" ; then
				continue
			fi
		fi
		if [ ! -f "$file1" ] ; then
			if [ "$ret" = "0" ] ; then
				echo
				echo_red "The following files need to be built OR"
				echo_green "      added to '$exceptions_file'"

				echo

				echo_green "  If adding the '$exceptions_file', please make sure"
				echo_green "  to check if it's better to add the correct Kconfig symbol"
				echo_green "  to one of the following files:"

				for file in $(find -name Kconfig.adi) ; do
					echo_green "   $file"
				done

				echo
			fi
			echo_red "File '$file1' has not been compiled"
			ret=1
		fi
	done

	return $ret
}

get_ref_branch() {
	if [ -n "$TARGET_BRANCH" ] ; then
		echo -n "$TARGET_BRANCH"
	elif [ -n "$TRAVIS_BRANCH" ] ; then
		echo -n "$TRAVIS_BRANCH"
	elif [ -n "$GITHUB_BASE_REF" ] ; then
		echo -n "$GITHUB_BASE_REF"
	else
		echo -n "HEAD~5"
	fi
}



build_checkpatch() {
	# TODO: Re-visit periodically:
	# https://github.com/torvalds/linux/blob/master/Documentation/devicetree/writing-schema.rst
	# This seems to change every now-n-then
	apt_install python3-ply python-git-doc libyaml-dev python3-pip python3-setuptools
	pip3 install wheel
	pip3 install git+https://github.com/devicetree-org/dt-schema.git@master

	local ref_branch="$(get_ref_branch)"

	echo_green "Running checkpatch for commit range '$ref_branch..'"

	if [ -z "$ref_branch" ] ; then
		echo_red "Could not get a base_ref for checkpatch"
		exit 1
	fi

	__update_git_ref "${ref_branch}" "${ref_branch}"

	scripts/checkpatch.pl --git "${ref_branch}.." \
		--ignore FILE_PATH_CHANGES \
		--ignore LONG_LINE \
		--ignore LONG_LINE_STRING \
		--ignore LONG_LINE_COMMENT
}

branch_contains_commit() {
	local commit="$1"
	local branch="$2"
	git merge-base --is-ancestor $commit $branch &> /dev/null
}

__update_git_ref() {
	local ref="$1"
	local local_ref="$2"
	local depth
	[ "$GIT_FETCH_DEPTH" = "disabled" ] || {
		depth="--depth=${GIT_FETCH_DEPTH:-50}"
	}
	if [ -n "$local_ref" ] ; then
		git fetch $depth $ORIGIN +refs/heads/${ref}:${local_ref}
	else
		git fetch $depth $ORIGIN +refs/heads/${ref}
	fi
}

__push_back_to_github() {
	local dst_branch="$1"

	git push --quiet -u $ORIGIN "HEAD:$dst_branch" || {
		echo_red "Failed to push back '$dst_branch'"
		return 1
	}
}

__handle_sync_with_main() {
	local dst_branch="$1"
	local method="$2"

	__update_git_ref "$dst_branch" || {
		echo_red "Could not fetch branch '$dst_branch'"
		return 1
	}

	if [ "$method" = "fast-forward" ] ; then
		git checkout FETCH_HEAD
		git merge --ff-only ${ORIGIN}/${MAIN_BRANCH} || {
			echo_red "Failed while syncing ${ORIGIN}/${MAIN_BRANCH} over '$dst_branch'"
			return 1
		}
		__push_back_to_github "$dst_branch" || return 1
		return 0
	fi

	if [ "$method" = "cherry-pick" ] ; then
		local depth
		if [ "$GIT_FETCH_DEPTH" = "disabled" ] ; then
			depth=50
		else
			GIT_FETCH_DEPTH=${GIT_FETCH_DEPTH:-50}
			depth=$((GIT_FETCH_DEPTH - 1))
		fi
		# FIXME: kind of dumb, the code below; maybe do this a bit neater
		local cm="$(git log "FETCH_HEAD~${depth}..FETCH_HEAD" | grep "cherry picked from commit" | head -1 | awk '{print $5}' | cut -d')' -f1)"
		[ -n "$cm" ] || {
			echo_red "Top commit in branch '${dst_branch}' is not cherry-picked"
			return 1
		}
		branch_contains_commit "$cm" "${ORIGIN}/${MAIN_BRANCH}" || {
			echo_red "Commit '$cm' is not in branch '${MAIN_BRANCH}'"
			return 1
		}
		# Make sure that we are adding something new, or cherry-pick complains
		if git diff --quiet "$cm" "${ORIGIN}/${MAIN_BRANCH}" ; then
			return 0
		fi

		tmpfile=$(mktemp)

		if [ "$CI" = "true" ] ; then
			# setup an email account so that we can cherry-pick stuff
			git config user.name "CSE CI"
			git config user.email "cse-ci-notifications@analog.com"
		fi

		git checkout FETCH_HEAD
		# cherry-pick until all commits; if we get a merge-commit, handle it
		git cherry-pick -x "${cm}..${ORIGIN}/${MAIN_BRANCH}" 1>/dev/null 2>$tmpfile || {
			was_a_merge=0
			while grep -q "is a merge" $tmpfile ; do
				was_a_merge=1
				# clear file
				cat /dev/null > $tmpfile
				# retry ; we may have a new merge commit
				git cherry-pick --continue 1>/dev/null 2>$tmpfile || {
					was_a_merge=0
					continue
				}
			done
			if [ "$was_a_merge" != "1" ]; then
				echo_red "Failed to cherry-pick commits '$cm..${ORIGIN}/${MAIN_BRANCH}'"
				echo_red "$(cat $tmpfile)"
				return 1
			fi
		}
		__push_back_to_github "$dst_branch" || return 1
		return 0
	fi
}

build_sync_branches_with_main() {
	GIT_FETCH_DEPTH=50
	BRANCHES="xcomm_zynq:fast-forward adi-5.10.0:cherry-pick"
	BRANCHES="$BRANCHES rpi-5.10.y:cherry-pick"

	__update_git_ref "$MAIN_BRANCH" "$MAIN_BRANCH" || {
		echo_red "Could not fetch branch '$MAIN_BRANCH'"
		return 1
	}

	for branch in $BRANCHES ; do
		local dst_branch="$(echo $branch | cut -d: -f1)"
		[ -n "$dst_branch" ] || break
		local method="$(echo $branch | cut -d: -f2)"
		[ -n "$method" ] || break
		__handle_sync_with_main "$dst_branch" "$method"
	done
}

ORIGIN=${ORIGIN:-origin}

BUILD_TYPE=${BUILD_TYPE:-${1}}
BUILD_TYPE=${BUILD_TYPE:-default}

build_${BUILD_TYPE}
