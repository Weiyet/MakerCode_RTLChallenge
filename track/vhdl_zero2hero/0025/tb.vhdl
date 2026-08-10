library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.env.all;

entity tb is generic (W : integer := 8); end entity tb;
architecture sim of tb is
  signal clk : std_logic := '0';
  signal rst_n, load, en, up_down : std_logic := '0';
  signal load_val, count : std_logic_vector(W-1 downto 0) := (others => '0');
begin
  clk <= not clk after 5 ns;
  dut : entity work.updown_counter generic map (W => W)
        port map (clk => clk, rst_n => rst_n, load => load, load_val => load_val,
                  en => en, up_down => up_down, count => count);

  process
    variable errc : integer := 0;
    variable s1 : positive := 5; variable s2 : positive := 11; variable r : real;
    variable m  : unsigned(W-1 downto 0) := (others => '0');
    variable ld, e, ud : std_logic; variable lv : unsigned(W-1 downto 0);
  begin
    rst_n <= '0'; load <= '0'; en <= '0'; up_down <= '1'; load_val <= (others => '0');
    wait until falling_edge(clk); wait until falling_edge(clk);
    rst_n <= '1'; m := (others => '0');
    for i in 0 to 120 loop
      wait until falling_edge(clk);
      uniform(s1, s2, r); if r < 0.15 then ld := '1'; else ld := '0'; end if;
      uniform(s1, s2, r); if r < 0.7  then e  := '1'; else e  := '0'; end if;
      uniform(s1, s2, r); if r < 0.5  then ud := '1'; else ud := '0'; end if;
      uniform(s1, s2, r); lv := to_unsigned(integer(floor(r*256.0)) mod (2**W), W);
      load <= ld; en <= e; up_down <= ud; load_val <= std_logic_vector(lv);
      if ld = '1' then m := lv;
      elsif e = '1' then if ud = '1' then m := m + 1; else m := m - 1; end if;
      end if;
      wait until rising_edge(clk); wait for 1 ns;
      if count /= std_logic_vector(m) then errc := errc + 1; report "count wrong" severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
