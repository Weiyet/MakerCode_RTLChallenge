library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal clk : std_logic := '0';
  signal rst_n, din, detected : std_logic := '0';
begin
  clk <= not clk after 5 ns;
  dut : entity work.seq_detector_1011 port map (clk => clk, rst_n => rst_n, din => din, detected => detected);

  process
    variable errc : integer := 0;
    variable s1 : positive := 7; variable s2 : positive := 23; variable r : real;
    variable m  : std_logic_vector(3 downto 0) := "0000";
    variable dv, de : std_logic;
  begin
    rst_n <= '0'; din <= '0';
    wait until falling_edge(clk); wait until falling_edge(clk);
    rst_n <= '1'; m := "0000";
    for i in 0 to 200 loop
      wait until falling_edge(clk);
      uniform(s1, s2, r); if r >= 0.45 then dv := '1'; else dv := '0'; end if;
      din <= dv;
      m := m(2 downto 0) & dv;
      wait until rising_edge(clk); wait for 1 ns;
      if m = "1011" then de := '1'; else de := '0'; end if;
      if detected /= de then errc := errc + 1; report "detected wrong" severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
