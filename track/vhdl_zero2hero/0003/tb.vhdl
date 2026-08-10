library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is
end entity tb;

architecture sim of tb is
  signal d      : std_logic_vector(15 downto 0) := (others => '0');
  signal hi, lo : std_logic_vector(7 downto 0);
begin
  dut : entity work.vector_split port map (d => d, hi => hi, lo => lo);

  process
    variable errc : integer := 0;
    variable v    : unsigned(15 downto 0) := (others => '0');
  begin
    for i in 0 to 30 loop
      d <= std_logic_vector(v);
      wait for 5 ns;
      if hi /= d(15 downto 8) then errc := errc + 1; report "hi wrong" severity error; end if;
      if lo /= d(7 downto 0)  then errc := errc + 1; report "lo wrong" severity error; end if;
      v := v + to_unsigned(4369, 16);
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
