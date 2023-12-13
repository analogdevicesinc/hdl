-- ***************************************************************************
-- ***************************************************************************
-- Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
--
-- In this HDL repository, there are many different and unique modules, consisting
-- of various HDL (Verilog or VHDL) components. The individual modules are
-- developed independently, and may be accompanied by separate and unique license
-- terms.
--
-- The user should read each of these license terms, and understand the
-- freedoms and responsibilities that he or she has by using this source/core.
--
-- This core is distributed in the hope that it will be useful, but WITHOUT ANY
-- WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
-- A PARTICULAR PURPOSE.
--
-- Redistribution and use of source or resulting binaries, with or without modification
-- of this file, are permitted under one of the following two license terms:
--
--   1. The GNU General Public License version 2 as published by the
--      Free Software Foundation, which can be found in the top level directory
--      of this repository (LICENSE_GPL2), and also online at:
--      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
--
-- OR
--
--   2. An ADI specific BSD license, which can be found in the top level directory
--      of this repository (LICENSE_ADIBSD), and also on-line at:
--      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
--      This will allow to generate bit files and not release the source code,
--      as long as it attaches to an ADI device.
--
-- ***************************************************************************
-- ***************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library unisim;
use unisim.all;

entity util_i2c_mixer is
  generic (
    C_WIDTH: integer := 2
  );
  port (
	upstream_scl_T		: in  std_logic;
	upstream_scl_I		: in  std_logic;
	upstream_scl_O		: out std_logic;
	upstream_sda_T		: in  std_logic;
	upstream_sda_I		: in  std_logic;
	upstream_sda_O		: out std_logic;

	downstream_scl_T	: out std_logic;
	downstream_scl_I	: in  std_logic_vector(C_WIDTH - 1 downto 0);
	downstream_scl_O	: out std_logic_vector(C_WIDTH - 1 downto 0);
	downstream_sda_T	: out std_logic;
	downstream_sda_I	: in  std_logic_vector(C_WIDTH - 1 downto 0);
	downstream_sda_O	: out std_logic_vector(C_WIDTH - 1 downto 0)

  );
end util_i2c_mixer;

architecture IMP of util_i2c_mixer is
begin

upstream_scl_O <= '1' when (downstream_scl_I = (downstream_scl_I'range => '1')) else '0';
upstream_sda_O <= '1' when (downstream_sda_I = (downstream_sda_I'range => '1')) else '0';

downstream_scl_T <= upstream_scl_T;
downstream_sda_T <= upstream_sda_T;

GEN: for i in 0 to C_WIDTH - 1 generate
  downstream_scl_O(i) <= upstream_scl_I;
  downstream_sda_O(i) <= upstream_sda_I;
end generate GEN;

end IMP;
