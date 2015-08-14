-- ***************************************************************************
-- ***************************************************************************
-- Copyright 2013(c) Analog Devices, Inc.
--  Author: Lars-Peter Clausen <lars-peter.clausen@analog.com>
-- 
-- All rights reserved.
-- 
-- Redistribution and use in source and binary forms, with or without modification,
-- are permitted provided that the following conditions are met:
--     - Redistributions of source code must retain the above copyright
--       notice, this list of conditions and the following disclaimer.
--     - Redistributions in binary form must reproduce the above copyright
--       notice, this list of conditions and the following disclaimer in
--       the documentation and/or other materials provided with the
--       distribution.
--     - Neither the name of Analog Devices, Inc. nor the names of its
--       contributors may be used to endorse or promote products derived
--       from this software without specific prior written permission.
--     - The use of this software may or may not infringe the patent rights
--       of one or more patent holders.  This license does not release you
--       from the requirement that you obtain separate licenses from these
--       patent holders to use this software.
--     - Use of the software either in source or binary form, must be run
--       on or directly connected to an Analog Devices Inc. component.
--    
-- THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
-- INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
-- PARTICULAR PURPOSE ARE DISCLAIMED.
--
-- IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
-- EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
-- RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
-- BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
-- STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
-- THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
