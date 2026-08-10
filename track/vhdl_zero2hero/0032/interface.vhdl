library ieee;
use ieee.std_logic_1164.all;

entity inst_by_position is
  port (a, b, c, d : in  std_logic;
        out1, out2 : out std_logic);
end entity inst_by_position;

architecture rtl of inst_by_position is
  -- Declare the component for mod_a (provided in tb.vhdl), then instantiate it
  -- with a POSITIONAL port map.
begin
  -- your implementation here

end architecture rtl;
