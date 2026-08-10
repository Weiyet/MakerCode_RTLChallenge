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
  -- your implementation here

end architecture rtl;
