library ieee;
use ieee.std_logic_1164.all;
use std.env.all;

entity tb is
end entity tb;

architecture sim of tb is
  signal a : std_logic := '0';
  signal y : std_logic;
begin
  dut : entity work.wire_passthrough port map (a => a, y => y);

  process
    variable errc : integer := 0;
    constant vals : std_logic_vector(0 to 3) := "0101";
  begin
    for i in vals'range loop
      a <= vals(i);
      wait for 5 ns;
      if y /= a then
        errc := errc + 1;
        report "mismatch: a=" & std_logic'image(a) & " y=" & std_logic'image(y) severity error;
      end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note;
    else             report "Test FAILED" severity note;
    end if;
    finish;
  end process;
end architecture sim;
