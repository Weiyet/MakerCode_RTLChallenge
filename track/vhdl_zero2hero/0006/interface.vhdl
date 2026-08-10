library ieee;
use ieee.std_logic_1164.all;

entity reverser is
  port (d       : in  std_logic_vector(31 downto 0);
        bitrev  : out std_logic_vector(31 downto 0);
        byterev : out std_logic_vector(31 downto 0));
end entity reverser;

architecture rtl of reverser is
begin
  -- your implementation here

end architecture rtl;
