library ieee;
use ieee.std_logic_1164.all;

entity wire_passthrough is
  port (
    a : in  std_logic;
    y : out std_logic
  );
end entity wire_passthrough;

architecture rtl of wire_passthrough is
begin
  y <= a;
end architecture rtl;
