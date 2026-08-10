library ieee;
use ieee.std_logic_1164.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal a, y, one, zero : std_logic := '0';
begin
  dut : entity work.wires_const port map (a => a, y => y, one => one, zero => zero);
  process
    variable errc : integer := 0;
  begin
    for i in 0 to 1 loop
      if i = 0 then a <= '0'; else a <= '1'; end if;
      wait for 5 ns;
      if y /= a       then errc := errc + 1; report "y wrong"    severity error; end if;
      if one /= '1'   then errc := errc + 1; report "one wrong"  severity error; end if;
      if zero /= '0'  then errc := errc + 1; report "zero wrong" severity error; end if;
      wait for 5 ns;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
