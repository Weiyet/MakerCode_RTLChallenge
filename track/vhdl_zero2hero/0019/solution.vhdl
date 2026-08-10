library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity popcount is
  generic (
    WIDTH : integer := 8
  );
  port (
    d     : in  std_logic_vector(WIDTH-1 downto 0);
    count : out std_logic_vector(integer(ceil(log2(real(WIDTH+1))))-1 downto 0)
  );
end entity popcount;

architecture rtl of popcount is
begin
  process(all)
    variable c : integer;
  begin
    c := 0;
    for i in d'range loop
      if d(i) = '1' then c := c + 1; end if;
    end loop;
    count <= std_logic_vector(to_unsigned(c, count'length));
  end process;
end architecture rtl;
