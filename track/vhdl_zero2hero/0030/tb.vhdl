library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal clk, rst_n, ready, valid : std_logic := '0';
  signal data : std_logic_vector(7 downto 0);
  signal expect_next : unsigned(7 downto 0) := (others => '0');
  signal got : integer := 0;
  signal errc : integer := 0;
begin
  clk <= not clk after 5 ns;
  dut : entity work.seq_src port map (clk => clk, rst_n => rst_n, ready => ready,
                                      valid => valid, data => data);
  -- consumer scoreboard: every accepted beat must be the next value in sequence
  process(clk) begin
    if rising_edge(clk) then
      if rst_n = '1' and valid = '1' and ready = '1' then
        if unsigned(data) /= expect_next then errc <= errc + 1; report "beat wrong" severity error; end if;
        expect_next <= expect_next + 1;
        got <= got + 1;
      end if;
    end if;
  end process;
  process
    variable s1 : positive := 9; variable s2 : positive := 61; variable r : real;
  begin
    rst_n <= '0'; ready <= '0';
    for i in 0 to 1 loop wait until falling_edge(clk); end loop;
    rst_n <= '1';
    for i in 0 to 299 loop
      uniform(s1, s2, r);
      if r >= 0.5 then ready <= '1'; else ready <= '0'; end if;
      wait until falling_edge(clk);
    end loop;
    if got < 20 then report "too few beats accepted" severity error; end if;
    if errc = 0 and got >= 20 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
