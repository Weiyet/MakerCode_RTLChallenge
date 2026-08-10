library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal clk : std_logic := '0';
  signal rst_n, d, q_sync, q_async : std_logic := '0';
begin
  clk <= not clk after 5 ns;
  dut : entity work.dff_reset port map (clk => clk, rst_n => rst_n, d => d, q_sync => q_sync, q_async => q_async);

  process
    variable errc : integer := 0;
    variable s1 : positive := 4; variable s2 : positive := 13; variable r : real;
    variable dv, es, ea, prev_s : std_logic;
  begin
    rst_n <= '0'; d <= '0';
    wait until falling_edge(clk); wait until falling_edge(clk);
    es := '0'; ea := '0';
    rst_n <= '1';
    -- synchronous equivalence loop
    for i in 0 to 40 loop
      wait until falling_edge(clk);
      uniform(s1, s2, r); if r >= 0.5 then dv := '1'; else dv := '0'; end if;
      d <= dv;
      es := dv; ea := dv;   -- rst_n high, both capture d
      wait until rising_edge(clk); wait for 1 ns;
      if q_sync  /= es then errc := errc + 1; report "q_sync wrong"  severity error; end if;
      if q_async /= ea then errc := errc + 1; report "q_async wrong" severity error; end if;
    end loop;
    -- async distinguishing test: pull reset low between edges
    wait until falling_edge(clk);
    d <= '1'; wait until rising_edge(clk); wait for 1 ns;  -- both now 1
    prev_s := q_sync;
    rst_n <= '0'; wait for 1 ns;
    if q_async /= '0'    then errc := errc + 1; report "async did not clear immediately" severity error; end if;
    if q_sync  /= prev_s then errc := errc + 1; report "sync changed without a clock edge" severity error; end if;
    rst_n <= '1'; wait until rising_edge(clk);
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
