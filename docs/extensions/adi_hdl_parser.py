import os.path
from docutils import nodes
from docutils.statemachine import ViewList
from docutils.parsers.rst import Directive, directives
from sphinx.util.nodes import nested_parse_with_titles
from sphinx.util import logging
from lxml import etree

logger = logging.getLogger(__name__)

class node_parameters(nodes.Structural, nodes.Element):
	pass

def dot_fix(string):
	if (string.rfind('.') != len(string)-1):
		return string + '.'
	else:
		return string

def pretty_dep(string):
	if string is None:
		return ''
	return string.replace("'MODELPARAM_VALUE.",'').replace("'",'')

class directive_base(Directive):
	option_spec = {'path': directives.unchanged}
	has_content = True
	add_index = True
	current_doc = ''
	final_argument_whitespace = True

	def warning(self, msg):
		logger.warning(msg + f" Current file: {self.current_doc}")
	def info(self, msg):
		logger.info(msg + f" Current file: {self.current_doc}")

	def get_descriptions(self, content):
		items = {}
		key = ''
		for line in content:
			if line.startswith('* -'):
				key = line[line.find('* -')+3:].split()[0]
				items[key] = []
			else:
				items[key].append(line)
		for key in items:
			items[key] = ' '.join(items[key]).strip().replace('- ', '', 1)
		return items

	def generic_table(self, description):
		tgroup = nodes.tgroup(cols=2)
		for _ in range(2):
			colspec = nodes.colspec(colwidth=1)
			tgroup.append(colspec)
		table = nodes.table()
		table += tgroup

		self.table_header(tgroup, ["Name", "Description"])

		rows = []
		for key in description:
			row = nodes.row()
			entry = nodes.entry()
			entry += nodes.literal(text="{:s}".format(key))
			row += entry
			entry = nodes.entry()
			rst = ViewList()
			rst.append(description[key], "virtual_"+self.current_doc, 0)
			node = nodes.section()
			node.document = self.state.document
			nested_parse_with_titles(self.state, rst, node)
			entry += node
			row += entry
			rows.append(row)

		tbody = nodes.tbody()
		tbody.extend(rows)
		tgroup += tbody

		return table

	def table_header(self, tgroup, columns):
		thead = nodes.thead()
		tgroup += thead
		row = nodes.row()

		for header_name in columns:
			entry = nodes.entry()
			entry += nodes.paragraph(text=header_name)
			row += entry

		thead.append(row)

class directive_interfaces(directive_base):
	required_arguments = 0
	optional_arguments = 0

	def tables(self, content, component):
		description = self.get_descriptions(content)

		if component is None:
			return self.generic_table(description)

		node_tables = nodes.section()

		bs = component['bus_interface']
		for tag in bs:
			section = nodes.section(ids=[f"virtual_{self.current_doc}_bus_interface_{tag}"])
			title = nodes.title(text=tag)
			section += title
			if bs[tag]['dependency'] is not None:
				dependency = nodes.paragraph(text=f"Depends on {pretty_dep(bs[tag]['dependency'])}.")
				section += dependency
			if tag in description:
				rst = ViewList()
				rst.append(description[tag], "virtual_"+self.current_doc, 0)
				node = nodes.section()
				node.document = self.state.document
				nested_parse_with_titles(self.state, rst, node)
				section += node

			tgroup = nodes.tgroup(cols=3)
			for _ in range(3):
				colspec = nodes.colspec(colwidth=1)
				tgroup.append(colspec)
			table = nodes.table()
			table += section
			table += tgroup

			self.table_header(tgroup, ["Physical Port", "Logical Port", "Direction"])

			rows = []
			pm = bs[tag]['port_map']
			for key in pm:
				row = nodes.row()
				entry = nodes.entry()
				entry += nodes.literal(text=key)
				row += entry
				entry = nodes.entry()
				entry += nodes.literal(text=pm[key]['logical_port'])
				row += entry
				entry = nodes.entry()
				entry += nodes.paragraph(text=pm[key]['direction'])
				row += entry
				rows.append(row)

			tbody = nodes.tbody()
			tbody.extend(rows)
			tgroup += tbody
			node_tables += table

		section = nodes.section(ids=[f"virtual_{self.current_doc}_ports"])
		title = nodes.title(text="Ports")
		section += title
		tgroup = nodes.tgroup(cols=4)
		for _ in range(4):
			colspec = nodes.colspec(colwidth=1)
			tgroup.append(colspec)
		table = nodes.table()
		table += section
		table += tgroup

		self.table_header(tgroup, ["Physical Port", "Description", "Direction", "Dependency"])

		rows = []
		pr = component['ports']
		for key in pr:
			row = nodes.row()
			entry = nodes.entry()
			entry += nodes.literal(text=key)
			row += entry
			entry = nodes.entry()
			if key in description:
				rst = ViewList()
				rst.append(description[key], "virtual_"+self.current_doc, 0)
				node = nodes.section()
				node.document = self.state.document
				nested_parse_with_titles(self.state, rst, node)
				entry += node
			else:
				entry += nodes.paragraph(text='')
			row += entry
			entry = nodes.entry()
			entry += nodes.paragraph(text=pr[key]['direction'])
			row += entry
			entry = nodes.entry()
			entry += nodes.paragraph(text=pretty_dep(pr[key]['dependency']))
			row += entry
			rows.append(row)

		tbody = nodes.tbody()
		tbody.extend(rows)
		tgroup += tbody
		node_tables += table

		return node_tables

	def run(self):
		env = self.state.document.settings.env
		self.current_doc = env.doc2path(env.docname)

		node = node_parameters()

		if 'path' in self.options:
			lib_name = self.options['path']
		else:
			lib_name = env.docname.replace('/index', '')

		subnode = nodes.section(ids=["hdl-interfaces"])
		if lib_name in env.component:
			subnode += self.tables(self.content, env.component[lib_name])
		else:
			subnode += self.tables(self.content, None)

		node += subnode

		return [ node ]

class directive_parameters(directive_base):
	required_arguments = 0
	optional_arguments = 0

	def tables(self, content, parameter):
		description = self.get_descriptions(content)

		if parameter is None:
			return self.generic_table(description)

		tgroup = nodes.tgroup(cols=5)
		for _ in range(5):
			colspec = nodes.colspec(colwidth=1)
			tgroup.append(colspec)
		table = nodes.table()
		table += tgroup

		self.table_header(tgroup, ["Name", "Description", "Type", "Default Value", "Choices/Range"])

		rows = []
		for key in parameter:
			row = nodes.row()
			entry = nodes.entry()
			entry += nodes.literal(text="{:s}".format(key))
			row += entry
			entry = nodes.entry()
			if key in description:
				rst = ViewList()
				rst.append(description[key], "virtual_"+self.current_doc, 0)
				node = nodes.section()
				node.document = self.state.document
				nested_parse_with_titles(self.state, rst, node)
				entry += node
			else:
				entry += nodes.paragraph(text=dot_fix(parameter[key]['description']))
			row += entry
			for tag in ['type', 'default']:
				entry = nodes.entry()
				entry += nodes.paragraph(text=parameter[key][tag].title())
				row += entry
			crange = []
			if parameter[key]['choices'] is not None:
				crange.append(parameter[key]['choices'])
			if parameter[key]['range'] is not None:
				crange.append(parameter[key]['range'])
			crange = '. '.join(crange)
			entry = nodes.entry()
			entry += nodes.paragraph(text=crange)
			row += entry

			rows.append(row)

		tbody = nodes.tbody()
		tbody.extend(rows)
		tgroup += tbody

		for tag in description:
			if tag not in parameter:
					self.warning(f"{tag} does not exist in {file_2}!")

		return table

	def run(self):
		env = self.state.document.settings.env
		self.current_doc = env.doc2path(env.docname)

		node = node_parameters()

		if 'path' in self.options:
			lib_name = self.options['path']
		else:
			lib_name = env.docname.replace('/index', '')

		subnode = nodes.section(ids=["hdl-parameters"])
		if lib_name in env.component:
			subnode += self.tables(self.content, env.component[lib_name]['parameters'])
		else:
			subnode += self.tables(self.content, None)

		node += subnode

		return [ node ]

def visit_node_parameters(self, node):
	pass

def depart_node_parameters(self, node):
	pass

def parse_hdl_component(path, ctime):
	component = {
		'bus_interface':{},
		'ports': {},
		'parameters': {},
		'ctime': ctime
	}

	def get_namespaces( item):
		nsmap = item.nsmap
		for i in ['spirit', 'xilinx', 'xsi']:
			if i not in nsmap:
				raise Exception(f"Required namespace {i} not in file!")

		return (nsmap['spirit'], nsmap['xilinx'], nsmap['xsi'])

	def get( item, local_name):
		items = get_all(item, local_name)
		if len(items) == 0:
			return None
		else:
			return items[0]

	def get_all( item, local_name):
		template = "/*[local-name()='%s']"
		if not isinstance(local_name, str):
			raise Exception("Got wrong type, only Strings are allowed")
		local_name = local_name.split('/')
		return item.xpath('.' + ''.join([template % ln for ln in local_name]))

	def sattrib( item, attr):
		nonlocal spirit
		return item.get(f"{{{spirit}}}{attr}")

	def xattrib( item, attr):
		nonlocal xilinx
		return item.get(f"{{{xilinx}}}{attr}")

	def stag( item):
		nonlocal spirit
		return item.tag.replace(f"{{{spirit}}}",'')

	def xtag( item):
		nonlocal xilinx
		return item.tag.replace(f"{{{xilinx}}}",'')

	def clean_dependency( string):
		return string[string.find("'"): string.rfind(')')].replace(')','')

	def get_dependency( item, type_=None):
		if type_ is None:
			type_ = stag(item)

		dependency = get(item, f"vendorExtensions/{type_}Info/enablement/isEnabled")
		if dependency is None:
			return None
		else:
			return clean_dependency(xattrib(dependency, 'dependency'))

	def get_range( item):
		min_ = sattrib(item, 'minimum')
		max_ = sattrib(item, 'maximum')
		if max_ == None or min_ == None:
			return None
		else:
			return f"From {min_} to {max_}."

	def get_choice_type( name):
		return name[name.find('_')+1:name.rfind('_')]

	root = etree.parse(path).getroot()
	spirit, xilinx, _ = get_namespaces(root)
	vendor = get(root, 'vendor').text
	name = get(root, 'name').text

	bs = component['bus_interface']
	for bus_interface in get_all(root, 'busInterfaces/busInterface'):
		bus_name = get(bus_interface, 'name').text
		bs[bus_name] = {
			'name': sattrib(get(bus_interface, 'busType'), 'name'),
			'dependency': get_dependency(bus_interface, 'busInterface'),
			'port_map': {}
		}

		pm = bs[bus_name]['port_map']
		for port_map in get_all(bus_interface, 'portMaps/portMap'):
			pm[get(port_map, 'physicalPort/name').text] = {
				'logical_port': get(port_map, 'logicalPort/name').text,
				'direction': None
			}

	lport = component['ports']
	for port in get_all(root, 'model/ports/port'):
		port_name = get(port, 'name').text
		port_direction = get(port, 'wire/direction').text

		found = False
		for bus in bs:
			if port_name in bs[bus]['port_map']:
				found = True
				bs[bus]['port_map'][port_name]['direction'] = port_direction
				break;

		if found == False:
			lport[port_name] = {
				'direction': port_direction,
				'dependency': get_dependency(port, 'port')
			}
	pr = component['parameters']
	for parameter in get_all(root, 'parameters/parameter'):
		param_description = get(parameter, 'displayName')
		if param_description is not None:
			param_name = get(parameter, 'name').text
			param_value = get(parameter, 'value')
			pr[param_name] = {
				'description': param_description.text,
				'default': param_value.text,
				'type': sattrib(param_value, 'format'),
				'_choice_ref': sattrib(param_value, 'choiceRef'),
				'choices': None,
				'range': get_range(param_value)
			}

	for choice in get_all(root, 'choices/choice'):
		name = get(choice, 'name').text
		for key in pr:
			if pr[key]['_choice_ref'] == name:
				type_ = get_choice_type(name)
				values = get_all(choice, 'enumeration')
				string = []
				if type_ == 'pairs':
					for v in values:
						string.append(f"{sattrib(v, 'text')} ({v.text})")
				elif type_ == 'list':
					for v in values:
						string.append(v.text)
				else:
					break
				pr[key]['choices'] = ', '.join(string)
				break

	return component

def manage_hdl_components(app, env, docnames):
	libraries =  [[k.replace('/index',''), k] for k in env.found_docs if k.find('library/') == 0]

	if not hasattr(env, 'component'):
		env.component = {}
	cp = env.component
	for lib in list(cp):
		f = f"../{lib}/component.xml"
		if not os.path.isfile(f):
			del cp[lib]

	for lib, doc in libraries:
		f = f"../{lib}/component.xml"
		if not os.path.isfile(f):
			continue
		ctime = os.path.getctime(f)
		if lib in cp and cp[lib]['ctime'] >= ctime:
			pass
		else:
			cp[lib] = parse_hdl_component(f, ctime)
			docnames.append(doc)

def setup(app):
	app.add_directive('hdl-parameters', directive_parameters)
	app.add_directive('hdl-interfaces', directive_interfaces)
	app.add_node(node_parameters,
			html=(visit_node_parameters, depart_node_parameters),
			latex=(visit_node_parameters, depart_node_parameters),
			text=(visit_node_parameters, depart_node_parameters))

	app.connect('env-before-read-docs', manage_hdl_components)

	return {
		'version': '0.1',
		'parallel_read_safe': True,
		'parallel_write_safe': True,
	}
