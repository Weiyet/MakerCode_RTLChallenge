library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is
end entity tb;

architecture sim of tb is
  signal a, b      : std_logic_vector(7 downto 0) := (others => '0');
  signal cat       : std_logic_vector(15 downto 0);
  signal rep4      : std_logic_vector(31 downto 0);
  signal nib_swap  : std_logic_vector(7 downto 0);
begin
  dut : entity work.concat_replicate port map (a => a, b => b, cat => cat, rep4 => rep4, nib_swap => nib_swap);

  process
    variable errc : integer := 0;
    variable va, vb : unsigned(7 downto 0) := (others => '0');
  begin
    for i in 0 to 40 loop
      a <= std_logic_vector(va);
      b <= std_logic_vector(vb);
      wait for 5 ns;
      if cat      /= (a & b)                       then errc := errc + 1; report "cat wrong"      severity error; end if;
      if rep4     /= (a & a & a & a)               then errc := errc + 1; report "rep4 wrong"     severity error; end if;
      if nib_swap /= (a(3 downto 0) & a(7 downto 4)) then errc := errc + 1; report "nib_swap wrong" severity error; end if;
      va := va + to_unsigned(37, 8);
      vb := vb + to_unsigned(91, 8);
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
