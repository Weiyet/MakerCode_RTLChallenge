library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.env.all;

entity tb is generic (W : integer := 8); end entity tb;
architecture sim of tb is
  signal clk : std_logic := '0';
  signal rst_n, en : std_logic := '0';
  signal d, q : std_logic_vector(W-1 downto 0) := (others => '0');
begin
  clk <= not clk after 5 ns;
  dut : entity work.enable_register generic map (W => W)
        port map (clk => clk, rst_n => rst_n, en => en, d => d, q => q);

  process
    variable errc : integer := 0;
    variable s1 : positive := 6; variable s2 : positive := 17; variable r : real;
    variable m  : std_logic_vector(W-1 downto 0) := (others => '0');
    variable ev : std_logic; variable dv : std_logic_vector(W-1 downto 0);
  begin
    rst_n <= '0'; en <= '0';
    wait until falling_edge(clk); wait until falling_edge(clk);
    rst_n <= '1'; m := (others => '0');
    for i in 0 to 60 loop
      wait until falling_edge(clk);
      uniform(s1, s2, r); if r >= 0.5 then ev := '1'; else ev := '0'; end if;
      uniform(s1, s2, r); dv := std_logic_vector(to_unsigned(integer(floor(r*256.0)) mod (2**W), W));
      en <= ev; d <= dv;
      if ev = '1' then m := dv; end if;
      wait until rising_edge(clk); wait for 1 ns;
      if q /= m then errc := errc + 1; report "q wrong" severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
