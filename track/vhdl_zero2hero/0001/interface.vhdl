library ieee;
use ieee.std_logic_1164.all;

entity gates is
  port (a, b : in std_logic;
        y_not, y_and, y_or, y_xor, y_nand, y_nor, y_xnor : out std_logic);
end entity gates;

architecture rtl of gates is
begin
  -- your implementation here

end architecture rtl;
