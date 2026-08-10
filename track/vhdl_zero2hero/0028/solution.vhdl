library ieee;
use ieee.std_logic_1164.all;

entity mealy_11 is
  port (
    clk   : in  std_logic;
    rst_n : in  std_logic;
    din   : in  std_logic;
    y     : out std_logic
  );
end entity mealy_11;

architecture rtl of mealy_11 is
  type state_t is (S0, S1);
  signal state : state_t;
begin
  process(clk, rst_n)
  begin
    if rst_n = '0' then
      state <= S0;
    elsif rising_edge(clk) then
      if din = '1' then state <= S1; else state <= S0; end if;
    end if;
  end process;

  y <= '1' when (state = S1 and din = '1') else '0';
end architecture rtl;
