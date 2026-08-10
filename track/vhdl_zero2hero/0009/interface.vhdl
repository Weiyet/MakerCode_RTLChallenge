library ieee;
use ieee.std_logic_1164.all;

entity byte_reverse is
  port (
    d : in  std_logic_vector(31 downto 0);
    y : out std_logic_vector(31 downto 0)
  );
end entity byte_reverse;

architecture rtl of byte_reverse is
begin
  -- your implementation here

end architecture rtl;
