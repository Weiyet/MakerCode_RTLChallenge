library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity updown_counter is
  generic (
    W : integer := 8
  );
  port (
    clk      : in  std_logic;
    rst_n    : in  std_logic;
    load     : in  std_logic;
    load_val : in  std_logic_vector(W-1 downto 0);
    en       : in  std_logic;
    up_down  : in  std_logic;
    count    : out std_logic_vector(W-1 downto 0)
  );
end entity updown_counter;

architecture rtl of updown_counter is
begin
  -- your implementation here

end architecture rtl;
