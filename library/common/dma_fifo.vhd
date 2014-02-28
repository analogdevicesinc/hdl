library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dma_fifo is
	generic (
		RAM_ADDR_WIDTH : integer := 3;
		FIFO_DWIDTH : integer := 32
	);
	port (
		clk		: in  std_logic;
		resetn		: in  std_logic;
		fifo_reset	: in  std_logic;

		-- Write port
		in_stb		: in  std_logic;
		in_ack		: out std_logic;
		in_data		: in  std_logic_vector(FIFO_DWIDTH-1 downto 0);

		-- Read port
		out_stb		: out std_logic;	
		out_ack		: in  std_logic;
		out_data	: out std_logic_vector(FIFO_DWIDTH-1 downto 0)
	);
end;

architecture imp of dma_fifo is

	constant FIFO_MAX		: natural := 2**RAM_ADDR_WIDTH -1;
	type MEM is array (0 to FIFO_MAX) of std_logic_vector(FIFO_DWIDTH - 1 downto 0);
	signal data_fifo		: MEM;
	signal wr_addr			: natural range 0 to FIFO_MAX;
	signal rd_addr			: natural range 0 to FIFO_MAX;
	signal full, empty		: Boolean;

begin
	in_ack <= '0' when full else '1';

	out_stb <= '0' when empty else '1';
	out_data <= data_fifo(rd_addr);

	fifo: process (clk) is
		variable free_cnt : integer range 0 to FIFO_MAX + 1;
	begin
		if rising_edge(clk) then
			if (resetn = '0') or (fifo_reset = '1') then
				wr_addr <= 0;
				rd_addr <= 0;
				free_cnt := FIFO_MAX + 1;
				empty <= True;
				full <= False;
			else
				if in_stb = '1' and not full then
					data_fifo(wr_addr) <= in_data;
					wr_addr <= (wr_addr + 1) mod (FIFO_MAX + 1);
					free_cnt := free_cnt - 1;
				end if;

				if out_ack = '1' and not empty then
					rd_addr <= (rd_addr + 1) mod (FIFO_MAX + 1);
					free_cnt := free_cnt + 1;
				end if;

				full <= free_cnt = 0;
				empty <= free_cnt = FIFO_MAX + 1;
			end if;
		end if;
	end process;
end;
