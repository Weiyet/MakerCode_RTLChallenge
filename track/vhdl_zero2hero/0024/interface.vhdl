library ieee;
use ieee.std_logic_1164.all;

entity shift_register is
  generic (
    W : integer := 8
  );
  port (
    clk   : in  std_logic;
    rst_n : in  std_logic;
    sin   : in  std_logic;
    q     : out std_logic_vector(W-1 downto 0)
  );
end entity shift_register;

architecture rtl of shift_register is
begin
  -- your implementation here

end architecture rtl;
