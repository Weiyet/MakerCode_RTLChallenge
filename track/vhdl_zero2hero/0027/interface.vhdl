library ieee;
use ieee.std_logic_1164.all;

entity seq_detector_1011 is
  port (
    clk      : in  std_logic;
    rst_n    : in  std_logic;
    din      : in  std_logic;
    detected : out std_logic
  );
end entity seq_detector_1011;

architecture rtl of seq_detector_1011 is
begin
  -- your implementation here

end architecture rtl;
