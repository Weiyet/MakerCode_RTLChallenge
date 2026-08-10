library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal oe : std_logic := '0';
  signal din, dout : std_logic_vector(7 downto 0) := (others => '0');
  constant ALLZ : std_logic_vector(7 downto 0) := (others => 'Z');
begin
  dut : entity work.tristate_buf port map (oe => oe, din => din, dout => dout);
  process
    variable s1 : positive := 4; variable s2 : positive := 55; variable r : real;
    variable errc : integer := 0;
  begin
    for t in 0 to 19 loop
      uniform(s1, s2, r); din <= std_logic_vector(to_unsigned(integer(r * 255.0), 8));
      oe <= '1'; wait for 5 ns;
      if dout /= din  then errc := errc + 1; report "oe=1 dout wrong" severity error; end if;
      oe <= '0'; wait for 5 ns;
      if dout /= ALLZ then errc := errc + 1; report "oe=0 dout not high-Z" severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
