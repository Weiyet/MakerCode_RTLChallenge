-- =====================================================================
-- Provided sub-entity -- you MUST instantiate this in your block.
--   entity mod_a port(out1,out2 : out std_logic;
--                     a,b,c,d   : in  std_logic);
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
entity mod_a is
  port (out1, out2 : out std_logic;
        a, b, c, d : in  std_logic);
end entity mod_a;
architecture rtl of mod_a is
begin
  out1 <= (a and b) or (c and d);
  out2 <= (a or b) and (c or d);
end architecture rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal a, b, c, d, out1, out2 : std_logic := '0';
begin
  dut : entity work.inst_by_position
    port map (a => a, b => b, c => c, d => d, out1 => out1, out2 => out2);

  process
    variable vi : unsigned(3 downto 0);
    variable e1, e2 : std_logic;
    variable errc : integer := 0;
  begin
    for i in 0 to 15 loop
      vi := to_unsigned(i, 4);
      a <= vi(3); b <= vi(2); c <= vi(1); d <= vi(0);
      wait for 5 ns;
      e1 := (a and b) or (c and d);
      e2 := (a or b) and (c or d);
      if out1 /= e1 then errc := errc + 1; report "out1 wrong" severity error; end if;
      if out2 /= e2 then errc := errc + 1; report "out2 wrong" severity error; end if;
      wait for 5 ns;
    end loop;
    if errc = 0 then report "Test PASS" severity note;
    else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
