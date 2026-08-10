library ieee;
use ieee.std_logic_1164.all;

entity shift3 is
  port (clk : in  std_logic;
        din : in  std_logic;
        q   : out std_logic_vector(2 downto 0));
end entity shift3;

architecture rtl of shift3 is
  -- declare a 3-bit signal and shift it with signal assignments
begin
  -- your implementation here

end architecture rtl;
