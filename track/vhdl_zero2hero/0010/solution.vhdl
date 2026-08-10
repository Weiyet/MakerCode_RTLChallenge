library ieee;
use ieee.std_logic_1164.all;

entity half_adder is
  port (
    a    : in  std_logic;
    b    : in  std_logic;
    sum  : out std_logic;
    cout : out std_logic
  );
end entity half_adder;

architecture rtl of half_adder is
begin
  sum  <= a xor b;
  cout <= a and b;
end architecture rtl;
