library ieee;
use ieee.std_logic_1164.all;

entity gates is
  port (a, b : in std_logic;
        y_not, y_and, y_or, y_xor, y_nand, y_nor, y_xnor : out std_logic);
end entity gates;

architecture rtl of gates is
begin
  y_not  <= not a;
  y_and  <= a and b;
  y_or   <= a or  b;
  y_xor  <= a xor b;
  y_nand <= a nand b;
  y_nor  <= a nor  b;
  y_xnor <= a xnor b;
end architecture rtl;
