library ieee;
use ieee.std_logic_1164.all;

entity dff_reset is
  port (
    clk     : in  std_logic;
    rst_n   : in  std_logic;
    d       : in  std_logic;
    q_sync  : out std_logic;
    q_async : out std_logic
  );
end entity dff_reset;

architecture rtl of dff_reset is
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if rst_n = '0' then q_sync <= '0'; else q_sync <= d; end if;
    end if;
  end process;

  process(clk, rst_n)
  begin
    if rst_n = '0' then
      q_async <= '0';
    elsif rising_edge(clk) then
      q_async <= d;
    end if;
  end process;
end architecture rtl;
