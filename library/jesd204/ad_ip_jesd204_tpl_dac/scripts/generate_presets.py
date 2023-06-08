#!/usr/bin/env python3

###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
#
# The ADI JESD204 Core is released under the following license, which is
# different than all other HDL cores in this repository.
#
# Please read this, and understand the freedoms and responsibilities you have
# by using this source code/core.
#
# The JESD204 HDL, is copyright © 2016-2023 Analog Devices Inc.
#
# This core is free software, you can use run, copy, study, change, ask
# questions about and improve this core. Distribution of source, or resulting
# binaries (including those inside an FPGA or ASIC) require you to release the
# source of the entire project (excluding the system libraries provide by the
# tools/compiler/FPGA vendor). These are the terms of the GNU General Public
# License version 2 as published by the Free Software Foundation.
#
# This core  is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License version 2
# along with this source code, and binary.  If not, see
# <http://www.gnu.org/licenses/>.
#
# Commercial licenses (with commercial support) of this JESD204 core are also
# available under terms different than the General Public License. (e.g. they
# do not require you to accompany any image (FPGA or ASIC) using the JESD204
# core with any corresponding source code.) For these alternate terms you must
# purchase a license from Analog Devices Technology Licensing Office. Users
# interested in such a license should contact jesd204-licensing@analog.com for
# more information. This commercial license is sub-licensable (if you purchase
# chips from Analog Devices, incorporate them into your PCB level product, and
# purchase a JESD204 license, end users of your product will also have a
# license to use this core in a commercial setting without releasing their
# source code).
#
# In addition, we kindly ask you to acknowledge ADI in any program, application
# or publication in which you use this JESD204 HDL core. (You are not required
# to do so; it is up to your common sense to decide whether you want to comply
# with this request or not.) For general publications, we suggest referencing :
# “The design and implementation of the JESD204 HDL Core used in this project
# is copyright © 2016-2023, Analog Devices, Inc.”
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
