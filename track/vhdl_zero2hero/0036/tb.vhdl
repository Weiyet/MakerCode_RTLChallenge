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
begin
  dut : entity work.adder32 port map (a => a, b => b, sum => sum);

  process
    variable s1 : positive := 5; variable s2 : positive := 99; variable r : real;
    variable av, bv, exp : unsigned(31 downto 0); variable errc : integer := 0;
  begin
    for t in 0 to 199 loop
      uniform(s1, s2, r); av(31 downto 16) := to_unsigned(integer(r * 65535.0), 16);
      uniform(s1, s2, r); av(15 downto 0)  := to_unsigned(integer(r * 65535.0), 16);
      uniform(s1, s2, r); bv(31 downto 16) := to_unsigned(integer(r * 65535.0), 16);
      uniform(s1, s2, r); bv(15 downto 0)  := to_unsigned(integer(r * 65535.0), 16);
      a <= std_logic_vector(av); b <= std_logic_vector(bv);
      wait for 5 ns;
      exp := av + bv;
      if sum /= std_logic_vector(exp) then
        errc := errc + 1; report "adder32 wrong" severity error;
      end if;
      wait for 5 ns;
    end loop;
    if errc = 0 then report "Test PASS" severity note;
    else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
