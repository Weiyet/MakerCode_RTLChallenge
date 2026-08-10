-- =====================================================================
-- Provided sub-entity (in tb.vhdl) - you MUST instantiate it TWICE with
-- different generic overrides.
--   entity wide_reg generic(WIDTH : integer := 8)
--       port(clk : in std_logic;
--            d   : in  std_logic_vector(WIDTH-1 downto 0);
--            q   : out std_logic_vector(WIDTH-1 downto 0));
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
entity wide_reg is
  generic (WIDTH : integer := 8);
  port (clk : in  std_logic;
        d   : in  std_logic_vector(WIDTH-1 downto 0);
        q   : out std_logic_vector(WIDTH-1 downto 0));
end entity wide_reg;
architecture rtl of wide_reg is
begin
  process(clk) begin
    if rising_edge(clk) then q <= d; end if;
  end process;
end architecture rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal clk : std_logic := '0';
  signal d4, q4, e4   : std_logic_vector(3 downto 0)  := (others => '0');
  signal d12, q12, e12 : std_logic_vector(11 downto 0) := (others => '0');
begin
  clk <= not clk after 5 ns;
  dut : entity work.param_inst port map (clk => clk, d4 => d4, q4 => q4, d12 => d12, q12 => q12);
  process(clk) begin
    if rising_edge(clk) then e4 <= d4; e12 <= d12; end if;
  end process;
  process
    variable s1 : positive := 3; variable s2 : positive := 88; variable r : real;
    variable errc : integer := 0;
  begin
    d4 <= (others => '0'); d12 <= (others => '0');
    wait until falling_edge(clk);
    for i in 0 to 39 loop
      uniform(s1, s2, r); d4  <= std_logic_vector(to_unsigned(integer(r * 15.0), 4));
      uniform(s1, s2, r); d12 <= std_logic_vector(to_unsigned(integer(r * 4095.0), 12));
      wait until rising_edge(clk); wait for 1 ns;
      if q4  /= e4  then errc := errc + 1; report "q4 wrong"  severity error; end if;
      if q12 /= e12 then errc := errc + 1; report "q12 wrong" severity error; end if;
      wait until falling_edge(clk);
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
