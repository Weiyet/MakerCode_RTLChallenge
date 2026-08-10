library ieee;
use ieee.std_logic_1164.all;

entity lfsr8 is
  port (
    clk   : in  std_logic;
    rst_n : in  std_logic;
    en    : in  std_logic;
    q     : out std_logic_vector(7 downto 0)
  );
end entity lfsr8;

architecture rtl of lfsr8 is
begin
  -- your implementation here

end architecture rtl;
