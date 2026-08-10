library ieee;
use ieee.std_logic_1164.all;

entity enable_register is
  generic (
    W : integer := 8
  );
  port (
    clk   : in  std_logic;
    rst_n : in  std_logic;
    en    : in  std_logic;
    d     : in  std_logic_vector(W-1 downto 0);
    q     : out std_logic_vector(W-1 downto 0)
  );
end entity enable_register;

architecture rtl of enable_register is
begin
  -- your implementation here

end architecture rtl;
