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

entity i2s_clkgen is
	port(
		clk		: in  std_logic; 	-- System clock 
		resetn		: in  std_logic; 	-- System reset

		enable		: in  Boolean ;	-- Enable clockgen

		tick		: in std_logic;

		bclk_div_rate	: in natural range 0 to 255;
		lrclk_div_rate	: in natural range 0 to 255;

		bclk		: out std_logic;	-- Bit Clock
		lrclk		: out std_logic;	-- Frame Clock
		channel_sync	: out std_logic;
		frame_sync	: out std_logic
	);
end i2s_clkgen;

architecture Behavioral of i2s_clkgen is
	signal reset_int : Boolean;

	signal prev_bclk_div_rate : natural range 0 to 255;
	signal prev_lrclk_div_rate : natural range 0 to 255;

	signal bclk_count : natural range 0 to 255;
	signal lrclk_count : natural range 0 to 255;

	signal bclk_int : std_logic;
	signal lrclk_int : std_logic;

	signal lrclk_tick : Boolean;
begin

	reset_int <= resetn = '0' or not enable;

	bclk <= bclk_int;
	lrclk <= lrclk_int;

-----------------------------------------------------------------------------------
-- Serial clock generation BCLK_O
-----------------------------------------------------------------------------------
	bclk_gen: process(clk)
	begin
		if rising_edge(clk) then
			prev_bclk_div_rate <= bclk_div_rate;
			if reset_int then -- or (bclk_div_rate /= prev_bclk_div_rate) then
				bclk_int <= '1';
				bclk_count <= bclk_div_rate;
			else
				if tick = '1' then
					if bclk_count = bclk_div_rate then
						bclk_count <= 0;
						bclk_int <= not bclk_int;
					else
						bclk_count <= bclk_count + 1;
					end if;
				end if;
			end if;
		end if;
	end process bclk_gen;

	lrclk_tick <= tick = '1' and bclk_count = bclk_div_rate and bclk_int = '1';

	channel_sync <= '1' when lrclk_count = 1 else '0';
	frame_sync <= '1' when lrclk_count = 1 and lrclk_int = '0' else '0';

-----------------------------------------------------------------------------------
-- Frame clock generator LRCLK_O
-----------------------------------------------------------------------------------
	lrclk_gen: process(clk)
	begin
		if rising_edge(clk) then
			prev_lrclk_div_rate <= lrclk_div_rate;
			-- Reset
			if reset_int then -- or lrclk_div_rate /= prev_lrclk_div_rate then
				lrclk_int <= '1';
				lrclk_count <= lrclk_div_rate;
			else
				if lrclk_tick then
					if lrclk_count = lrclk_div_rate then
						lrclk_count <= 0;
						lrclk_int <= not lrclk_int;
					else
						lrclk_count <= lrclk_count + 1;
					end if;
				end if;
			end if;
		end if;
	end process lrclk_gen;

end Behavioral;
