library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
  generic (AW : integer := 4; DW : integer := 8);
  port (clk   : in  std_logic;
        we    : in  std_logic;
        addr  : in  std_logic_vector(AW-1 downto 0);
        wdata : in  std_logic_vector(DW-1 downto 0);
        rdata : out std_logic_vector(DW-1 downto 0));
end entity ram;

architecture rtl of ram is
  -- declare an array type + signal, then a clocked process
begin
  -- your implementation here

end architecture rtl;
