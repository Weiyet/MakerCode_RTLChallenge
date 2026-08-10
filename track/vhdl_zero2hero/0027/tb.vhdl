library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal clk : std_logic := '0';
  signal rst_n, sig, rise, fall : std_logic := '0';
begin
  clk <= not clk after 5 ns;
  dut : entity work.edge_detector port map (clk => clk, rst_n => rst_n, sig => sig, rise => rise, fall => fall);

  process
    variable errc : integer := 0;
    variable s1 : positive := 3; variable s2 : positive := 19; variable r : real;
    variable prev, sv, er, ef : std_logic;
  begin
    rst_n <= '0'; sig <= '0';
    wait until falling_edge(clk); wait until falling_edge(clk);
    rst_n <= '1'; prev := '0';
    for i in 0 to 60 loop
      wait until falling_edge(clk);
      uniform(s1, s2, r); if r >= 0.5 then sv := '1'; else sv := '0'; end if;
      sig <= sv;
      er := sv and (not prev);
      ef := (not sv) and prev;
      prev := sv;
      wait until rising_edge(clk); wait for 1 ns;
      if rise /= er then errc := errc + 1; report "rise wrong" severity error; end if;
      if fall /= ef then errc := errc + 1; report "fall wrong" severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
