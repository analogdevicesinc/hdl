library ieee;
use ieee.std_logic_1164.all;

library work;
use work.dma_fifo;

entity axi_streaming_dma_rx_fifo is
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

		period_len	: in integer range 0 to 65535;

		-- Read port
		M_AXIS_ACLK	: in std_logic;
		M_AXIS_TREADY	: in std_logic;
		M_AXIS_TDATA	: out std_logic_vector(FIFO_DWIDTH-1 downto 0);
		M_AXIS_TLAST	: out std_logic;
		M_AXIS_TVALID	: out std_logic;
		M_AXIS_TKEEP	: out std_logic_vector(3 downto 0);

		-- Write port
		in_stb		: in std_logic;
		in_ack		: out std_logic;
		in_data		: in std_logic_vector(FIFO_DWIDTH-1 downto 0)
	);
end;

architecture imp of axi_streaming_dma_rx_fifo is
	signal out_stb : std_logic;

	signal period_count		: integer range 0 to 65535;
	signal last			: std_logic;
begin

	M_AXIS_TVALID <= out_stb;

	fifo: entity dma_fifo
		generic map (
			RAM_ADDR_WIDTH => RAM_ADDR_WIDTH,
			FIFO_DWIDTH => FIFO_DWIDTH
		)
		port map (
			clk => clk,
			resetn => resetn,
			fifo_reset => fifo_reset,
			in_stb => in_stb,
			in_ack => in_ack,
			in_data => in_data,
			out_stb => out_stb,
			out_ack => M_AXIS_TREADY,
			out_data => M_AXIS_TDATA
		);

	M_AXIS_TKEEP <= "1111";
	M_AXIS_TLAST <= '1' when period_count = 0 else '0';

	period_counter: process(M_AXIS_ACLK) is
	begin
		if resetn = '0' then
			period_count <= period_len;
		else
			if out_stb = '1' and M_AXIS_TREADY = '1' then
				if period_count = 0 then
					period_count <= period_len;
				else
					period_count <= period_count - 1;
				end if;
			end if;
		end if;
	end process;
end;
