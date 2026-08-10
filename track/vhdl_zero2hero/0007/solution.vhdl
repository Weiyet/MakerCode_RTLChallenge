library ieee;
use ieee.std_logic_1164.all;

entity adders is
  port (a, b, cin : in  std_logic;
        h_sum, h_cout, sum, cout : out std_logic);
end entity adders;

architecture rtl of adders is
begin
  h_sum  <= a xor b;
  h_cout <= a and b;
  sum    <= a xor b xor cin;
  cout   <= (a and b) or (a and cin) or (b and cin);
end architecture rtl;
