library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seq_src is
  port (clk   : in  std_logic;
        rst_n : in  std_logic;
        ready : in  std_logic;
        valid : out std_logic;
        data  : out std_logic_vector(7 downto 0));
end entity seq_src;

architecture rtl of seq_src is
  -- a counter signal + a clocked process; advance only on valid and ready
begin
  -- your implementation here

end architecture rtl;
