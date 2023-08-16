Guidelines
================================================================================

A brief set-of-rules for the documentation.

.. note::
   The old wiki uses `dokuwiki <https://www.dokuwiki.org/dokuwiki>`_. When
   importing text from there, consider the automated options that are provided
   in this page to convert it to :term:`reST`.

Templates
--------------------------------------------------------------------------------

Templates are available:

* :git-hdl:`docs/library/template_ip` (:ref:`rendered <template_ip>`).
* :git-hdl:`docs/library/template_framework` (:ref:`rendered <template_framework>`).

Remove the ``:orphan:`` in the first line, it is to hide the templates from the
`TOC tree <https://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html#directive-toctree>`_.

Indentation
--------------------------------------------------------------------------------

Directives are indented with 3 space, which is Sphinx's default.
At code directives, the code keeps its original indentation (e.g. 2 spaces for
verilog code), but is offset by 3 spaces at the beginning of every line, to
instruct Sphinx the beginning and end of the code directive.

References
--------------------------------------------------------------------------------

References have the format ``library/project context``, e.g.
:code:`:ref:\`spi_engine execution\`` renders as :ref:`spi_engine execution`.
Notice how neither *library* nor *project* are present in the label, since there is no
naming collision between libraries or projects (no project will ever be named
*axi_dmac*).

Also, for project, libraries and :term:`IP`\s, the names should be exactly the
name of its folders, e.g. ``axi_pwm_gen`` and not ``axi-pwm-gen`` or ``AXI_PWM_GEN``,
this helps avoid broken references.

For resources without a particular source code file/folder, prefer hyphen ``-``
separation, for example, ``spi_engine control-interface`` instead of
``spi_engine control_interface``.

Text width
--------------------------------------------------------------------------------

Each line must be less than 80 columns wide.
You can use the :code:`fold` command to break the lines of the imported text
while respecting word-breaks:

.. code:: bash

   cat imported.txt | fold -sw 80 > imported.rst

Or use the pandoc command provided in the next topic, since it will also fold
at column 80.

Tables
--------------------------------------------------------------------------------

Prefer
`list-tables <https://docutils.sourceforge.io/docs/ref/rst/directives.html#list-table>`_
and imported
`csv-tables <https://docutils.sourceforge.io/docs/ref/rst/directives.html#csv-table-1>`_
(using the file option), because they are faster to create, easier to maintain
and the 80 column-width rule can be respected with list-tables.

Converting dokuwiki tables to list-table would be very time consuming, however
there is a pandoc `list-table filter <https://github.com/jgm/pandoc/issues/4564>`_,
see :ref:`installing_pandoc` for install instructions.

You can use the following command:

.. code:: bash

    pandoc <input.txt> -f dokuwiki -t rst --columns=80 -s -o <output.rst> --list-tables

The :code:`list-tables` parameter requires *pandoc-types* >= 1.23, if it is not
an option, you shall remove it and export in the *grid* table format.

Now you only have to adjust the widths and give the final touches, like using
the correct directives and roles.

Code
--------------------------------------------------------------------------------

Prefer
`code-blocks <https://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html#directive-code-block>`_
to
`code <https://docutils.sourceforge.io/docs/ref/rst/directives.html#code>`_
directives, because code-blocks have more options, such as showing line numbers
and emphasizing lines.

For example,

.. code:: rst

   .. code-block:: python
      :linenos:
      :emphasize-lines: 2

      def hello_world():
          string = "Hello world"
          print(string)

renders as

.. code-block:: python
   :linenos:
   :emphasize-lines: 2

   def hello_world():
       string = "Hello world"
       print(string)


Images
--------------------------------------------------------------------------------

Prefer the :term:`SVG` format for images, and save it as *Optimized SVG* in
`inkscape <https://inkscape.org/>`_ to use less space.

Vivado block-diagrams
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Vivado block-diadrams can be exported as PDF and then converted to SVG with
inkscape. See :ref:`spi_engine tutorial` for a "final result" example.

Vivado waveform data
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There is no way to export Vivado waveform data as vectors.
Therefore, the recommended method is to take a PNG screenshot and use
`GIMP <gimp.org>`_ to export as **8bpc RGB** with all metadata options
disabled.

.. note::

   Always use the *Export As..* ``Ctrl+Shift+E`` option.

To reduce even further the size, you can use *Color > Dither..* to reduce the
number of colors in the png.
Saving as greyscale also reduces the PNG size, but might reduce readability and
it is not recommended.

Third-party directives and roles
--------------------------------------------------------------------------------

Third-party tools are used to expand Sphinx functionality, for example, to
generate component diagrams.

.. tip::

   Check :git-hdl:`docs/Containterfile` for a recipe to install these
   tools, either in the host or in a container.

Symbolator directive
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Symbolator <https://kevinpt.github.io/symbolator/>`_ is a tool to generate
component diagrams.

Custom directives and roles
--------------------------------------------------------------------------------

To expand Sphinx functionality beyond existing tools, custom directives and roles
have been written, which are located in the *docs/extensions* folder.
Extensions are straight forward to create, if some functionality is missing,
consider requesting or creating one.

Git role
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The Git role allows to create links to the Git repository with a shorter syntax.
The role syntax is :code:`:git-<repo>:\`<branch>:<path>\``, for example,
:code:`:git-hdl:\`master:contributing/guidelines.rst\``
is rendered as :git-hdl:`master:contributing/guidelines.rst`.
You can leave the branch blank to autofill the link with the current branch.

You can also do :code:`:git-<repo>:\`/\`` for a link to the root of the
repository with pretty naming, for example, :code:`:git-hdl:\`/\`` is rendered
as :git-hdl:`/`.

Part role
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The part role creates links for a part to the Analog Devices website.

The role syntax is :code:`:part:\`<part_id>:<part_name>\``, for example,
:code:`:part:\`ad7175-2:AD7175-2\``.
Since links are case insensitive, you can also reduce it to
:code:`:part:\`AD7175-2\``, when *part_id* is the same as *part_name*.
It is rendered as :part:`AD7175-2`.

Datasheet role
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The datasheet role creates links for a datasheet in the Analog Devices website.

The role syntax is :code:`:datasheet:\`<part_id>:<anchor>\``, for example,
:code:`:datasheet:\`AD7984:[{"num"%3A51%2C"gen"%3A0}%2C{"name"%3A"XYZ"}%2C52%2C713%2C0]\``
is rendered as
:datasheet:`AD7984:[{"num"%3A51%2C"gen"%3A0}%2C{"name"%3A"XYZ"}%2C52%2C713%2C0]`.
The anchor is optional and is a link to a section of the PDF, and can be obtained
by just copying the link in the table of contents.

.. caution::

   Since not all PDF readers support anchors, always provide the page and/or
   figure number!

Dokuwiki role
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The dokuwiki role creates links to the Analog Devices wiki website.
The role syntax is :code:`:dokuwiki:\`<name>:<path>\``, for example,
:code:`:dokuwiki:\`pulsar-adc-pmods:resources/eval/user-guides/circuits-from-the-lab/pulsar-adc-pmods\``
gets rendered as
:dokuwiki:`pulsar-adc-pmods:resources/eval/user-guides/circuits-from-the-lab/pulsar-adc-pmods`.

EngineerZone role
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ez role creates links to the Analog Devices EngineerZone support website.
The role syntax is :code:`:ez:\`<community>\``, for example, :code:`:ez:\`fpga\``
gets rendered as :ez:`fpga`.

Xilinx role
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The xilinx role creates links to the Xilinx website.
The role syntax is :code:`:xilinx:\`<name>:<path>\``, for example,
:code:`:xilinx:\`Zynq-7000 SoC Overview:support/documentation/data_sheets/ds190-Zynq-7000-Overview.pdf\``
gets rendered
:xilinx:`Zynq-7000 SoC Overview:support/documentation/data_sheets/ds190-Zynq-7000-Overview.pdf`.

The name parameter is optional, if absent, the file name will be used as the name.

HDL parameters directive
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The HDL parameters directive parses the *\*_hw.tcl* library files to generate a
table with the IP parameters.

.. attention::

   This directive does not support parameters generated in a foreach loop yet
   (e.g. :git-hdl:`library/axi_dmac/axi_dmac_hw.tcl#L90`).
   Manually create the parameters table in these cases.

The directive syntax is:

.. code:: rst

   .. hdl-parameters::
      :path: <ip_path>

      * - <parameter>
        - <description>

For example:

.. code:: rst

   .. hdl-parameters::
      :path: library/spi_engine/spi_engine_interconnect

      * - DATA_WIDTH
        - Data width of the parallel SDI/SDO data interfaces.
      * - NUM_OF_SDI
        - Number of SDI lines on the physical SPI interface.

renders as:

.. hdl-parameters::
   :path: library/spi_engine/spi_engine_interconnect

   * - DATA_WIDTH
     - Data width of the parallel SDI/SDO data interfaces.
   * - NUM_OF_SDI
     - Number of SDI lines on the physical SPI interface.

Notice how the *Type* and *Default* values are obtained from the *\*_hw.tcl*.
Parameters not listed in the directive are also added to the table, but
will have an empty description, unless a comment follows the ``ad_ip_parameter``
method in the source file.

If you are felling adventurous, the ``:path:`` option is optional, and the
extension will guess the path to the library.

.. _installing_pandoc:

Installing pandoc
--------------------------------------------------------------------------------

The recommended way to import dokuwiki to reST is to use
`pandoc <https://pandoc.org>`_.

To ensure a up-to date version, considering installing from source:

.. code::

   curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
   cabal v2-update
   cabal v2-install pandoc-cli

If custom pandoc haskell filters are needed, also install as a library:

.. code::

   cabal v2-install --lib pandoc-types --package-env .

The tested *pandoc* version is 3.1.5, with *pandoc-types* version 2.13.
