-- ***************************************************************************
-- ***************************************************************************
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
