library ieee;
use ieee.std_logic_1164.all;

library work;
use work.dma_fifo;

entity axi_streaming_dma_tx_fifo is
	generic (
		RAM_ADDR_WIDTH : integer := 3;
		FIFO_DWIDTH : integer := 32 
	);
	port (
		clk		: in std_logic;
		resetn		: in std_logic;
		fifo_reset	: in std_logic;

		-- Enable DMA interface
		enable		: in Boolean;

		-- Write port
		s_axis_aclk	: in std_logic;
		s_axis_tready	: out std_logic;
		s_axis_tdata	: in std_logic_vector(FIFO_DWIDTH-1 downto 0);
		s_axis_tlast	: in std_logic;
		s_axis_tvalid	: in std_logic;

		-- Read port
		out_stb		: out std_logic;
		out_ack		: in std_logic;
		out_data	: out std_logic_vector(FIFO_DWIDTH-1 downto 0)
	);
end;

architecture imp of axi_streaming_dma_tx_fifo is
	signal in_ack			: std_logic;
	signal drain_dma		: Boolean;
begin

	fifo: entity dma_fifo
		generic map (
			RAM_ADDR_WIDTH => RAM_ADDR_WIDTH,
			FIFO_DWIDTH => FIFO_DWIDTH
		)
		port map (
			clk => clk,
			resetn => resetn,
			fifo_reset => fifo_reset,
			in_stb => s_axis_tvalid,
			in_ack => in_ack,
			in_data => s_axis_tdata,
			out_stb => out_stb,
			out_ack => out_ack,
			out_data => out_data
		);

	drain_process: process (s_axis_aclk) is
		variable enable_d1 : Boolean;
	begin
		if rising_edge(s_axis_aclk) then
			if resetn = '0' then
				drain_dma <= False;
			else
				if s_axis_tlast = '1' then
					drain_dma <= False;
				elsif enable_d1 and enable then
					drain_dma <= True;
				end if;
				enable_d1 := enable;
			end if;
		end if;
	end process;

	s_axis_tready <= '1' when in_ack = '1' or drain_dma else '0';
end;
