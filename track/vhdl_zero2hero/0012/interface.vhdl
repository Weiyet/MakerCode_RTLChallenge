library ieee;
use ieee.std_logic_1164.all;

entity sel_mux is
  port (sel     : in  std_logic_vector(1 downto 0);
        a, b, c : in  std_logic_vector(7 downto 0);
        y       : out std_logic_vector(7 downto 0));
end entity sel_mux;

architecture rtl of sel_mux is
begin
  -- combinational process with a default assignment (no inferred latch)

end architecture rtl;
