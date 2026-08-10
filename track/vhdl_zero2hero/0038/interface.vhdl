library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stats is
  port (a, b    : in  std_logic_vector(7 downto 0);
        mx      : out std_logic_vector(7 downto 0);
        sum     : out std_logic_vector(8 downto 0);
        absdiff : out std_logic_vector(7 downto 0));
end entity stats;

architecture rtl of stats is
  -- declare a function (get_max) and a procedure (sum_absdiff) here
begin
  -- call them inside a process(all): your implementation here

end architecture rtl;
