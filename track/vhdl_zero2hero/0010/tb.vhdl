library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal a, b, sum, cout : std_logic := '0';
begin
  dut : entity work.half_adder port map (a => a, b => b, sum => sum, cout => cout);
  process
    variable errc : integer := 0;
    variable v : unsigned(1 downto 0);
    variable exp : unsigned(1 downto 0);
  begin
    for i in 0 to 3 loop
      v := to_unsigned(i, 2);
      a <= v(1); b <= v(0);
      wait for 5 ns;
      exp := ('0' & a) + ('0' & b);
      if (cout & sum) /= std_logic_vector(exp) then errc := errc + 1; report "half_adder wrong" severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
