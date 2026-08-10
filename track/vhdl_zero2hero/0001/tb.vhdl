library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal a, b, y_not, y_and, y_or, y_xor, y_nand, y_nor, y_xnor : std_logic := '0';
begin
  dut : entity work.gates port map (a => a, b => b, y_not => y_not, y_and => y_and,
    y_or => y_or, y_xor => y_xor, y_nand => y_nand, y_nor => y_nor, y_xnor => y_xnor);
  process
    variable v : unsigned(1 downto 0); variable errc : integer := 0;
  begin
    for i in 0 to 3 loop
      v := to_unsigned(i, 2); a <= v(1); b <= v(0);
      wait for 5 ns;
      if y_not  /= (not a)     then errc := errc + 1; report "not"  severity error; end if;
      if y_and  /= (a and b)   then errc := errc + 1; report "and"  severity error; end if;
      if y_or   /= (a or b)    then errc := errc + 1; report "or"   severity error; end if;
      if y_xor  /= (a xor b)   then errc := errc + 1; report "xor"  severity error; end if;
      if y_nand /= (a nand b)  then errc := errc + 1; report "nand" severity error; end if;
      if y_nor  /= (a nor b)   then errc := errc + 1; report "nor"  severity error; end if;
      if y_xnor /= (a xnor b)  then errc := errc + 1; report "xnor" severity error; end if;
      wait for 5 ns;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
