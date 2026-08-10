library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use std.env.all;

entity tb is generic (W : integer := 8); end entity tb;
architecture sim of tb is
  signal clk : std_logic := '0';
  signal rst_n, sin : std_logic := '0';
  signal q : std_logic_vector(W-1 downto 0);
begin
  clk <= not clk after 5 ns;
  dut : entity work.shift_register generic map (W => W)
        port map (clk => clk, rst_n => rst_n, sin => sin, q => q);

  process
    variable errc : integer := 0;
    variable s1 : positive := 8; variable s2 : positive := 21; variable r : real;
    variable m  : std_logic_vector(W-1 downto 0) := (others => '0');
    variable sv : std_logic;
  begin
    rst_n <= '0'; sin <= '0';
    wait until falling_edge(clk); wait until falling_edge(clk);
    rst_n <= '1'; m := (others => '0');
    for i in 0 to 40 loop
      wait until falling_edge(clk);
      uniform(s1, s2, r); if r >= 0.5 then sv := '1'; else sv := '0'; end if;
      sin <= sv;
      m := m(W-2 downto 0) & sv;
      wait until rising_edge(clk); wait for 1 ns;
      if q /= m then errc := errc + 1; report "shift wrong" severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
