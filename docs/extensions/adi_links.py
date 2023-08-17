###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

from docutils import nodes
import subprocess 

# Default values
dft_url_datasheet	= 'https://www.analog.com/media/en/technical-documentation/data-sheets/'
dft_url_dokuwiki	= 'https://wiki.analog.com'
dft_url_ez			= 'https://ez.analog.com'
dft_url_git			= 'https://github.com/analogdevicesinc'
dft_url_part		= 'https://www.analog.com'
dft_url_xilinx		= 'https://www.xilinx.com'
dft_url_intel		= 'https://www.intel.com'

git_repos = [
	# url_path           name
	['hdl',              "HDL"],
	['testbenches',      "Testbenches"],
	['linux',            "Linux"],
	['no-os',            "no-OS"],
	['libiio',           "libiio"],
	['scopy',            "Scopy"],
	['iio-oscilloscope', "IIO Oscilloscope"]
]
vendors = ['xilinx', 'intel']

def get_url_config(name, inliner):
	app = inliner.document.settings.env.app
	return getattr(app.config, "url_"+name)

def get_outer_inner(text):
	"""
	Extract 'outer <inner>' fields.
	"""
	pos = text.find('<')
	if pos != -1 and text[len(text)-1] == '>':
		return (text[0:pos].strip(), text[pos+1:-1])
	else:
		return (None, text)

def datasheet():
	def role(name, rawtext, text, lineno, inliner, options={}, content=[]):
		if text.find(':') in [0, -1]:
			url = get_url_config('datasheet', inliner) + '/' + part_id + '.pdf'
		else:
			anchor = text[text.find(':')+1:]
			part_id = text[0:text.find(':')]
			url = get_url_config('datasheet', inliner) + '/' + part_id + '.pdf#' + anchor
		node = nodes.reference(rawtext, part_id + " datasheet", refuri=url, **options)
		return [node], []
	return role

def dokuwiki():
	def role(name, rawtext, text, lineno, inliner, options={}, content=[]):
		text, path = get_outer_inner(text)
		if text is None:
			text = path[path.rfind('/')+1:]
		url = get_url_config('dokuwiki', inliner) + '/' + path
		node = nodes.reference(rawtext, text, refuri=url, **options)
		return [node], []
	return role

def ez():
	def role(name, rawtext, text, lineno, inliner, options={}, content=[]):
		url = get_url_config('ez', inliner) + '/' + text
		node = nodes.reference(rawtext, "EngineerZone", refuri=url, **options)
		return [node], []
	return role


def get_active_branch_name():
	branch = subprocess.run(['git', 'branch', '--show-current'], capture_output=True)
	return branch.stdout.decode('utf-8').replace('\n','')

def git(repo, alt_name):
	def role(name, rawtext, text, lineno, inliner, options={}, content=[]):
		url = get_url_config('git', inliner) + '/' + repo
		if text == '/':
			name = "ADI " + alt_name + " repository"
			node = nodes.reference(rawtext, name, refuri=url, **options)
		else:
			text, path = get_outer_inner(text)
			pos = path.find(':')
			branch = get_active_branch_name() if pos in [0, -1] else path[0:pos]
			path = path[pos+1:]
			if text is None:
				text = path[path.rfind('/')+1:]
			url = url + '/blob/' + branch + '/' + path
			node = nodes.reference(rawtext, text, refuri=url, **options)
		return [node], []
	return role

def part():
	def role(name, rawtext, text, lineno, inliner, options={}, content=[]):
		name, part_id = get_outer_inner(text)
		if name is None:
			name = part_id
		url = get_url_config('part', inliner) + '/' + part_id + '.html'
		node = nodes.reference(rawtext, name, refuri=url, **options)
		return [node], []
	return role

def vendor(vendor_name):
	def role(name, rawtext, text, lineno, inliner, options={}, content=[]):
		text, path = get_outer_inner(text)
		if text is None:
			text = path[path.rfind('/')+1:]
		url = get_url_config(vendor_name, inliner) + '/' + path
		node = nodes.reference(rawtext, text, refuri=url, **options)
		return [node], []
	return role

def setup(app):
	app.add_role("datasheet",       datasheet())
	app.add_role("dokuwiki",        dokuwiki())
	app.add_role("ez",              ez())
	app.add_role("part",            part())
	for name in vendors:
		app.add_role(name,          vendor(name))
	for path, name in git_repos:
		app.add_role("git-"+path,   git(path, name))

	app.add_config_value('url_datasheet', dft_url_datasheet, 'env')
	app.add_config_value('url_dokuwiki',  dft_url_dokuwiki,  'env')
	app.add_config_value('url_ez',        dft_url_ez,        'env')
	app.add_config_value('url_git',       dft_url_git,       'env')
	app.add_config_value('url_part',      dft_url_part,      'env')
	app.add_config_value('url_xilinx',    dft_url_xilinx,    'env')
	app.add_config_value('url_intel',     dft_url_intel,     'env')

	return {
		'version': '0.1',
		'parallel_read_safe': True,
		'parallel_write_safe': True,
	}
