# Template for the evaluation board specific README.md

Use the ``template_readme_evalboard.md`` file for the evaluation board specific README.md, which is located at **hdl/projects/$evalboard/README.md**.

## Rules

The title of the page should be the name of the evaluation board folder.

If the system level documentation link is not yet available, a placeholder can be put: "to be added". This link is the only exception.

---------------------------

# Templates for the carrier-specific README.md

For the READMEs located at **hdl/projects/$evalboard/$carrier/README.md**, there are 3 templates which can be used:

- ``template1_readme_carrier.md`` for projects which do not have ``make`` parameters
- ``template2_readme_carrier.md`` for projects which have ``make`` parameters
- ``template3_readme_carrier.md`` for projects which have a fixed configuration and cannot be changed

## Rules

Depending on the project, some sections from the **hdl/projects/$evalboard/$carrier/README.md** template are not needed.

Please specify this in the **hdl/projects/$evalboard/$carrier/README.md** using the flags:

- **no_build_example** - means that the project either does not have make parameters or it has a hardcoded configuration and it cannot be changed
- **no_dts** - no device tree file (.dts) published at the moment of writing the README
- **no_no_os** - no no-OS project published at the moment of writing the README

These flags are needed such that the GitHub action script knows the context and doesn't throw errors for what it shouldn't.

These flags are specified on the first line of the README, as a Markdown comment, and they **should not be seen** when the README is rendered:

```
<!-- Put flags here, i.e. no_build_example, no_dts, no_no_os -->
```

Mention all the overwritable parameters from the environment and their possible values and what they mean! (Not the case for JESD parameters).

Give link to the data sheet from where to take all the possible configurations (for JESD parameters).

List all the possible configurations for which we have a Linux device tree.
