library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder2to4 is
  port (
    code : in  std_logic_vector(1 downto 0);
    en   : in  std_logic;
    y    : out std_logic_vector(3 downto 0)
  );
end entity decoder2to4;

architecture rtl of decoder2to4 is
begin
  -- your implementation here

end architecture rtl;
