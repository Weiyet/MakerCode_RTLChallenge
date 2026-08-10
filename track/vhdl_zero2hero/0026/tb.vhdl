library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal clk : std_logic := '0';
  signal rst_n, en : std_logic := '0';
  signal q : std_logic_vector(7 downto 0);
begin
  clk <= not clk after 5 ns;
  dut : entity work.lfsr8 port map (clk => clk, rst_n => rst_n, en => en, q => q);

  process
    variable errc : integer := 0;
    variable s1 : positive := 2; variable s2 : positive := 29; variable r : real;
    variable m  : std_logic_vector(7 downto 0) := x"FF";
    variable ev, fbv : std_logic;
  begin
    rst_n <= '0'; en <= '0';
    wait until falling_edge(clk); wait until falling_edge(clk);
    rst_n <= '1'; m := x"FF";
    for i in 0 to 80 loop
      wait until falling_edge(clk);
      uniform(s1, s2, r); if r >= 0.5 then ev := '1'; else ev := '0'; end if;
      en <= ev;
      if ev = '1' then
        fbv := m(7) xor m(5) xor m(4) xor m(3);
        m := m(6 downto 0) & fbv;
      end if;
      wait until rising_edge(clk); wait for 1 ns;
      if q /= m then errc := errc + 1; report "lfsr wrong" severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
