library ieee;
use ieee.std_logic_1164.all;

entity param_inst is
  port (clk : in  std_logic;
        d4  : in  std_logic_vector(3 downto 0);
        q4  : out std_logic_vector(3 downto 0);
        d12 : in  std_logic_vector(11 downto 0);
        q12 : out std_logic_vector(11 downto 0));
end entity param_inst;

architecture rtl of param_inst is
  -- declare a component for wide_reg (in tb.vhdl) and instantiate it twice
begin
  -- your implementation here

end architecture rtl;
