library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is
end entity tb;

architecture sim of tb is
  signal d, y : std_logic_vector(7 downto 0) := (others => '0');
begin
  dut : entity work.vector_reverse port map (d => d, y => y);

  process
    variable errc : integer := 0;
    variable exp  : std_logic_vector(7 downto 0);
  begin
    for i in 0 to 255 loop
      d <= std_logic_vector(to_unsigned(i, 8));
      wait for 2 ns;
      for k in 0 to 7 loop exp(k) := d(7 - k); end loop;
      if y /= exp then errc := errc + 1; report "reverse wrong" severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
