library ieee;
use ieee.std_logic_1164.all;

entity reduction_ops is
  port (
    d        : in  std_logic_vector(7 downto 0);
    all_ones : out std_logic;
    any_one  : out std_logic;
    parity   : out std_logic
  );
end entity reduction_ops;

architecture rtl of reduction_ops is
begin
  all_ones <= and d;   -- VHDL-2008 reduction
  any_one  <= or d;
  parity   <= xor d;
end architecture rtl;
