library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal bcd : std_logic_vector(3 downto 0) := "0000";
  signal seg : std_logic_vector(6 downto 0);

  function golden(d : std_logic_vector(3 downto 0)) return std_logic_vector is
  begin
    case d is
      when "0000" => return "0111111";
      when "0001" => return "0000110";
      when "0010" => return "1011011";
      when "0011" => return "1001111";
      when "0100" => return "1100110";
      when "0101" => return "1101101";
      when "0110" => return "1111101";
      when "0111" => return "0000111";
      when "1000" => return "1111111";
      when "1001" => return "1101111";
      when others => return "0000000";
    end case;
  end function;
begin
  dut : entity work.bcd_to_7seg port map (bcd => bcd, seg => seg);
  process
    variable errc : integer := 0;
  begin
    for i in 0 to 15 loop
      bcd <= std_logic_vector(to_unsigned(i, 4));
      wait for 5 ns;
      if seg /= golden(bcd) then errc := errc + 1; report "seg wrong" severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
