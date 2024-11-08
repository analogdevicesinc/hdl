###########################################################
# env_link.sh
# This script has the sole role to link HDL and TB repos
# no matter their location
###########################################################

# Example usage:
# Make the script executable:
# chmod +x env_link.sh
# Run the script with an absolute or relative path to the testbenches directory:
# ./env_link.sh /absolute/path/to/testbenches
# or
# ./env_link.sh ../relative/path/to/testbenches
# If no argument is provided, the script will search for the testbenches directory:
# ./env_link.sh
# 
# Note, you can also run the script by running:
# source env_tcl.sh {same_instructions_as_above} or
# bash env_tcl.sh {same_instructions_as_above}

# Function to recursively search for a directory
search_directory() {
    local dir=$1
    local target=$2
    while [ "$dir" != "/" ]; do
        if [ -d "$dir/$target" ]; then
            echo "$dir/$target"
            return 0
        fi
        dir=$(dirname "$dir")
    done
    return 1
}

# Function to convert a relative path to an absolute path
to_absolute_path() {
    local path=$1
    if [ -d "$path" ]; then
        (cd "$path" && pwd)
    else
        echo "$path"
    fi
}

# Check if the HDL path is already exported
if [[ $ADI_HDL_DIR == *"hdl"* ]]; then
    echo "HDL path already exported!"
else
    echo "HDL path not exported, will export now ..."
    # Check if we are in a directory that contains "hdl"
    if [[ $(pwd) == *"hdl"* ]]; then
        hdl_path=$(pwd | sed 's|\(.*hdl\).*|\1|')
        export ADI_HDL_DIR="${hdl_path}"
        echo "HDL directory exported as $ADI_HDL_DIR"
    else
        echo "Not in an HDL directory"
    fi
fi

# Check if the TB path is already exported
if [[ $ADI_TB_DIR == *"testbenches"* ]]; then
    echo "Testbenches path already exported!"
else
    echo "Testbenches path not exported, will export now ..."
    # Use the provided argument or search for the testbenches directory
    abs_path_to_tb=$1
    if [ -n "$abs_path_to_tb" ]; then
        abs_path_to_tb=$(to_absolute_path "$abs_path_to_tb")
        if [ -d "$abs_path_to_tb" ]; then
            export ADI_TB_DIR="$abs_path_to_tb"
            echo "Testbenches directory exported as $ADI_TB_DIR"
        else
            echo "Provided path does not exist"
        fi
    else
        tb_path=$(search_directory "$(pwd)" "testbenches")
        if [ -n "$tb_path" ]; then
            export ADI_TB_DIR="$tb_path"
            echo "Testbenches directory found and exported as $ADI_TB_DIR"
        else
            echo "Testbenches directory not found"
        fi
    fi
fi
