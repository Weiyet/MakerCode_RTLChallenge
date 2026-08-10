library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx is
  generic (
    CLKS_PER_BIT : integer := 8
  );
  port (
    clk   : in  std_logic;
    rst_n : in  std_logic;
    start : in  std_logic;
    data  : in  std_logic_vector(7 downto 0);
    tx    : out std_logic;
    busy  : out std_logic
  );
end entity uart_tx;

architecture rtl of uart_tx is
begin
  -- your implementation here

end architecture rtl;
