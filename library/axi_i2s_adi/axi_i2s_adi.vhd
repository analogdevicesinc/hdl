library ieee;
use ieee.std_logic_1164.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library work;
use work.i2s_controller;

library work;
use work.axi_streaming_dma_rx_fifo;
use work.axi_streaming_dma_tx_fifo;
use work.pl330_dma_fifo;
use work.axi_ctrlif;

entity axi_i2s_adi is
	generic
	(
		-- ADD USER GENERICS BELOW THIS LINE ---------------
		C_SLOT_WIDTH		: integer := 24;
		C_LRCLK_POL		: integer := 0;		-- LRCLK Polarity (0 - Falling edge, 1 - Rising edge)
		C_BCLK_POL		: integer := 0; 	-- BCLK Polarity (0 - Falling edge, 1 - Rising edge)
		-- ADD USER GENERICS ABOVE THIS LINE ---------------

		-- DO NOT EDIT BELOW THIS LINE ---------------------
		-- Bus protocol parameters, do not add to or delete
		C_S_AXI_DATA_WIDTH	: integer			:= 32;
		C_S_AXI_ADDR_WIDTH	: integer			:= 32;
		C_FAMILY		: string			:= "virtex6";
		-- DO NOT EDIT ABOVE THIS LINE ---------------------
		C_DMA_TYPE		: integer			:= 0;
		C_NUM_CH		: integer			:= 1;
		C_HAS_TX		: integer			:= 1;
		C_HAS_RX		: integer			:= 1
	);
	port
	(
		-- Serial Data interface
		DATA_CLK_I		: in  std_logic;
		BCLK_O			: out std_logic_vector(C_NUM_CH - 1 downto 0);
		LRCLK_O			: out std_logic_vector(C_NUM_CH - 1 downto 0);
		SDATA_O			: out std_logic_vector(C_NUM_CH - 1 downto 0);
		SDATA_I			: in  std_logic_vector(C_NUM_CH - 1 downto 0);

		-- AXI Streaming DMA TX interface
		S_AXIS_ACLK		: in  std_logic;
		S_AXIS_ARESETN		: in  std_logic;
		S_AXIS_TREADY		: out std_logic;
		S_AXIS_TDATA		: in  std_logic_vector(31 downto 0);
		S_AXIS_TLAST		: in  std_logic;
		S_AXIS_TVALID		: in  std_logic;

		-- AXI Streaming DMA RX interface
		M_AXIS_ACLK		: in  std_logic;
		M_AXIS_TREADY		: in  std_logic;
		M_AXIS_TDATA		: out std_logic_vector(31 downto 0);
		M_AXIS_TLAST		: out std_logic;
		M_AXIS_TVALID		: out std_logic;
		M_AXIS_TKEEP		: out std_logic_vector(3 downto 0);

		--PL330 DMA TX interface
		DMA_REQ_TX_ACLK    : in  std_logic;
		DMA_REQ_TX_RSTN    : in  std_logic;
		DMA_REQ_TX_DAVALID : in  std_logic;
		DMA_REQ_TX_DATYPE  : in  std_logic_vector(1 downto 0);
		DMA_REQ_TX_DAREADY : out std_logic;
		DMA_REQ_TX_DRVALID : out std_logic;
		DMA_REQ_TX_DRTYPE  : out std_logic_vector(1 downto 0);
		DMA_REQ_TX_DRLAST  : out std_logic;
		DMA_REQ_TX_DRREADY : in  std_logic;

		-- PL330 DMA RX interface
		DMA_REQ_RX_ACLK    : in  std_logic;
		DMA_REQ_RX_RSTN    : in  std_logic;
		DMA_REQ_RX_DAVALID : in  std_logic;
		DMA_REQ_RX_DATYPE  : in  std_logic_vector(1 downto 0);
		DMA_REQ_RX_DAREADY : out std_logic;
		DMA_REQ_RX_DRVALID : out std_logic;
		DMA_REQ_RX_DRTYPE  : out std_logic_vector(1 downto 0);
		DMA_REQ_RX_DRLAST  : out std_logic;
		DMA_REQ_RX_DRREADY : in  std_logic;

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
		S_AXI_AWREADY		: out std_logic
	);
end entity axi_i2s_adi;

architecture Behavioral of axi_i2s_adi is

------------------------------------------
-- Signals for user logic slave model s/w accessible register example
------------------------------------------
signal i2s_reset			: std_logic;
signal tx_fifo_reset			: std_logic;
signal tx_enable			: Boolean;
signal tx_data				: std_logic_vector(C_SLOT_WIDTH - 1 downto 0);
signal tx_ack				: std_logic;
signal tx_stb				: std_logic;

signal rx_enable			: Boolean;
signal rx_fifo_reset			: std_logic;
signal rx_data				: std_logic_vector(C_SLOT_WIDTH - 1 downto 0);
signal rx_ack				: std_logic;
signal rx_stb				: std_logic;

signal const_1      : std_logic;

signal bclk_div_rate			: natural range 0 to 255;
signal lrclk_div_rate			: natural range 0 to 255;

signal period_len			: integer range 0 to 65535;

signal I2S_RESET_REG			: std_logic_vector(31 downto 0);
signal I2S_CONTROL_REG			: std_logic_vector(31 downto 0);
signal I2S_CLK_CONTROL_REG		: std_logic_vector(31 downto 0);
signal PERIOD_LEN_REG			: std_logic_vector(31 downto 0);

constant FIFO_AWIDTH			: integer := integer(ceil(log2(real(C_NUM_CH * 8))));

-- Audio samples FIFO
constant RAM_ADDR_WIDTH			: integer := 7;
type RAM_TYPE is array (0 to (2**RAM_ADDR_WIDTH - 1)) of std_logic_vector(31 downto 0);

-- RX FIFO signals
signal audio_fifo_rx			: RAM_TYPE;
signal audio_fifo_rx_wr_addr		: integer range 0 to 2**RAM_ADDR_WIDTH-1;
signal audio_fifo_rx_rd_addr		: integer range 0 to 2**RAM_ADDR_WIDTH-1;
signal tvalid				: std_logic := '0';
signal rx_tlast				: std_logic;
signal drain_tx_dma			: std_logic;

signal rx_sample			: std_logic_vector(23 downto 0);

signal wr_data : std_logic_vector(31 downto 0);
signal rd_data : std_logic_vector(31 downto 0);
signal wr_addr : integer range 0 to 11;
signal rd_addr : integer range 0 to 11;
signal wr_stb : std_logic;
signal rd_ack : std_logic;
signal tx_fifo_stb : std_logic;
signal rx_fifo_ack : std_logic;
signal cnt : integer range 0 to 2**16-1;
begin

  const_1 <= '1';

	process (S_AXI_ACLK)
	begin
		if rising_edge(S_AXI_ACLK) then
			if S_AXI_ARESETN = '0' then
				cnt <= 0;
			else
				cnt <= (cnt + 1) mod 2**16;
			end if;
		end if;
	end process;

	streaming_dma_tx_gen: if C_DMA_TYPE = 0 and C_HAS_TX = 1 generate
		tx_fifo : entity axi_streaming_dma_tx_fifo	
			generic map(
				RAM_ADDR_WIDTH => FIFO_AWIDTH,
				FIFO_DWIDTH => 24
			)
			port map(
				clk => S_AXI_ACLK,
				resetn => S_AXI_ARESETN,
				fifo_reset => tx_fifo_reset,
				enable => tx_enable,

				S_AXIS_ACLK => S_AXIS_ACLK,
				S_AXIS_TREADY => S_AXIS_TREADY,
				S_AXIS_TDATA => S_AXIS_TDATA(31 downto 8),
				S_AXIS_TLAST => S_AXIS_TLAST,
				S_AXIS_TVALID => S_AXIS_TVALID,

				out_stb => tx_stb,
				out_ack => tx_ack,
				out_data => tx_data
			);
	end generate;

	no_streaming_dma_tx_gen: if C_DMA_TYPE /= 0 or C_HAS_TX /= 1 generate
		S_AXIS_TREADY <= '0';
	end generate;

	streaming_dma_rx_gen: if C_DMA_TYPE = 0 and C_HAS_RX = 1 generate
		rx_fifo : entity axi_streaming_dma_rx_fifo	
			generic map(
				RAM_ADDR_WIDTH => FIFO_AWIDTH,
				FIFO_DWIDTH => 24
			)
			port map(
				clk => S_AXI_ACLK,
				resetn => S_AXI_ARESETN,
				fifo_reset => tx_fifo_reset,
				enable => tx_enable,

				period_len => period_len,

				in_stb => rx_stb,
				in_ack => rx_ack,
				in_data => rx_data,

				M_AXIS_ACLK => M_AXIS_ACLK,
				M_AXIS_TREADY => M_AXIS_TREADY,
				M_AXIS_TDATA => M_AXIS_TDATA(31 downto 8),
				M_AXIS_TLAST => M_AXIS_TLAST,
				M_AXIS_TVALID => M_AXIS_TVALID,
				M_AXIS_TKEEP => M_AXIS_TKEEP
			);

			M_AXIS_TDATA(7 downto 0) <= (others => '0');
	end generate;

	no_streaming_dma_rx_gen: if C_DMA_TYPE /= 0 or C_HAS_RX /= 1 generate
		M_AXIS_TDATA <= (others => '0');
		M_AXIS_TLAST <= '0';
		M_AXIS_TVALID <= '0';
		M_AXIS_TKEEP <= (others => '0');
	end generate;



	pl330_dma_tx_gen: if C_DMA_TYPE = 1 and C_HAS_TX = 1 generate
		tx_fifo_stb <= '1' when wr_addr = 11 and wr_stb = '1' else '0';

		tx_fifo: entity pl330_dma_fifo
			generic map(
				RAM_ADDR_WIDTH => FIFO_AWIDTH,
				FIFO_DWIDTH => 24,
				FIFO_DIRECTION => 0
			)
			port map (
				clk => S_AXI_ACLK,
				resetn => S_AXI_ARESETN,
				fifo_reset => tx_fifo_reset,
				enable => tx_enable,

				in_data => wr_data(31 downto 8),
				in_stb => tx_fifo_stb,

				out_ack => tx_ack,
				out_stb => tx_stb,
				out_data => tx_data,

				dclk => DMA_REQ_TX_ACLK,
				dresetn => DMA_REQ_TX_RSTN,
				davalid => DMA_REQ_TX_DAVALID,
				daready => DMA_REQ_TX_DAREADY,
				datype => DMA_REQ_TX_DATYPE,
				drvalid => DMA_REQ_TX_DRVALID,
				drready => DMA_REQ_TX_DRREADY,
				drtype => DMA_REQ_TX_DRTYPE,
				drlast => DMA_REQ_TX_DRLAST
			);
	end generate;

	no_pl330_dma_tx_gen: if C_DMA_TYPE /= 1 or C_HAS_TX /= 1 generate
		DMA_REQ_TX_DAREADY <= '0';
		DMA_REQ_TX_DRVALID <= '0';
		DMA_REQ_TX_DRTYPE <= (others => '0');
		DMA_REQ_TX_DRLAST <= '0';
	end generate;

	pl330_dma_rx_gen: if C_DMA_TYPE = 1 and C_HAS_RX = 1 generate
		rx_fifo_ack <= '1' when rd_addr = 10 and rd_ack = '1' else '0';

		rx_fifo: entity pl330_dma_fifo
			generic map(
				RAM_ADDR_WIDTH => FIFO_AWIDTH,
				FIFO_DWIDTH => 24,
				FIFO_DIRECTION => 1
			)
			port map (
				clk => S_AXI_ACLK,
				resetn => S_AXI_ARESETN,
				fifo_reset => rx_fifo_reset,
				enable => rx_enable,

				in_ack => rx_ack,
				in_stb => rx_stb,
				in_data => rx_data,

				out_data => rx_sample,
				out_ack => rx_fifo_ack,

				dclk => DMA_REQ_RX_ACLK,
				dresetn => DMA_REQ_RX_RSTN,
				davalid => DMA_REQ_RX_DAVALID,
				daready => DMA_REQ_RX_DAREADY,
				datype => DMA_REQ_RX_DATYPE,
				drvalid => DMA_REQ_RX_DRVALID,
				drready => DMA_REQ_RX_DRREADY,
				drtype => DMA_REQ_RX_DRTYPE,
				drlast => DMA_REQ_RX_DRLAST
			);

	end generate;

	no_pl330_dma_rx_gen: if C_DMA_TYPE /= 1 or C_HAS_RX /= 1 generate
		DMA_REQ_RX_DAREADY <= '0';
		DMA_REQ_RX_DRVALID <= '0';
		DMA_REQ_RX_DRTYPE <= (others => '0');
		DMA_REQ_RX_DRLAST <= '0';
	end generate;

	ctrl : entity i2s_controller
		generic map (
			C_SLOT_WIDTH => C_SLOT_WIDTH,
			C_BCLK_POL => C_BCLK_POL,
			C_LRCLK_POL => C_LRCLK_POL,
			C_NUM_CH => C_NUM_CH,
			C_HAS_TX => C_HAS_TX,
			C_HAS_RX => C_HAS_RX
		)
		port map (
			clk => S_AXI_ACLK,
			resetn => S_AXI_ARESETN,

			data_clk => DATA_CLK_I,
			BCLK_O => BCLK_O,
			LRCLK_O => LRCLK_O,
			SDATA_O => SDATA_O,
			SDATA_I => SDATA_I,

			tx_enable => tx_enable,
			tx_ack => tx_ack,
			tx_stb => tx_stb,
			tx_data => tx_data,

			rx_enable => rx_enable,
			rx_ack => rx_ack,
			rx_stb => rx_stb,
			rx_data => rx_data,

			bclk_div_rate => bclk_div_rate,
			lrclk_div_rate => lrclk_div_rate
		);

	i2s_reset		<= I2S_RESET_REG(0);
	tx_fifo_reset		<= I2S_RESET_REG(1);
	rx_fifo_reset		<= I2S_RESET_REG(2);
	tx_enable		<= I2S_CONTROL_REG(0) = '1';
	rx_enable		<= I2S_CONTROL_REG(1) = '1';
	bclk_div_rate		<= to_integer(unsigned(I2S_CLK_CONTROL_REG(7 downto 0)));
	lrclk_div_rate		<= to_integer(unsigned(I2S_CLK_CONTROL_REG(23 downto 16)));
	period_len		<= to_integer(unsigned(PERIOD_LEN_REG(15 downto 0)));

	ctrlif: entity axi_ctrlif
		generic map (
			C_S_AXI_ADDR_WIDTH => C_S_AXI_ADDR_WIDTH,
			C_S_AXI_DATA_WIDTH => C_S_AXI_DATA_WIDTH,
			C_NUM_REG => 12
		)
		port map(
			S_AXI_ACLK		=> S_AXI_ACLK,
			S_AXI_ARESETN		=> S_AXI_ARESETN,
			S_AXI_AWADDR		=> S_AXI_AWADDR,
			S_AXI_AWVALID		=> S_AXI_AWVALID,
			S_AXI_WDATA		=> S_AXI_WDATA,
			S_AXI_WSTRB		=> S_AXI_WSTRB,
			S_AXI_WVALID		=> S_AXI_WVALID,
			S_AXI_BREADY		=> S_AXI_BREADY,
			S_AXI_ARADDR		=> S_AXI_ARADDR,
			S_AXI_ARVALID		=> S_AXI_ARVALID,
			S_AXI_RREADY		=> S_AXI_RREADY,
			S_AXI_ARREADY		=> S_AXI_ARREADY,
			S_AXI_RDATA		=> S_AXI_RDATA,
			S_AXI_RRESP		=> S_AXI_RRESP,
			S_AXI_RVALID		=> S_AXI_RVALID,
			S_AXI_WREADY		=> S_AXI_WREADY,
			S_AXI_BRESP		=> S_AXI_BRESP,
			S_AXI_BVALID		=> S_AXI_BVALID,
			S_AXI_AWREADY		=> S_AXI_AWREADY,

			rd_addr			=> rd_addr,
			rd_data			=> rd_data,
			rd_ack		=> rd_ack,
			rd_stb			=> const_1,

			wr_addr			=> wr_addr,
			wr_data			=> wr_data,
			wr_ack			=> const_1,
			wr_stb			=> wr_stb
		);

	process(rd_addr, I2S_CONTROL_REG, I2S_CLK_CONTROL_REG, PERIOD_LEN_REG, rx_sample, cnt)
	begin
		case rd_addr is
			when 1 => rd_data <=  I2S_CONTROL_REG and x"00000003"; 
			when 2 => rd_data <=  I2S_CLK_CONTROL_REG and x"00ff00ff"; 
			when 6 => rd_data <= PERIOD_LEN_REG and x"0000ffff";
			when 10 => rd_data <= rx_sample & std_logic_vector(to_unsigned(cnt, 8));
			when others => rd_data <= (others => '0');
		end case;
	end process;

	process(S_AXI_ACLK) is
	begin
		if rising_edge(S_AXI_ACLK) then
			if S_AXI_ARESETN = '0' then
				I2S_RESET_REG <= (others => '0');
				I2S_CONTROL_REG <= (others => '0');
				I2S_CLK_CONTROL_REG <= (others => '0');
				PERIOD_LEN_REG <= (others => '0');
			else
				-- Auto-clear the Reset Register bits
				I2S_RESET_REG(0) <= '0';
				I2S_RESET_REG(1) <= '0';
				I2S_RESET_REG(2) <= '0';
				if wr_stb = '1' then
					case wr_addr is
						when 0 => I2S_RESET_REG <= wr_data;
						when 1 => I2S_CONTROL_REG <= wr_data;
						when 2 => I2S_CLK_CONTROL_REG <= wr_data;
						when 6 => PERIOD_LEN_REG <= wr_data;
						when others => null;
					end case;
				end if;
			end if;
		end if;
	end process;

end Behavioral;
