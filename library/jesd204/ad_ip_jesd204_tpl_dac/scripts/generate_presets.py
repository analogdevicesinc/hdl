#!/usr/bin/env python3

###############################################################################
## Copyright (C) 2018 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

import math
import os
import sys

path = os.path.dirname(sys.argv[0])

f = open(os.path.join(path, 'modes.txt'))

conv = {}

for l in f:
    if l[0] == "#":
        continue

    x = l.split()
    if len(x) == 0:
        continue
    if len(x) == 1:
        name = x[0]
        modes = []
        conv[name] = modes
        continue
    modes.append(list(map(int, x)))

f.close()

for name, modes in conv.items():
    f = open(os.path.join(path, '..', '{}.qprs'.format(name)), 'w')

    f.write('<?xml version="1.0" encoding="UTF-8"?>\n<ip><presets version="17.1">\n')
    for m in modes:
        f.write('\t<preset name="{} Mode {:02d}" kind="ad_ip_jesd204_tpl_dac" version="All" description="{}">\n'.format(name, m[0], name))
        f.write('\t\t<parameter name="PART" value="{}" />\n'.format(name))
        f.write('\t\t<parameter name="NUM_CHANNELS" value="{}" />\n'.format(m[1]))
        f.write('\t\t<parameter name="NUM_LANES" value="{}" />\n'.format(m[2]))
        if math.gcd(m[4], m[3]) != 1:
            f.write('\t\t<parameter name="ENABLE_SAMPLES_PER_FRAME_MANUAL" value="1" />\n')
        else:
            f.write('\t\t<parameter name="ENABLE_SAMPLES_PER_FRAME_MANUAL" value="0" />\n')
        f.write('\t\t<parameter name="SAMPLES_PER_FRAME_MANUAL" value="{}" />\n'.format(m[3]))
        f.write('\t\t<parameter name="CONVERTER_RESOLUTION" value="{}" />\n'.format(m[6]))
        f.write('\t\t<parameter name="BITS_PER_SAMPLE" value="{}" />\n'.format(m[7]))
        f.write('\t</preset>\n')

    f.write('</presets></ip>\n')
    f.close()
