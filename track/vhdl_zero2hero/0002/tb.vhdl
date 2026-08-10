library ieee;
use ieee.std_logic_1164.all;
use std.env.all;

entity tb is
end entity tb;

architecture sim of tb is
  signal a, y : std_logic := '0';
begin
  dut : entity work.not_gate port map (a => a, y => y);

  process
    variable errc : integer := 0;
    constant vals : std_logic_vector(0 to 1) := "01";
  begin
    for i in vals'range loop
      a <= vals(i);
      wait for 5 ns;
      if y /= (not a) then
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
