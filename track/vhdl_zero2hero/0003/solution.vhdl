library ieee;
use ieee.std_logic_1164.all;

entity logic_gates is
  port (
    a      : in  std_logic;
    b      : in  std_logic;
    y_and  : out std_logic;
    y_or   : out std_logic;
    y_xor  : out std_logic;
    y_nand : out std_logic;
    y_nor  : out std_logic;
    y_xnor : out std_logic
  );
end entity logic_gates;

architecture rtl of logic_gates is
begin
  y_and  <= a and b;
  y_or   <= a or b;
  y_xor  <= a xor b;
  y_nand <= a nand b;
  y_nor  <= a nor b;
  y_xnor <= a xnor b;
end architecture rtl;
