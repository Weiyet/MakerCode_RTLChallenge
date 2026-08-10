library ieee;
use ieee.std_logic_1164.all;

entity bcd_to_7seg is
  port (
    bcd : in  std_logic_vector(3 downto 0);
    seg : out std_logic_vector(6 downto 0)
  );
end entity bcd_to_7seg;

architecture rtl of bcd_to_7seg is
begin
  process(all)
  begin
    case bcd is
      when "0000" => seg <= "0111111";  -- 3F
      when "0001" => seg <= "0000110";  -- 06
      when "0010" => seg <= "1011011";  -- 5B
      when "0011" => seg <= "1001111";  -- 4F
      when "0100" => seg <= "1100110";  -- 66
      when "0101" => seg <= "1101101";  -- 6D
      when "0110" => seg <= "1111101";  -- 7D
      when "0111" => seg <= "0000111";  -- 07
      when "1000" => seg <= "1111111";  -- 7F
      when "1001" => seg <= "1101111";  -- 6F
      when others => seg <= "0000000";
    end case;
  end process;
end architecture rtl;
