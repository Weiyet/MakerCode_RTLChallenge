library ieee;
use ieee.std_logic_1164.all;

entity vector_split is
  port (
    d  : in  std_logic_vector(15 downto 0);
    hi : out std_logic_vector(7 downto 0);
    lo : out std_logic_vector(7 downto 0)
  );
end entity vector_split;

architecture rtl of vector_split is
begin
  -- your implementation here

end architecture rtl;
