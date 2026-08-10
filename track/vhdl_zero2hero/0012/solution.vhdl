library ieee;
use ieee.std_logic_1164.all;

entity sel_mux is
  port (sel     : in  std_logic_vector(1 downto 0);
        a, b, c : in  std_logic_vector(7 downto 0);
        y       : out std_logic_vector(7 downto 0));
end entity sel_mux;

architecture rtl of sel_mux is
begin
  process(all) begin
    y <= (others => '0');
    case sel is
      when "00" => y <= a;
      when "01" => y <= b;
      when "10" => y <= c;
      when others => null;
    end case;
  end process;
end architecture rtl;
