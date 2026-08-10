library ieee;
use ieee.std_logic_1164.all;

entity edge_detector is
  port (
    clk   : in  std_logic;
    rst_n : in  std_logic;
    sig   : in  std_logic;
    rise  : out std_logic;
    fall  : out std_logic
  );
end entity edge_detector;

architecture rtl of edge_detector is
  signal prev : std_logic;
begin
  process(clk, rst_n)
  begin
    if rst_n = '0' then
      prev <= '0'; rise <= '0'; fall <= '0';
    elsif rising_edge(clk) then
      prev <= sig;
      rise <= sig and (not prev);
      fall <= (not sig) and prev;
    end if;
  end process;
end architecture rtl;
