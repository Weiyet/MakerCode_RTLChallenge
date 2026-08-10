library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is
end entity tb;

architecture sim of tb is
  signal a, b : std_logic := '0';
  signal y_and, y_or, y_xor, y_nand, y_nor, y_xnor : std_logic;
begin
  dut : entity work.logic_gates
    port map (a => a, b => b, y_and => y_and, y_or => y_or, y_xor => y_xor,
              y_nand => y_nand, y_nor => y_nor, y_xnor => y_xnor);

  process
    variable errc : integer := 0;
    variable v    : unsigned(1 downto 0);
  begin
    for i in 0 to 3 loop
      v := to_unsigned(i, 2);
      a <= v(1); b <= v(0);
      wait for 5 ns;
      if y_and  /= (a and b)  then errc := errc + 1; report "AND wrong"  severity error; end if;
      if y_or   /= (a or b)   then errc := errc + 1; report "OR wrong"   severity error; end if;
      if y_xor  /= (a xor b)  then errc := errc + 1; report "XOR wrong"  severity error; end if;
      if y_nand /= (a nand b) then errc := errc + 1; report "NAND wrong" severity error; end if;
      if y_nor  /= (a nor b)  then errc := errc + 1; report "NOR wrong"  severity error; end if;
      if y_xnor /= (a xnor b) then errc := errc + 1; report "XNOR wrong" severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note;
    else             report "Test FAILED" severity note;
    end if;
    finish;
  end process;
end architecture sim;
