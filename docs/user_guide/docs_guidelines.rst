.. _docs_guidelines:

Documentation guidelines
================================================================================

This documentation is built with `Sphinx <https://www.sphinx-doc.org>`_ and
all source code is available at the path :git-hdl:`docs`.

To contribute to it, open a pull request with the changes to
:git-hdl:`this repository </>`, just make sure to read the general
:ref:`doctools:docs_guidelines` first **and** the additional guidelines
below specific to the HDL repository.

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
   :ref:`doctools:docs_guidelines` to convert it to reST.

Common sections
--------------------------------------------------------------------------------

The **More information** and **Support** sections that are present in
the HDL project documentation, are actually separate pages inserted as links.
They're located at hdl/projects/common/more_information.rst and /support.rst,
and cannot be referenced here because they don't have an ID at the beginning
of the page, so not to have warnings when the documentation is rendered that
they're not included in any toctree.

They are inserted like this:

.. code-block::

   .. include:: ../common/more_information.rst

   .. include:: ../common/support.rst

And they will be rendered as sections of the page.
