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
use ieee.numeric_std.all;

entity axi_ctrlif is
	generic
	(
		C_NUM_REG			: integer			:= 32;
		C_S_AXI_DATA_WIDTH	: integer			:= 32;
		C_S_AXI_ADDR_WIDTH	: integer			:= 32;
		C_FAMILY		: string			:= "virtex6"
	);
	port
	(
		-- AXI bus interface
		S_AXI_ACLK		: in  std_logic;
		S_AXI_ARESETN		: in  std_logic;
		S_AXI_AWADDR		: in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWVALID		: in  std_logic;
		S_AXI_WDATA		: in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB		: in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID		: in  std_logic;
		S_AXI_BREADY		: in  std_logic;
		S_AXI_ARADDR		: in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARVALID		: in  std_logic;
		S_AXI_RREADY		: in  std_logic;
		S_AXI_ARREADY		: out std_logic;
		S_AXI_RDATA		: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP		: out std_logic_vector(1 downto 0);
		S_AXI_RVALID		: out std_logic;
		S_AXI_WREADY		: out std_logic;
		S_AXI_BRESP		: out std_logic_vector(1 downto 0);
		S_AXI_BVALID		: out std_logic;
		S_AXI_AWREADY		: out std_logic;

		rd_addr : out integer range 0 to C_NUM_REG - 1;
		rd_data : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		rd_ack  : out std_logic;
		rd_stb  : in  std_logic;

		wr_addr : out integer range 0 to C_NUM_REG - 1;
		wr_data : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		wr_ack  : in  std_logic;
		wr_stb  : out std_logic
	);
end entity axi_ctrlif;


architecture Behavioral of axi_ctrlif is
	type state_type is (IDLE, RESP, ACK);
	signal rd_state : state_type;
	signal wr_state : state_type;
begin
	process (S_AXI_ACLK)
	begin
		if rising_edge(S_AXI_ACLK) then
			if S_AXI_ARESETN = '0' then
				rd_state <= IDLE;
			else
				case rd_state is
				when IDLE =>
					if S_AXI_ARVALID = '1' then
						rd_state <= RESP;
						rd_addr <= to_integer(unsigned(S_AXI_ARADDR((C_S_AXI_ADDR_WIDTH-1) downto 2)));
					end if;
				when RESP =>
					if rd_stb = '1' and S_AXI_RREADY = '1' then
						rd_state <= IDLE;
					end if;
				when others => null;
				end case;
			end if;
		end if;
	end process;

	S_AXI_ARREADY <= '1' when rd_state = IDLE else '0';
	S_AXI_RVALID <= '1' when rd_state = RESP and rd_stb = '1' else '0';
	S_AXI_RRESP <= "00";
	rd_ack <= '1' when rd_state = RESP and S_AXI_RREADY = '1' else '0';
	S_AXI_RDATA <= rd_data;

	process (S_AXI_ACLK)
	begin
		if rising_edge(S_AXI_ACLK) then
			if S_AXI_ARESETN = '0' then
				wr_state <= IDLE;
			else
				case wr_state is
				when IDLE =>
					if S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and wr_ack = '1' then
						wr_state <= ACK;
					end if;
				when ACK =>
					wr_state <= RESP;
				when RESP =>
					if S_AXI_BREADY = '1' then
						wr_state <= IDLE;
					end if;
				end case;
			end if;
		end if;
	end process;

	wr_stb <= '1' when S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and wr_state = IDLE else '0';
	wr_data <= S_AXI_WDATA;
	wr_addr <= to_integer(unsigned(S_AXI_AWADDR((C_S_AXI_ADDR_WIDTH-1) downto 2)));

	S_AXI_AWREADY <= '1' when wr_state = ACK else '0';
	S_AXI_WREADY <= '1' when wr_state = ACK else '0';

	S_AXI_BRESP <= "00";
	S_AXI_BVALID <= '1' when wr_state = RESP else '0';
end;
