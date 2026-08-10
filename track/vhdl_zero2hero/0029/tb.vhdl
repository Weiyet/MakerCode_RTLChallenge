library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal clk : std_logic := '0';
  signal rst_n, din, y : std_logic := '0';
begin
  clk <= not clk after 5 ns;
  dut : entity work.mealy_11 port map (clk => clk, rst_n => rst_n, din => din, y => y);

  process
    variable errc : integer := 0;
    variable s1 : positive := 11; variable s2 : positive := 31; variable r : real;
    variable st  : integer := 0;   -- 0 => S0, 1 => S1
    variable dv, ye : std_logic;
  begin
    rst_n <= '0'; din <= '0';
    wait until falling_edge(clk); wait until falling_edge(clk);
    rst_n <= '1'; st := 0;
    for i in 0 to 80 loop
      wait until falling_edge(clk);
      uniform(s1, s2, r); if r >= 0.4 then dv := '1'; else dv := '0'; end if;
      din <= dv;
      wait for 1 ns;   -- mid-cycle, Mealy output valid
      if st = 1 and dv = '1' then ye := '1'; else ye := '0'; end if;
      if y /= ye then errc := errc + 1; report "y wrong" severity error; end if;
      wait until rising_edge(clk);
      if dv = '1' then st := 1; else st := 0; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
