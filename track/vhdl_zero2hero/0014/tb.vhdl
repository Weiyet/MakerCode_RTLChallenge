library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal code : std_logic_vector(1 downto 0) := "00";
  signal en   : std_logic := '0';
  signal y    : std_logic_vector(3 downto 0);
begin
  dut : entity work.decoder2to4 port map (code => code, en => en, y => y);
  process
    variable errc : integer := 0;
    variable exp  : std_logic_vector(3 downto 0);
    variable v    : unsigned(2 downto 0);
  begin
    for i in 0 to 7 loop
      v := to_unsigned(i, 3);
      en <= v(2); code <= std_logic_vector(v(1 downto 0));
      wait for 5 ns;
      exp := (others => '0');
      if en = '1' then exp(to_integer(unsigned(code))) := '1'; end if;
      if y /= exp then errc := errc + 1; report "decoder wrong" severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
