# -- Import setup -------------------------------------------------------------

from os import path

# -- Project information ------------------------------------------------------

repository = 'hdl'
project = 'HDL'
copyright = '2024, Analog Devices, Inc.'
author = 'Analog Devices, Inc.'
version = '' # documentation version, will be printed on the cover page

# -- General configuration ----------------------------------------------------

extensions = [
    'sphinx.ext.todo',
    'sphinxcontrib.wavedrom',
    'adi_doctools',
    'rst2pdf.pdfbuilder'
]

needs_extensions = {
    'adi_doctools': '0.3.47'
}

exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']
source_suffix = '.rst'

# -- External docs configuration ----------------------------------------------

interref_repos = ['doctools', 'documentation']

# -- Custom extensions configuration ------------------------------------------

hide_collapsible_content = True
validate_links = False

# -- todo configuration -------------------------------------------------------

todo_include_todos = True
todo_emit_warnings = True

# -- Options for HTML output --------------------------------------------------

html_theme = 'cosmic'
html_static_path = ['sources']
html_css_files = ["custom.css"]
html_favicon = path.join("sources", "icon.svg")

html_theme_options = {
    "light_logo": "HDL_logo_cropped.svg",
    "dark_logo": "HDL_logo_w_cropped.svg",
}
