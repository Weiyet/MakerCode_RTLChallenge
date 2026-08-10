library ieee;
use ieee.std_logic_1164.all;

entity inst_by_position is
  port (a, b, c, d : in  std_logic;
        out1, out2 : out std_logic);
end entity inst_by_position;

architecture rtl of inst_by_position is
  component mod_a
    port (out1, out2 : out std_logic; a, b, c, d : in std_logic);
  end component;
begin
  u_a : mod_a port map (out1, out2, a, b, c, d);
end architecture rtl;
