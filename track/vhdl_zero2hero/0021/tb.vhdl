library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal clk : std_logic := '0';
  signal d, q : std_logic := '0';
begin
  clk <= not clk after 5 ns;
  dut : entity work.dff port map (clk => clk, d => d, q => q);

  process
    variable errc : integer := 0;
    variable s1 : positive := 3; variable s2 : positive := 9; variable r : real;
    variable dv : std_logic;
  begin
    for i in 0 to 40 loop
      wait until falling_edge(clk);
      uniform(s1, s2, r);
      if r >= 0.5 then dv := '1'; else dv := '0'; end if;
      d <= dv;
      wait until rising_edge(clk);
      wait for 1 ns;
      if q /= dv then errc := errc + 1; report "dff wrong" severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
