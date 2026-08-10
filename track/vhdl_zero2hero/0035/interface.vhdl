library ieee;
use ieee.std_logic_1164.all;

entity shift8_mux is
  port (clk : in std_logic;
        d   : in  std_logic_vector(7 downto 0);
        sel : in  std_logic_vector(1 downto 0);
        q   : out std_logic_vector(7 downto 0));
end entity shift8_mux;

architecture rtl of shift8_mux is
  -- component my_dff8 (provided in tb.vhdl) + tap signals go here
begin
  -- your implementation here

end architecture rtl;
