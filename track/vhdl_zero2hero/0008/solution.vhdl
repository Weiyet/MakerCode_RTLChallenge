library ieee;
use ieee.std_logic_1164.all;

entity vector_reverse is
  port (
    d : in  std_logic_vector(7 downto 0);
    y : out std_logic_vector(7 downto 0)
  );
end entity vector_reverse;

architecture rtl of vector_reverse is
begin
  process(d)
  begin
    for i in 0 to 7 loop
      y(i) <= d(7 - i);
    end loop;
  end process;
end architecture rtl;
