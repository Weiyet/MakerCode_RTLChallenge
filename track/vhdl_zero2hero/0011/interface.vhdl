library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
  port (
    a    : in  std_logic;
    b    : in  std_logic;
    cin  : in  std_logic;
    sum  : out std_logic;
    cout : out std_logic
  );
end entity full_adder;

architecture rtl of full_adder is
begin
  -- your implementation here

end architecture rtl;
