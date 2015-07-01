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
		S_AXIS_ACLK	: in std_logic;
		S_AXIS_TREADY	: out std_logic;
		S_AXIS_TDATA	: in std_logic_vector(FIFO_DWIDTH-1 downto 0);
		S_AXIS_TLAST	: in std_logic;
		S_AXIS_TVALID	: in std_logic;

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
			in_stb => S_AXIS_TVALID,
			in_ack => in_ack,
			in_data => S_AXIS_TDATA,
			out_stb => out_stb,
			out_ack => out_ack,
			out_data => out_data
		);

	drain_process: process (S_AXIS_ACLK) is
		variable enable_d1 : Boolean;
	begin
		if rising_edge(S_AXIS_ACLK) then
			if resetn = '0' then
				drain_dma <= False;
			else
				if S_AXIS_TLAST = '1' then
					drain_dma <= False;
				elsif enable_d1 and enable then
					drain_dma <= True;
				end if;
				enable_d1 := enable;
			end if;
		end if;
	end process;

	S_AXIS_TREADY <= '1' when in_ack = '1' or drain_dma else '0';
end;
