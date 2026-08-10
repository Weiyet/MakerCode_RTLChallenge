library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is
  generic (W : integer := 8);
end entity tb;
architecture sim of tb is
  signal a, b, y : std_logic_vector(W-1 downto 0) := (others => '0');
  signal op      : std_logic_vector(2 downto 0) := "000";
  signal zero    : std_logic;
begin
  dut : entity work.alu generic map (W => W)
        port map (a => a, b => b, op => op, y => y, zero => zero);
  process
    variable errc : integer := 0;
    variable exp  : std_logic_vector(W-1 downto 0);
    variable sh   : integer;
  begin
    for t in 0 to 300 loop
      a  <= std_logic_vector(to_unsigned((t*37) mod 256, W));
      b  <= std_logic_vector(to_unsigned((t*11) mod 256, W));
      op <= std_logic_vector(to_unsigned(t mod 8, 3));
      wait for 2 ns;
      sh := to_integer(unsigned(b(2 downto 0)));
      case to_integer(unsigned(op)) is
        when 0 => exp := std_logic_vector(unsigned(a) + unsigned(b));
        when 1 => exp := std_logic_vector(unsigned(a) - unsigned(b));
        when 2 => exp := a and b;
        when 3 => exp := a or b;
        when 4 => exp := a xor b;
        when 5 => exp := std_logic_vector(shift_left(unsigned(a), sh));
        when 6 => exp := std_logic_vector(shift_right(unsigned(a), sh));
        when others => if unsigned(a) < unsigned(b) then exp := std_logic_vector(to_unsigned(1, W)); else exp := (others => '0'); end if;
      end case;
      if y /= exp then errc := errc + 1; report "alu y wrong op=" & integer'image(to_integer(unsigned(op))) severity error; end if;
      if (zero = '1') /= (unsigned(exp) = 0) then errc := errc + 1; report "zero flag wrong" severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
