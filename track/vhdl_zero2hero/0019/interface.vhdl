library ieee;
use ieee.std_logic_1164.all;

entity dff_reset is
  port (
    clk     : in  std_logic;
    rst_n   : in  std_logic;
    d       : in  std_logic;
    q_sync  : out std_logic;
    q_async : out std_logic
  );
end entity dff_reset;

architecture rtl of dff_reset is
begin
  -- your implementation here

end architecture rtl;
