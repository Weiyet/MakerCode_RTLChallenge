library ieee;
use ieee.std_logic_1164.all;
use std.env.all;

entity tb is
end entity tb;

architecture sim of tb is
  signal zero, one : std_logic;
begin
  dut : entity work.constants port map (zero => zero, one => one);

  process
    variable errc : integer := 0;
  begin
    wait for 5 ns;
    if zero /= '0' then errc := errc + 1; report "zero should be 0" severity error; end if;
    if one  /= '1' then errc := errc + 1; report "one should be 1"  severity error; end if;
    if errc = 0 then report "Test PASS" severity note;
    else             report "Test FAILED" severity note;
    end if;
    finish;
  end process;
end architecture sim;
