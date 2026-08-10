library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use std.env.all;

entity tb is generic (STABLE : integer := 4); end entity tb;
architecture sim of tb is
  signal clk : std_logic := '0';
  signal rst_n, noisy, clean : std_logic := '0';
begin
  clk <= not clk after 5 ns;
  dut : entity work.debouncer generic map (STABLE => STABLE)
        port map (clk => clk, rst_n => rst_n, noisy => noisy, clean => clean);

  process
    variable errc : integer := 0;
    variable s1 : positive := 4; variable s2 : positive := 15; variable r : real;
    variable m_clean : std_logic := '0';
    variable m_cnt   : integer := 0;
    variable nv : std_logic;
  begin
    rst_n <= '0'; noisy <= '0';
    wait until falling_edge(clk); wait until falling_edge(clk);
    rst_n <= '1'; m_clean := '0'; m_cnt := 0;
    for i in 0 to 200 loop
      wait until falling_edge(clk);
      if (i mod 20) < 6 then
        uniform(s1, s2, r); if r >= 0.5 then nv := '1'; else nv := '0'; end if;   -- bounce
      elsif (i mod 40) < 20 then nv := '1'; else nv := '0'; end if;               -- stable
      noisy <= nv;
      -- model
      if nv /= m_clean then
        if m_cnt = STABLE-1 then m_clean := nv; m_cnt := 0;
        else m_cnt := m_cnt + 1; end if;
      else
        m_cnt := 0;
      end if;
      wait until rising_edge(clk); wait for 1 ns;
      if clean /= m_clean then errc := errc + 1; report "clean wrong" severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
