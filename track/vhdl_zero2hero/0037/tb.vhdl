-- =====================================================================
-- Provided sub-entity -- you MUST instantiate this in your block.
--   entity add16 port(a, b : in  std_logic_vector(15 downto 0);
--                     cin  : in  std_logic;
--                     sum  : out std_logic_vector(15 downto 0);
--                     cout : out std_logic);
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity add16 is
  port (a, b : in  std_logic_vector(15 downto 0);
        cin  : in  std_logic;
        sum  : out std_logic_vector(15 downto 0);
        cout : out std_logic);
end entity add16;
architecture rtl of add16 is
  signal s : unsigned(16 downto 0);
begin
  s    <= resize(unsigned(a), 17) + resize(unsigned(b), 17)
          + unsigned'(0 => cin);
  sum  <= std_logic_vector(s(15 downto 0));
  cout <= s(16);
end architecture rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal a, b, sum : std_logic_vector(31 downto 0) := (others => '0');
  signal sub : std_logic := '0';
begin
  dut : entity work.addsub32 port map (a => a, b => b, sub => sub, sum => sum);

  process
    variable s1 : positive := 13; variable s2 : positive := 77; variable r : real;
    variable av, bv, exp : unsigned(31 downto 0); variable sv : std_logic;
    variable errc : integer := 0;
  begin
    for t in 0 to 199 loop
      uniform(s1, s2, r); av(31 downto 16) := to_unsigned(integer(r * 65535.0), 16);
      uniform(s1, s2, r); av(15 downto 0)  := to_unsigned(integer(r * 65535.0), 16);
      uniform(s1, s2, r); bv(31 downto 16) := to_unsigned(integer(r * 65535.0), 16);
      uniform(s1, s2, r); bv(15 downto 0)  := to_unsigned(integer(r * 65535.0), 16);
      uniform(s1, s2, r); if r >= 0.5 then sv := '1'; else sv := '0'; end if;
      a <= std_logic_vector(av); b <= std_logic_vector(bv); sub <= sv;
      wait for 5 ns;
      if sv = '1' then exp := av - bv; else exp := av + bv; end if;
      if sum /= std_logic_vector(exp) then
        errc := errc + 1; report "addsub32 wrong" severity error;
      end if;
      wait for 5 ns;
    end loop;
    if errc = 0 then report "Test PASS" severity note;
    else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
