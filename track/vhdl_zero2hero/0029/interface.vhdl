library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debouncer is
  generic (
    STABLE : integer := 4
  );
  port (
    clk   : in  std_logic;
    rst_n : in  std_logic;
    noisy : in  std_logic;
    clean : out std_logic
  );
end entity debouncer;

architecture rtl of debouncer is
begin
  -- your implementation here

end architecture rtl;
