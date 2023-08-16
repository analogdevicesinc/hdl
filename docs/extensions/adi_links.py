from docutils import nodes
import subprocess 

# Default values
dft_url_datasheet	= 'https://www.analog.com/media/en/technical-documentation/data-sheets/'
dft_url_dokuwiki	= 'https://wiki.analog.com'
dft_url_ez			= 'https://ez.analog.com'
dft_url_git			= 'https://github.com/analogdevicesinc'
dft_url_part		= 'https://www.analog.com/products'
dft_url_xilinx		= 'https://www.xilinx.com'

def get_url_config(name, inliner):
	app = inliner.document.settings.env.app
	try:
		if not eval("app.config.url_"+name):
			raise AttributeError
	except AttributeError as err:
		raise ValueError(str(err))
	return eval("app.config.url_"+name)

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
		path = text[text.find(':')+1:]
		name = path[path.rfind('/')+1:] if text.find(':') in [0, -1] else text[0:text.find(':')]
		url = get_url_config('dokuwiki', inliner) + '/' + path
		node = nodes.reference(rawtext, name, refuri=url, **options)
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
			branch = get_active_branch_name() if text.find(':') in [0, -1] else text[0:text.find(':')]
			path = text[text.find(':')+1:]
			url = url + '/blob/' + branch + '/' + path
			node = nodes.reference(rawtext, path[path.rfind('/')+1:], refuri=url, **options)
		return [node], []
	return role

def part():
	def role(name, rawtext, text, lineno, inliner, options={}, content=[]):
		part_name = text[text.find(':')+1:]
		part_id = part_name if text.find(':') in [0, -1] else text[0:text.find(':')]
		url = get_url_config('part', inliner) + '/' + part_id + '.html'
		node = nodes.reference(rawtext, part_name, refuri=url, **options)
		return [node], []
	return role

def xilinx():
	def role(name, rawtext, text, lineno, inliner, options={}, content=[]):
		name = text[text.rfind('/')+1:] if text.find(':') in [0, -1] else text[0:text.find(':')]
		path = text[text.find(':')+1:]
		url = get_url_config('xilinx', inliner) + '/' + path
		node = nodes.reference(rawtext, name, refuri=url, **options)
		return [node], []
	return role

def setup(app):
	app.add_role("datasheet",       datasheet())
	app.add_role("dokuwiki",        dokuwiki())
	app.add_role("ez",              ez())
	app.add_role("git-hdl",         git('hdl', "HDL"))
	app.add_role("git-testbenches", git('testbenches', "Testbenches"))
	app.add_role("git-linux",       git('linux', "Linux"))
	app.add_role("part",            part())
	app.add_role("xilinx",          xilinx())

	app.add_config_value('url_datasheet', dft_url_datasheet, 'env')
	app.add_config_value('url_dokuwiki',  dft_url_dokuwiki,  'env')
	app.add_config_value('url_ez',        dft_url_ez,        'env')
	app.add_config_value('url_git',       dft_url_git,       'env')
	app.add_config_value('url_part',      dft_url_part,      'env')
	app.add_config_value('url_xilinx',    dft_url_xilinx,    'env')

	return {
		'version': '0.1',
		'parallel_read_safe': True,
		'parallel_write_safe': True,
	}
