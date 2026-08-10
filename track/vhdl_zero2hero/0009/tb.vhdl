library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is
  generic (W : integer := 8);
end entity tb;
architecture sim of tb is
  signal d0, d1, d2, d3, y : std_logic_vector(W-1 downto 0) := (others => '0');
  signal sel : std_logic_vector(1 downto 0) := "00";
begin
  dut : entity work.mux4to1 generic map (W => W)
        port map (d0 => d0, d1 => d1, d2 => d2, d3 => d3, sel => sel, y => y);
  process
    variable errc : integer := 0;
    variable exp  : std_logic_vector(W-1 downto 0);
  begin
    for t in 0 to 39 loop
      d0 <= std_logic_vector(to_unsigned((t*7)  mod 256, W));
      d1 <= std_logic_vector(to_unsigned((t*13) mod 256, W));
      d2 <= std_logic_vector(to_unsigned((t*29) mod 256, W));
      d3 <= std_logic_vector(to_unsigned((t*53) mod 256, W));
      sel <= std_logic_vector(to_unsigned(t mod 4, 2));
      wait for 5 ns;
      case sel is
        when "00" => exp := d0;
        when "01" => exp := d1;
        when "10" => exp := d2;
        when others => exp := d3;
      end case;
      if y /= exp then errc := errc + 1; report "mux wrong" severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
