library ieee;
use ieee.std_logic_1164.all;

entity edge_detector is
  port (
    clk   : in  std_logic;
    rst_n : in  std_logic;
    sig   : in  std_logic;
    rise  : out std_logic;
    fall  : out std_logic
  );
end entity edge_detector;

architecture rtl of edge_detector is
begin
  -- your implementation here

end architecture rtl;
