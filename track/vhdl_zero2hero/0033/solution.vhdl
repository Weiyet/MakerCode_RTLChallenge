library ieee;
use ieee.std_logic_1164.all;

entity inst_by_name is
  port (a, b, c, d : in  std_logic;
        out1, out2 : out std_logic);
end entity inst_by_name;

architecture rtl of inst_by_name is
  component mod_a
    port (out1, out2 : out std_logic; a, b, c, d : in std_logic);
  end component;
begin
  u_a : mod_a port map (a => a, b => b, c => c, d => d,
                        out1 => out1, out2 => out2);
end architecture rtl;
