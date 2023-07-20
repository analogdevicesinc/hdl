.. _docs_guidelines:

Documentation guidelines
================================================================================

A brief set-of-rules for the documentation.

.. note::
   The old wiki uses `dokuwiki <https://www.dokuwiki.org/dokuwiki>`_. When
   importing text from there, consider the automated options that are provided
   in this page to convert it to reST.

Templates
--------------------------------------------------------------------------------

Templates are available:

* :git-hdl:`docs/library/template_ip` (:ref:`rendered <template_ip>`).
* :git-hdl:`docs/library/template_framework` (:ref:`rendered <template_framework>`).
* :git-hdl:`docs/projects/template_project` (:ref:`rendered <template_project>`).

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

Also, for project, libraries and IPs, the names should be exactly the
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

Or use :code:`pandoc`:

.. code:: bash

   pandoc imported.txt -f dokuwiki -t rst --columns=80 -s -o imported.rst


Tables
--------------------------------------------------------------------------------

Prefer
`list-tables <https://docutils.sourceforge.io/docs/ref/rst/directives.html#list-table>`_
and imported
`csv-tables <https://docutils.sourceforge.io/docs/ref/rst/directives.html#csv-table-1>`_
(using the file option), because they are faster to create, easier to maintain
and the 80 column-width rule can be respected with list-tables.

You can use the following command:

.. code:: bash

   pandoc imported.txt -f dokuwiki -t rst --columns=80 -s -o imported.rst --list-tables

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

Renders as

.. code-block:: python
   :linenos:
   :emphasize-lines: 2

   def hello_world():
       string = "Hello world"
       print(string)

Images
--------------------------------------------------------------------------------

Prefer the SVG format for images, and save it as *Optimized SVG* in
`inkscape <https://inkscape.org/>`_ to use less space.

Vivado block-diagrams
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Vivado block-diagrams can be exported as PDF and then converted to SVG with
Inkscape. See :ref:`spi_engine tutorial` for a "final result" example.

Vivado waveform data
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There is no way to export Vivado waveform data as vectors.
Therefore, the recommended method is to take a PNG screenshot and use
`GIMP <gimp.org>`_ to export as **8bpc RGB** with all metadata options
disabled.

.. note::

   Always use the *Export As..* ``Ctrl+Shift+E`` option.

To reduce even further the size, you can use *Color > Dither..* to reduce the
number of colors in the PNG.
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

.. note::

   Link-like roles use the :code:`:role:\`text <link>\`` synthax, like external
   links, but without the undescore in the end.

Color role
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To print text in red or green, use :code:`:red:\`text\`` and :code:`:green:\`text\``.

Git role
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The Git role allows to create links to the Git repository with a shorter syntax.
The role syntax is :code:`:git-repo:\`text <branch:path>\``, for example:

* :code:`:git-hdl:\`master:docs/contributing/guidelines.rst\``
  renders as :git-hdl:`master:docs/contributing/guidelines.rst`.
* :code:`:git-hdl:\`Guidelines <docs/contributing/guidelines.rst>\``
  renders as :git-hdl:`Guidelines <docs/contributing/guidelines.rst>`.

The branch field is optional and will be filled with the current branch.
The text field is optional and will be filled with the file or directory name.

Finally, you can do :code:`:git-repo:\`/\`` for a link to the root of the
repository with pretty naming, for example, :code:`:git-hdl:\`/\`` is rendered
as :git-hdl:`/`.

Part role
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The part role creates links for a part to the Analog Devices Inc. website.

The role syntax is :code:`:part:\`text <part_id>\``, for example,
:code:`:part:\`AD7175-2 <ad7175-2>\``.
Since links are case insensitive, you can also reduce it to
:code:`:part:\`AD7175-2\``, when *part_id* is the same as *text* and will render
as :part:`AD7175-2`.

Datasheet role
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The datasheet role creates links for a datasheet in the Analog Devices Inc. website.

The role syntax is :code:`:datasheet:\`part_id:anchor\``, for example,
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

The dokuwiki role creates links to the Analog Devices Inc. wiki website.
The role syntax is :code:`:dokuwiki:\`text <path>\``, for example,
:code:`:dokuwiki:\`pulsar-adc-pmods <resources/eval/user-guides/circuits-from-the-lab/pulsar-adc-pmods>\``
gets rendered as
:dokuwiki:`pulsar-adc-pmods <resources/eval/user-guides/circuits-from-the-lab/pulsar-adc-pmods>`.

EngineerZone role
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ez role creates links to the Analog Devices Inc. EngineerZone support website.
The role syntax is :code:`:ez:\`community\``, for example, :code:`:ez:\`fpga\``
gets rendered as :ez:`fpga`.

For Linux Software Drivers, it is :code:`:ez:\`linux-software-drivers\``.

For Microcontroller no-OS Drivers it is :code:`:ez:\`microcontroller-no-os-drivers\``.

Vendor role
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The vendor role creates links to the vendor's website.
The role syntax is :code:`:vendor:\`text <path>\``, for example,
:code:`:xilinx:\`Zynq-7000 SoC Overview <support/documentation/data_sheets/ds190-Zynq-7000-Overview.pdf>\``
gets rendered
:xilinx:`Zynq-7000 SoC Overview <support/documentation/data_sheets/ds190-Zynq-7000-Overview.pdf>`.

The text parameter is optional, if absent, the file name will be used as the text,
for example,
:code:`:intel:\`content/www/us/en/docs/programmable/683780/22-4/general-purpose-i-o-overview.html\``
gets rendered
:intel:`content/www/us/en/docs/programmable/683780/22-4/general-purpose-i-o-overview.html`
(not very readable).

Supported vendors are: `xilinx` and `intel`.

HDL parameters directive
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The HDL parameters directive gets information parsed from *component.xml* library
and generates a table with the IP parameters.

.. note::

   The *component.xml* files are generated by Vivado during the library build
   and not by the documentation tooling.

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

Renders as:

.. hdl-parameters::
   :path: library/spi_engine/spi_engine_interconnect

   * - DATA_WIDTH
     - Data width of the parallel SDI/SDO data interfaces.
   * - NUM_OF_SDI
     - Number of SDI lines on the physical SPI interface.

Descriptions in the directive have higher precedence than in the *component.xml*
file.

The ``:path:`` option is optional, and should **not** be included if the
documentation file path matches the *component.xml* hierarchically.

HDL interface directive
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The HDL interfaces directive gets information parsed from *component.xml* library
and generates tables with the IP interfaces, both buses and ports.

.. note::

   The *component.xml* files are generated by Vivado during the library build
   and not by the documentation tooling.

The directive syntax is:

.. code:: rst

   .. hdl-interfaces::
      :path: <ip_path>

      * - <parameter>
        - <description>

For example:

.. code:: rst

   .. hdl-interfaces::
      :path: library/spi_engine/spi_engine_interconnect

Descriptions in the directive have higher precedence than in the *component.xml*
file.
You can provide description to a port or a bus, but not for a bus port.

The ``:path:`` option is optional, and should **not** be included if the
documentation file path matches the *component.xml* hierarchically.

HDL regmap directive
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The HDL regmap directive gets information from *docs/regmap/adi_regmap_\*.txt* files
and generates tables with the register maps.

The directive syntax is:

.. code:: rst

   .. hdl-regmap::
      :name: <regmap_name>
      :no-type-info:

For example:

.. code:: rst

   .. hdl-regmap::
      :name: DMAC

.. note::

  The register map name is the title-tool, the value above ``ENDTITLE`` in the
  source file.

This directive does not support content for descriptions, since the source file
already have proper descriptions.

The ``:name:`` option is **required**, because the title tool does not match
the IP name and one single *docs/regmap/adi_regmap_\*.txt* file can have more than
one register map.
The ``:no-type-info:`` option is optional, and should **not** be included if it is
in the main IP documentation page. It appends an auxiliary table explaining the
register access types.

Collapsible directive
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The collapsible directive creates a collapsible/dropdown/"HTML details".

The directive syntax is:

.. code:: rst

   .. collapsible:: <label>

      <content>

For example:

.. code:: rst

   .. collapsible:: Python code example.

      .. code:: python

         print("Hello World!")

Renders as:

.. collapsible:: Python code example.

   .. code:: python

      print("Hello World!")

Notice how you can use any Sphinx syntax, even nest other directives.

.. _installing_pandoc:

Global options for HDL directives
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the `hide_collapsible_content` to set the default state of the collapsibles,
if you set to False, they be expanded by default.

Common sections
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

and will be rendered as sections of the page.
