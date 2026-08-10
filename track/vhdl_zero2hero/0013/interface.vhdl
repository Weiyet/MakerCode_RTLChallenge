library ieee;
use ieee.std_logic_1164.all;

entity tristate_buf is
  port (oe   : in  std_logic;
        din  : in  std_logic_vector(7 downto 0);
        dout : out std_logic_vector(7 downto 0));
end entity tristate_buf;

architecture rtl of tristate_buf is
begin
  -- your implementation here

end architecture rtl;
