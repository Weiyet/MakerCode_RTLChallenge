library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is
end entity tb;

architecture sim of tb is
  signal d : std_logic_vector(7 downto 0) := (others => '0');
  signal all_ones, any_one, parity : std_logic;
begin
  dut : entity work.reduction_ops port map (d => d, all_ones => all_ones, any_one => any_one, parity => parity);

  process
    variable errc : integer := 0;
  begin
    for i in 0 to 255 loop
      d <= std_logic_vector(to_unsigned(i, 8));
      wait for 2 ns;
      if all_ones /= (and d) then errc := errc + 1; report "all_ones wrong" severity error; end if;
      if any_one  /= (or d)  then errc := errc + 1; report "any_one wrong"  severity error; end if;
      if parity   /= (xor d) then errc := errc + 1; report "parity wrong"   severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
