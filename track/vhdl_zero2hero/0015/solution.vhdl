library ieee;
use ieee.std_logic_1164.all;

entity priority_encoder is
  port (
    d     : in  std_logic_vector(3 downto 0);
    pos   : out std_logic_vector(1 downto 0);
    valid : out std_logic
  );
end entity priority_encoder;

architecture rtl of priority_encoder is
begin
  process(all)
  begin
    valid <= '1';
    if    d(3) = '1' then pos <= "11";
    elsif d(2) = '1' then pos <= "10";
    elsif d(1) = '1' then pos <= "01";
    elsif d(0) = '1' then pos <= "00";
    else  pos <= "00"; valid <= '0';
    end if;
  end process;
end architecture rtl;
