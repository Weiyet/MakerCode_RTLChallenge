library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal clk, din : std_logic := '0';
  signal q : std_logic_vector(2 downto 0);
  signal gold : std_logic_vector(2 downto 0) := "000";
begin
  clk <= not clk after 5 ns;
  dut : entity work.shift3 port map (clk => clk, din => din, q => q);
  process(clk) begin
    if rising_edge(clk) then gold <= gold(1 downto 0) & din; end if;
  end process;
  process
    variable s1 : positive := 6; variable s2 : positive := 51; variable r : real;
    variable dv : std_logic; variable errc : integer := 0;
  begin
    din <= '0';
    for w in 0 to 3 loop wait until rising_edge(clk); end loop;
    wait until falling_edge(clk);
    for i in 0 to 39 loop
      uniform(s1, s2, r);
      if r >= 0.5 then dv := '1'; else dv := '0'; end if;
      din <= dv;
      wait until rising_edge(clk); wait for 1 ns;
      if q /= gold then errc := errc + 1; report "shift wrong (variable :=?)" severity error; end if;
      wait until falling_edge(clk);
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
