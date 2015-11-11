set orig_dir .;
cd $orig_dir;

# Build IPs.
source ./build-ips.tcl;

# Build design.
source ./system_project.tcl;
