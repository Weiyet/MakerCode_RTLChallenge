library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx is
  generic (
    CLKS_PER_BIT : integer := 8
  );
  port (
    clk   : in  std_logic;
    rst_n : in  std_logic;
    start : in  std_logic;
    data  : in  std_logic_vector(7 downto 0);
    tx    : out std_logic;
    busy  : out std_logic
  );
end entity uart_tx;

architecture rtl of uart_tx is
  type state_t is (IDLE, ST_START, ST_DATA, ST_STOP);
  signal state   : state_t;
  signal clk_cnt : integer range 0 to CLKS_PER_BIT-1;
  signal bit_idx : integer range 0 to 7;
  signal shreg   : std_logic_vector(7 downto 0);
begin
  process(clk, rst_n)
  begin
    if rst_n = '0' then
      state <= IDLE; clk_cnt <= 0; bit_idx <= 0; shreg <= (others => '0');
    elsif rising_edge(clk) then
      case state is
        when IDLE =>
          clk_cnt <= 0; bit_idx <= 0;
          if start = '1' then shreg <= data; state <= ST_START; end if;
        when ST_START =>
          if clk_cnt = CLKS_PER_BIT-1 then clk_cnt <= 0; state <= ST_DATA;
          else clk_cnt <= clk_cnt + 1; end if;
        when ST_DATA =>
          if clk_cnt = CLKS_PER_BIT-1 then
            clk_cnt <= 0;
            if bit_idx = 7 then state <= ST_STOP; else bit_idx <= bit_idx + 1; end if;
          else clk_cnt <= clk_cnt + 1; end if;
        when ST_STOP =>
          if clk_cnt = CLKS_PER_BIT-1 then clk_cnt <= 0; state <= IDLE;
          else clk_cnt <= clk_cnt + 1; end if;
      end case;
    end if;
  end process;

  tx <= '0'            when state = ST_START else
        shreg(bit_idx) when state = ST_DATA  else
        '1';
  busy <= '0' when state = IDLE else '1';
end architecture rtl;
