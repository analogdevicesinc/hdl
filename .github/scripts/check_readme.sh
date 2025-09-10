#!/bin/sh

##############################################################################
## Copyright (C) 2022-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: BSD-1-Clause
#
# The purpose of this script:
## Ensure there are README.md (case insensitive name) files in all the project directories
##############################################################################

set -e

fail=0

# Function to format board name (e.g., ad9081_fmca_ebz -> AD9081-FMCA-EBZ)
format_board_name() {
    echo "$1" | tr '[:lower:]' '[:upper:]' | sed 's/_/-/g'
}

# Function to format carrier name (e.g., de10nano -> DE10NANO)
format_carrier_name() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

# Function to detect special carriers
is_special_carrier() {
    case "$1" in
        ccbob_*|ccfmc_*|ccpackrf_*|adrv2crr_fmc|adrv2crr_fmcomms8|adrv2crr_fmcxmwbr1)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Function to extract flags from first line of README
extract_flags() {
    local file=$1
    head -n 1 "$file" | sed -e 's/<!--//' -e 's/-->//' | tr ',' '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# Function to validate README content
check_readme() {
    local file=$1
    local board=$2
    local carrier=$3

    local is_main_readme=0
    if [ "$carrier" = "$board" ]; then
        is_main_readme=1
    fi

    local board_caps=$(format_board_name "$board")
    local carrier_caps=$(format_carrier_name "$carrier")

    local expected_title
    if [ "$is_main_readme" -eq 1 ]; then
        expected_title="# $board_caps HDL Project"
        echo "  $board/README.md ->"
    else
        expected_title="# $board_caps/$carrier_caps HDL Project"
        echo "  $board/$carrier/README.md ->"
    fi

    local local_fail=0

    # Extract flags
    flags=$(extract_flags "$file")

    has_flag() {
        echo "$flags" | grep -q "$1"
    }

    # Check title (skip for special carriers)
    if [ "$is_main_readme" -eq 0 ] && is_special_carrier "$carrier"; then
        :
    else
        if ! grep -q "$expected_title" "$file"; then
            echo "    ✖ Incorrect or missing title. Expected: $expected_title"
            local_fail=1
        fi
    fi

    if [ "$is_main_readme" -eq 1 ]; then
        if ! echo "$flags" | grep -q "no_build_example"; then
            if ! grep -q "Building the project" "$file"; then
                echo "    ✖ Missing section \"Building the project\""
                local_fail=1
            fi
        fi
        if ! grep -q "Supported parts" "$file"; then
            echo "    ✖ Missing section \"Supported parts\""
            local_fail=1
        fi
    else
        if ! echo "$flags" | grep -q "no_build_example"; then
            for section in "Building the project" "Example configurations"; do
                if ! grep -q "$section" "$file"; then
                    echo "    ✖ Missing section \"$section\""
                    local_fail=1
                fi
            done

            if grep -q "Example configurations" "$file"; then
                local default_check=$(awk '/Example configurations/{flag=1;next}/^`/{flag=0}flag' "$file" | grep -i "default")
                if [ -z "$default_check" ]; then
                    echo "    ✖ Under 'Example configurations' there's no mention of a default configuration"
                    local_fail=1
                fi
            fi
        fi
    fi

    for bad_link in "https://wiki.analog.com/resources/tools-software/linux-drivers-all" "https://wiki.analog.com/linux"; do
        if grep -q "$bad_link" "$file"; then
            echo "    ✖ Do not link to $bad_link"
            local_fail=1
        fi
    done

    if grep -q "([[:space:]]*)" "$file"; then
        echo "    ✖ Found empty link ()"
        local_fail=1
    fi

    if [ "$local_fail" -eq 0 ]; then
        echo "    ✔ Okay"
    else
        fail=1
    fi
}

# Main loop
for project in projects/*; do
    [ -d "$project" ] || continue
    project_name=$(basename "$project")

    if [ "$project_name" = "common" ] || [ "$project_name" = "scripts" ]; then
        continue
    fi

    echo "$project_name:"

    main_readme="$project/README.md"
    if [ -f "$main_readme" ]; then
        check_readme "$main_readme" "$project_name" "$project_name"
    else
        echo "  $project_name/README.md -> ✖ Missing"
        fail=1
    fi

    for carrier in "$project"/*; do
        [ -d "$carrier" ] || continue
        carrier_name=$(basename "$carrier")

        if [ "$carrier_name" = "common" ]; then
            continue
        fi

        readme_path="$carrier/README.md"
        if [ -f "$readme_path" ]; then
            check_readme "$readme_path" "$project_name" "$carrier_name"
        else
            echo "  $project_name/$carrier_name/README.md -> ✖ Missing"
            fail=1
        fi
    done
done

if [ "$fail" -eq 1 ]; then
    echo "Something occurred! Check the output of the script."
    exit 1
fi
