library ieee;
use ieee.std_logic_1164.all;

entity seq_detector_1011 is
  port (
    clk      : in  std_logic;
    rst_n    : in  std_logic;
    din      : in  std_logic;
    detected : out std_logic
  );
end entity seq_detector_1011;

architecture rtl of seq_detector_1011 is
  type state_t is (S0, S1, S2, S3, S4);
  signal state : state_t;
begin
  process(clk, rst_n)
  begin
    if rst_n = '0' then
      state <= S0;
    elsif rising_edge(clk) then
      case state is
        when S0 => if din = '1' then state <= S1; else state <= S0; end if;
        when S1 => if din = '1' then state <= S1; else state <= S2; end if;
        when S2 => if din = '1' then state <= S3; else state <= S0; end if;
        when S3 => if din = '1' then state <= S4; else state <= S2; end if;
        when S4 => if din = '1' then state <= S1; else state <= S2; end if;
      end case;
    end if;
  end process;

  detected <= '1' when state = S4 else '0';
end architecture rtl;
