library ieee;
use ieee.std_logic_1164.all;

entity mux2to1 is
  port (
    a   : in  std_logic;
    b   : in  std_logic;
    sel : in  std_logic;
    y   : out std_logic
  );
end entity mux2to1;

architecture rtl of mux2to1 is
begin
  y <= b when sel = '1' else a;
end architecture rtl;
