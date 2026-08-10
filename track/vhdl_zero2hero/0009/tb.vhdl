library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is
end entity tb;

architecture sim of tb is
  signal d, y : std_logic_vector(31 downto 0) := (others => '0');
begin
  dut : entity work.byte_reverse port map (d => d, y => y);

  process
    variable errc : integer := 0;
    variable v    : unsigned(31 downto 0) := (others => '0');
    variable exp  : std_logic_vector(31 downto 0);
  begin
    for i in 0 to 40 loop
      d <= std_logic_vector(v);
      wait for 5 ns;
      exp := d(7 downto 0) & d(15 downto 8) & d(23 downto 16) & d(31 downto 24);
      if y /= exp then errc := errc + 1; report "byte reverse wrong" severity error; end if;
      v := v + to_unsigned(16#1010101#, 32);
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
