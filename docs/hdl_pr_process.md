# HDL PR process

###### Copyright 2022 - 2023 (c) Analog Devices, Inc. All rights reserved.

This page contains the pull-request process that the Analog Devices, Inc. HDL team follows.

Check out:
* [How to write a good commit message](https://cbea.ms/git-commit/) and [another resource](https://gist.github.com/rsp/057481db4dbd999bb7077f211f53f212)
* [Write better commits, build better projects](https://github.blog/2022-06-30-write-better-commits-build-better-projects/)
* [Good commit example (but extreme one)](https://dhwthompson.com/2019/my-favourite-git-commit)
* [How should a PR look like](https://opensource.com/article/18/6/anatomy-perfect-pull-request) and [anatomy of a PR](https://github.blog/2015-01-21-how-to-write-the-perfect-pull-request/)
* [Submitting patches](https://github.com/analogdevicesinc/linux/blob/master/Documentation/process/submitting-patches.rst)
* [HDL coding guideline](https://github.com/analogdevicesinc/hdl/blob/master/docs/hdl_coding_guideline.md)

## For first-timers

- Make sure you are making a PR **from the proper account** (check [First-Time Git Setup](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup) if you haven't already done so)
- You will be asked by **CLAssistant** to "_sign our [Contributor License Agreement](https://cla-assistant.io/analogdevicesinc/hdl?pullRequest=959) before we can accept your contribution._"
- If you see this message on your PR page: "**username** _seems not to be a GitHub user. You need a GitHub account to be able to sign the CLA. If you have already a GitHub account, please [add the email address used for this commit to your account](https://help.github.com/articles/why-are-my-commits-linked-to-the-wrong-user/#commits-are-not-linked-to-any-user)._" then it means you didn't check properly the first step
- If you encounter conflicts with other files (that you didn't change, and that are already on **master**), **do not resolve the conflict using Git GUI!** This way, you will insert a **merge commit** into the commit history, and merge commits cannot be squashed with normal commits. **We do not want merge commits.** So, open a terminal and resolve it there (see [this discussion](https://stackoverflow.com/a/162056))
- Add the FPGA group as reviewers (_analogdevicesinc/fpga_ group)

## If you're the owner of the PR
Before opening a Pull Request:
1. **Rebase branch** onto latest master
2. Make sure the **new register map** is updated, if that's the case:
   * Update the corresponding **docs/regmap text files**
   * Update the [Register Map Wiki page](https://wiki.analog.com/resources/fpga/docs/hdl/regmap) with the *adi_regmap.wiki* code generated
   * The IPs typically should follow [Semantic Versioning 2.0.0](https://semver.org/)
3. Check if in the meantime there were any **changes to the common IPs** that you used (e.g., *up_adc_common*, *up_adc_channel*, *up_delay_cntrl*, etc.). If there are changes in the I/O ports, update your instances accordingly
4. **Regenerate the Makefiles** that concern the projects you're editing/adding, to have them up-to-date
5. Run [check_guideline.py](https://github.com/analogdevicesinc/hdl/blob/master/.github/scripts/check_guideline.py) on your branch
6. Run **Verilator**
7. **Visually inspect the code**
8. Code must build OK on **at least one project**. **Warnings** are reviewed. **Critical Warnings** are not accepted
9. Test code in hardware on **at least one setup**
10. Check **README** links 

When opening the Pull Request:
1. Give a **detailed description** for the PR (add link to related PR if it depends on others, maybe link to software PR, etc.), everything that is relevant for the reviewer
2. In the description of the Pull Request, **identify all links for Wiki** where changes need to be reviewed, so that the Wiki approval and the HDL PR merge happen at the same time
3. Add some **labels** to be easier for others to review your changes
4. Check **GitHub actions**
5. If reviewers requested changes or you found mistakes, then:
   - **No force-pushing**, even if there are tiny changes or typos
   - **For every change**, a new commit at least
   - Check the **GitHub actions** that are failing and fix the issues
   - **Add a comment** explaining what you modified additionally (it's easier for the reviewer and for tracking)
   - When the PR is approved by at least 2 people, you have 3 options
   - Option 1: If all these commits must be pushed, then from the dropdown, select **Rebase and merge**
   - Option 2: If all these commits must be in one commit in the end, then you can use the **Squash and merge** option from the dropdown. It will prompt you to give the name of the final commit
   - Option 3: **Squash the commits locally**, force-push and if you don't make any changes to the code, then GitHub will recognize this force-push as being without changes, so you don't need approves again to merge it using **Rebase and merge**
     - If you do make changes (**don't!!**), comment on what you did and ask those people that previously approved the PR, to approve it again – changed files will be seen with **Changes since last view** next to the name (in the PR > Files changed tab)

## If you're a reviewer of a PR
1. **Visually inspect the code** and **mark the viewed ones** by ticking the box next to the name. In case the owner makes some other changes to the viewed files, you will see with **Changes since last view** next to the name (in the PR > Files changed tab)
2. If the design is new, **check the schematic and the pinout**
3. Check **README** links
4. **Build at least one of the affected projects** and **check warnings**
5. Make sure the **new register map** is updated, if that's the case. The IPs typically should follow [Semantic Versioning 2.0.0](https://semver.org/)
6. Check if in the meantime there were some **changes to the common IPs** that were used in the project from this PR (e.g., *up_adc_common*, *up_adc_channel*, *up_delay_cntrl*, etc.)
7. See if Makefiles are up-to-date by **regenerating** them (the ones that concern the edited projects)
8. Run [check_guideline.py](https://github.com/analogdevicesinc/hdl/blob/master/.github/scripts/check_guideline.py)
9. Run **Verilator**
10. Review the **wiki changes**
11. Check the **GitHub actions** if they fail
