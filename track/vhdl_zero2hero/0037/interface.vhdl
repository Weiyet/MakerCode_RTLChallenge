library ieee;
use ieee.std_logic_1164.all;

entity addsub32 is
  port (a, b : in  std_logic_vector(31 downto 0);
        sub  : in  std_logic;
        sum  : out std_logic_vector(31 downto 0));
end entity addsub32;

architecture rtl of addsub32 is
  -- component add16 (provided in tb.vhdl), the XOR-ed b, and a carry go here
begin
  -- your implementation here

end architecture rtl;
