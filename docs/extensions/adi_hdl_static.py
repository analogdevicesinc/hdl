class hdl_strings ():
	access_type = {
		'RO':{
			'name': 'Read-only',
			'description': 'Reads will return the current register value. Writes have no effect.'
		},
		'WO':{
			'name': 'Write-only',
			'description': 'Writes will change the current register value. Reads have no effect.'
		},
		'RW':{
			'name': 'Read-write',
			'description': 'Reads will return the current register value. Writes will change the current register value.'
		},
		'RW1C':{
			'name': 'Read,write-1-to-clear',
			'description': 'Reads will return the current register value. Writing the register will clear those bits of the register which were set to 1 in the value written. Bits are set by hardware.'
		},
		'RW1S':{
			'name': 'Read,write-1-to-set',
			'description': 'Reads will return the current register value. Writing the register will set those bits of the register which were set to 1 in the value written. Bits are cleared by hardware.'
		},
		'W1S':{
			'name': 'Write-1-to-set',
			'description': 'Writing the register will set those bits of the register which were set to 1 in the value written. Bits are cleared by hardware. Reads have no effect.'
		},
		'V':{
			'name': 'Volatile',
			'description': 'The V suffix indicates that the register is volatile and its content might change without software interaction. The value of registers without the volatile designation will not change without an explicit write done by software.'
		},
		'NA':{
			'name': 'No access',
			'description': 'Do not read or write the register.'
		}
	}
