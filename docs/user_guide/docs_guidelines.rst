.. _docs_guidelines:

Documentation guidelines
================================================================================

This documentation is built with `Sphinx <https://www.sphinx-doc.org>`_ and
all source code is available at the path :git-hdl:`docs`.

To contribute to it, open a pull request with the changes to
:git-hdl:`this repository </>`, just make sure to read the general
:external+doctools:ref:`docs_guidelines` first **and** the additional guidelines
below specific to the HDL repository.

Before creating a new page
--------------------------------------------------------------------------------

This section has the sole role to present the steps that are required to be
able to create and build a new documentation related page. Some steps are
recommended to be revised regularly to keep the necessary tools updated.

First, make sure you have the latest version of ``pip`` installed. It must be
newer than 23 version. If not, update it by running the following command:

.. shell:: bash
   :no-path:

   $pip install pip --upgrade

Then install the necessary documentation tools by running (:git-hdl:`HDL <>`
repository is the working directory):

.. shell:: bash

   ~/hdl
   $cd docs/
   $pip install -r requirements.txt --upgrade

Use the same command to regularly update the documentation tools.
Specially if something looks broken.

Before building a page, it's recommended to build all the projects from
``/library``. Some references (files used in specific parts of the page) are
directly taken from the libraries' project folder (e.g.: ``/library/axi_dmac/component.xml``)
after being built. Build the libraries by running:

.. shell:: bash

   ~/hdl
   $cd library/
   $make

Now, after the page has been written, inside ``/docs`` folder run the following
command:

.. shell:: bash

   ~/hdl
   $cd docs/
   $make html

The generated documentation will be available at ``/docs/_build/html``.

It's recommended to clean the cached data when changing the document structure,
like adding a new page or if other major changes have been made.
This is because Sphinx rebuilds only "touched" pages and, for example,
adding a page changes the sidebar navigation for all pages.
This is done by running the below commands (inside ``/docs`` folder):

.. shell:: bash

   ~/hdl/docs
   $make clean
   $make html

Or more straight forward (clean & rebuild):

.. shell:: bash

   ~/hdl/docs
   $make clean html

Make sure to read the next chapters as they provide more info on how to write
a HDL specific Sphinx documentation page.

Templates
--------------------------------------------------------------------------------

Templates are available:

* :git-hdl:`docs/library/template_ip` (:ref:`rendered <template_ip>`).
* :git-hdl:`docs/library/template_framework` (:ref:`rendered <template_framework>`).
* :git-hdl:`docs/projects/template` (:ref:`rendered <template_project>`).

Remove the ``:orphan:`` in the first line, it is to hide the templates from the
`TOC tree <https://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html#directive-toctree>`_,
and make sure to remove any placeholder text and instructive comment.

.. note::

   The old wiki uses `dokuwiki <https://www.dokuwiki.org/dokuwiki>`_. When
   importing text from there, consider ``pandoc`` and the tips accross the
   :external+doctools:ref:`docs_guidelines` to convert it to reST.

Common sections
--------------------------------------------------------------------------------

The **More information** and **Support** sections that are present in
the HDL project documentation, are actually separate pages inserted as links.
They're located at hdl/projects/common/more_information.rst and /support.rst,
and cannot be referenced here because they don't have an ID at the beginning
of the page, so not to have warnings when the documentation is rendered that
they're not included in any toctree.

They are inserted like this:

.. code-block:: rst

   .. include:: ../common/more_information.rst

   .. include:: ../common/support.rst

And they will be rendered as sections of the page.
