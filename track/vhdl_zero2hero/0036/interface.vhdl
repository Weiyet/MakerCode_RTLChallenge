library ieee;
use ieee.std_logic_1164.all;

entity adder32 is
  port (a, b : in  std_logic_vector(31 downto 0);
        sum  : out std_logic_vector(31 downto 0));
end entity adder32;

architecture rtl of adder32 is
  -- component add16 (provided in tb.vhdl) + carry signal go here
begin
  -- your implementation here

end architecture rtl;
