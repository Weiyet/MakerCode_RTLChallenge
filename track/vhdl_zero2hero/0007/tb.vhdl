library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal a, b, cin, h_sum, h_cout, sum, cout : std_logic := '0';
begin
  dut : entity work.adders port map (a => a, b => b, cin => cin,
    h_sum => h_sum, h_cout => h_cout, sum => sum, cout => cout);
  process
    variable v : unsigned(2 downto 0); variable errc : integer := 0;
    variable hs, hc, s, co : std_logic;
  begin
    for i in 0 to 7 loop
      v := to_unsigned(i, 3); a <= v(2); b <= v(1); cin <= v(0);
      wait for 5 ns;
      hs := a xor b; hc := a and b;
      s  := a xor b xor cin; co := (a and b) or (a and cin) or (b and cin);
      if h_sum  /= hs then errc := errc + 1; report "h_sum"  severity error; end if;
      if h_cout /= hc then errc := errc + 1; report "h_cout" severity error; end if;
      if sum    /= s  then errc := errc + 1; report "sum"    severity error; end if;
      if cout   /= co then errc := errc + 1; report "cout"   severity error; end if;
      wait for 5 ns;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
