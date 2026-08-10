library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal sel : std_logic_vector(1 downto 0) := "00";
  signal a, b, c, y : std_logic_vector(7 downto 0) := (others => '0');
begin
  dut : entity work.sel_mux port map (sel => sel, a => a, b => b, c => c, y => y);
  process
    variable errc : integer := 0; variable exp : std_logic_vector(7 downto 0);
  begin
    a <= x"AA"; b <= x"BB"; c <= x"CC";
    for s in 0 to 3 loop
      sel <= "00"; wait for 5 ns;              -- load y with 'a'
      sel <= std_logic_vector(to_unsigned(s, 2)); wait for 5 ns;
      case sel is
        when "00" => exp := a; when "01" => exp := b;
        when "10" => exp := c; when others => exp := x"00";
      end case;
      if y /= exp then errc := errc + 1; report "sel path wrong (inferred latch?)" severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
