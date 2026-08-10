library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal d, bitrev, byterev : std_logic_vector(31 downto 0) := (others => '0');
begin
  dut : entity work.reverser port map (d => d, bitrev => bitrev, byterev => byterev);
  process
    variable s1 : positive := 5; variable s2 : positive := 91; variable r : real;
    variable dv, eb, ey : std_logic_vector(31 downto 0); variable errc : integer := 0;
  begin
    for t in 0 to 99 loop
      for k in 0 to 31 loop
        uniform(s1, s2, r);
        if r >= 0.5 then dv(k) := '1'; else dv(k) := '0'; end if;
      end loop;
      d <= dv; wait for 5 ns;
      for i in 0 to 31 loop eb(i) := dv(31 - i); end loop;
      ey := dv(7 downto 0) & dv(15 downto 8) & dv(23 downto 16) & dv(31 downto 24);
      if bitrev  /= eb then errc := errc + 1; report "bitrev wrong"  severity error; end if;
      if byterev /= ey then errc := errc + 1; report "byterev wrong" severity error; end if;
      wait for 5 ns;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
