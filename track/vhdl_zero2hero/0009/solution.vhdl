library ieee;
use ieee.std_logic_1164.all;

entity byte_reverse is
  port (
    d : in  std_logic_vector(31 downto 0);
    y : out std_logic_vector(31 downto 0)
  );
end entity byte_reverse;

architecture rtl of byte_reverse is
  type byte_arr is array(0 to 3) of std_logic_vector(7 downto 0);
begin
  process(d)
    variable b : byte_arr;
  begin
    for i in 0 to 3 loop
      b(i) := d(i*8 + 7 downto i*8);
    end loop;
    for i in 0 to 3 loop
      y(i*8 + 7 downto i*8) <= b(3 - i);
    end loop;
  end process;
end architecture rtl;
