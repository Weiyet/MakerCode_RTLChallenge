library ieee;
use ieee.std_logic_1164.all;

entity bcd_to_7seg is
  port (
    bcd : in  std_logic_vector(3 downto 0);
    seg : out std_logic_vector(6 downto 0)
  );
end entity bcd_to_7seg;

architecture rtl of bcd_to_7seg is
begin
  -- your implementation here

end architecture rtl;
