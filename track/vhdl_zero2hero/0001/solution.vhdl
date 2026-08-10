library ieee;
use ieee.std_logic_1164.all;

entity constants is
  port (
    zero : out std_logic;
    one  : out std_logic
  );
end entity constants;

architecture rtl of constants is
begin
  zero <= '0';
  one  <= '1';
end architecture rtl;
