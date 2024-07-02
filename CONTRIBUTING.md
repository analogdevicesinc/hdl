# Contributing to HDL repository

When contributing to this repository, please first discuss the change you wish
to make, via the [issue tracker](https://github.com/analogdevicesinc/hdl/issues)
before making a pull request. We will let you know if we want to have it
supported on our repo. If not, depending on the case, we might propose you to
have it added to our
[Third party forks](https://analogdevicesinc.github.io/hdl/user_guide/third_party.html) 
list.

The [HDL repo](https://github.com/analogdevicesinc/hdl) is the place where
[Analog Devices, Inc.](https://www.analog.com/en/index.html) provides FPGA
reference designs for selected hardware, featuring some of our products
interfacing to publicly-available FPGA evaluation boards.
Alongside these, we have custom IP cores designed to facilitate the creation
of these projects - modular structure.

The individual modules are developed independently, and may be accompanied by
separate and unique license terms (specified inside the file).
The user should read each of these license terms and understand the freedoms
and responsibilities that he or she has by using them.

-  [LICENSE](https://github.com/analogdevicesinc/hdl/blob/main/LICENSE)
-  [LICENSE_ADIBSD](https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD)
-  [LICENSE_ADIJESD204](https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIJESD204)
-  [LICENSE_BSD-1-Clause](https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_BSD-1-Clause)
-  [LICENSE_GPL2](https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_GPL2)
-  [LICENSE_LGPL](https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_LGPL)

## Pull request rules

- Commit message includes a "Signed-off-by: [name] < email >" to the commit
    message. This ensures you have the rights to submit your code, by agreeing
    to the
    [Developer Certificate of Origin](https://developercertificate.org/).
    If you can not agree to the DCO, don't submit a pull request, as we can
    not accept it.
- For first-time contributors, you will be asked by **CLAssistant** to 
  "sign our [Contributor License Agreement](https://cla-assistant.io/analogdevicesinc/hdl?pullRequest=959)
  before we can accept your contribution."
- Commit should be "atomic", meaning it should do one thing only.
  A pull request should only contain multiple commits if that is required
  to fix the bug or implement the feature.
- Commits should have good commit messages. Check out
  [The git book](https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project)
  for some pointers and tools to use.
- Typically, the title of the commit should have the path to the changed files, and
  then explaining in a few words what has been done, like
  *projects/ad9081_fmca_ebz/zcu102: Add missing clock constraint*
- Write a concise PR description, containing all the needed details
- Pull requests will be merged only after they have been reviewed, tested and
  approved by the
  [code owners](https://github.com/analogdevicesinc/hdl/blob/main/.github/CODEOWNERS).

## Before opening the pull request

- Create a fork of this repository. If you are not sure how to do this,
  check out
  [GitHub help](https://help.github.com/en/github/getting-started-with-github/fork-a-repo).
- Here you will make your contributions on a branch. From time to time,
  rebase it onto main, to make sure you have the latest code available
- Check the [Code-related check list](#code-related-check-list) section while still in the development
  phase
- The **register map** should be updated, if that's the case:
  * Update the corresponding **docs/regmap text files**
  * The IPs typically should follow
    [Semantic Versioning 2.0.0](https://semver.org/)
- Update **Makefile** files of the affected projects
- Run **check_guideline.py** on your branch
- Run **Verilator**
- Code must build OK on all affected projects. Warnings are reviewed.
  **Critical Warnings** are not accepted. These must be built on Windows
  and Linux. What fails to build on our continuous integration system,
  cannot be merged.
- Test code in hardware on as many setups as possible
- Make sure you have your branch **rebased** onto latest main right before
  opening the PR
- :warning: The changes brought to the project/IP core should be reflected in its
  corresponding documentation, if exists. If not, then a documentation
  should be created, following our
  [Documentation guidelines](https://analogdevicesinc.github.io/hdl/user_guide/docs_guidelines.html).

## When opening the pull request

- Create a pull request on this repository. If you are not sure on how to
  do this, check out
  [GitHub help](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request-from-a-fork) 
- In the description of the PR:
  - Motivate the additions/changes/deletions to the code
  - Add link to related GitHub issues
  - Add link to related PR if it depends on others (maybe link to
    Linux/no-OS PR); everything that is relevant for the reviewers
- Tick the boxes with the requirements that you fulfill
- Add some labels to be easier for others to review your changes
- Check the results from the GitHub actions that were run
- If reviewers requested changes or you found mistakes, then:
  - **No force-pushing**, even if there are tiny changes or typos
  - **For every change**, a new commit at least
  - Check the **GitHub actions** that are failing and fix the issues
  - **Add a comment** explaining what you modified additionally (it's easier
    for the reviewer and for tracking)
  - When the PR is approved by all code owners, you have 3 options
  - Option 1: If all these commits must be pushed, then from the dropdown,
    select **Rebase and merge**
  - Option 2: If all these commits must be in one commit in the end, then you
    can use the **Squash and merge** option from the dropdown.
    It will prompt you to give the name of the final commit
  - Option 3: **Squash the commits locally**, force-push and if you don't
    make any changes to the code, then GitHub will recognize this force-push
    as being without changes, so you don't need approves again to merge it
    using **Rebase and merge**
    - If you do make changes (**don't!!**), comment on what you did and
      request again the code owners to review the PR – changed files will be
      seen with **Changes since last view** next to the name
      (in the PR > Files changed tab) or there's a "Compare" button in the
      Conversation tab.
- If you encounter conflicts with other files (that you didn't change, and
  that are already on main), **do not resolve the conflicts using Git GUI!**
  This way, you will insert a merge commit into the commit history.
  **We do not want merge commits.** Thus, open a terminal and resolve
  it there (see [this discussion](https://stackoverflow.com/a/162056))

## Code-related check list

- On top of the existing guidelines for Tcl scripting, Verilog/SystemVerilog,
  Makefiles, etc., we have our own guidelines and you must check them out:
  [ADI HDL coding guidelines](https://analogdevicesinc.github.io/hdl/user_guide/hdl_coding_guidelines.html).
  We also created a
  [script](https://github.com/analogdevicesinc/hdl/blob/main/.github/scripts/check_guideline.py)
  to check some of those rules. To see which ones and how to use the script,
  [click here](https://github.com/analogdevicesinc/hdl/blob/main/.github/scripts/readme_check_guideline.md)
  (this is part of our GitHub actions check as well, and if this fails,
  the PR will not be approved).
- Check if in the meantime there were any **changes to the common IPs**
  that you used (e.g., *up_adc_common*, *up_delay_cntrl*, etc.).
  If there are changes in the I/O ports, update your instances accordingly
- If a new IP core has been used in the affected project, it should be added
  as a dependency in its corresponding Makefile file (of the affected project).
- If it's the case, to update all the README files of the affected projects
  and IP cores.

Resources:
* [How to write a good commit message](https://cbea.ms/git-commit/) and [another resource](https://gist.github.com/rsp/057481db4dbd999bb7077f211f53f212)
* [Write better commits, build better projects](https://github.blog/2022-06-30-write-better-commits-build-better-projects/)
* [Good commit example (but extreme one)](https://dhwthompson.com/2019/my-favourite-git-commit)
* [How should a PR look like](https://opensource.com/article/18/6/anatomy-perfect-pull-request) and [anatomy of a PR](https://github.blog/2015-01-21-how-to-write-the-perfect-pull-request/)
* [Submitting patches](https://github.com/analogdevicesinc/linux/blob/master/Documentation/process/submitting-patches.rst)
