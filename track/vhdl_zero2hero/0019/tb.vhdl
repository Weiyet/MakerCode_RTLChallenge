library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is
  generic (WIDTH : integer := 8);
end entity tb;
architecture sim of tb is
  signal d     : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
  signal count : std_logic_vector(3 downto 0);
begin
  dut : entity work.popcount generic map (WIDTH => WIDTH) port map (d => d, count => count);
  process
    variable errc : integer := 0;
    variable c    : integer;
  begin
    for i in 0 to (2**WIDTH)-1 loop
      d <= std_logic_vector(to_unsigned(i, WIDTH));
      wait for 1 ns;
      c := 0;
      for k in d'range loop if d(k) = '1' then c := c + 1; end if; end loop;
      if to_integer(unsigned(count)) /= c then errc := errc + 1; report "count wrong" severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
