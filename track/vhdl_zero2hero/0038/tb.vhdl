library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal a, b, mx, absdiff : std_logic_vector(7 downto 0) := (others => '0');
  signal sum : std_logic_vector(8 downto 0);
begin
  dut : entity work.stats
    port map (a => a, b => b, mx => mx, sum => sum, absdiff => absdiff);

  process
    variable s1 : positive := 3; variable s2 : positive := 17; variable r : real;
    variable av, bv, emx, ead : unsigned(7 downto 0);
    variable es : unsigned(8 downto 0);
    variable errc : integer := 0;
  begin
    for i in 0 to 79 loop
      uniform(s1, s2, r); av := to_unsigned(integer(r * 255.0), 8);
      uniform(s1, s2, r); bv := to_unsigned(integer(r * 255.0), 8);
      a <= std_logic_vector(av); b <= std_logic_vector(bv);
      wait for 5 ns;
      if av > bv then emx := av; else emx := bv; end if;
      es := resize(av, 9) + resize(bv, 9);
      if av > bv then ead := av - bv; else ead := bv - av; end if;
      if mx      /= std_logic_vector(emx) then errc := errc + 1; report "mx wrong"      severity error; end if;
      if sum     /= std_logic_vector(es)  then errc := errc + 1; report "sum wrong"     severity error; end if;
      if absdiff /= std_logic_vector(ead) then errc := errc + 1; report "absdiff wrong" severity error; end if;
      wait for 5 ns;
    end loop;
    if errc = 0 then report "Test PASS" severity note;
    else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
