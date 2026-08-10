library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is
end entity tb;

architecture sim of tb is
  signal a, b, sel, y : std_logic := '0';
begin
  dut : entity work.mux2to1 port map (a => a, b => b, sel => sel, y => y);

  process
    variable errc : integer := 0;
    variable v    : unsigned(2 downto 0);
    variable exp  : std_logic;
  begin
    for i in 0 to 7 loop
      v := to_unsigned(i, 3);
      a <= v(2); b <= v(1); sel <= v(0);
      wait for 5 ns;
      if sel = '1' then exp := b; else exp := a; end if;
      if y /= exp then
        errc := errc + 1;
        report "mismatch a=" & std_logic'image(a) & " b=" & std_logic'image(b) &
               " sel=" & std_logic'image(sel) & " y=" & std_logic'image(y) severity error;
      end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note;
    else             report "Test FAILED" severity note;
    end if;
    finish;
  end process;
end architecture sim;
