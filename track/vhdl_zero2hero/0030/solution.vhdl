library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debouncer is
  generic (
    STABLE : integer := 4
  );
  port (
    clk   : in  std_logic;
    rst_n : in  std_logic;
    noisy : in  std_logic;
    clean : out std_logic
  );
end entity debouncer;

architecture rtl of debouncer is
  signal clean_i : std_logic;
  signal cnt     : integer range 0 to STABLE;
begin
  process(clk, rst_n)
  begin
    if rst_n = '0' then
      clean_i <= '0';
      cnt     <= 0;
    elsif rising_edge(clk) then
      if noisy /= clean_i then
        if cnt = STABLE-1 then
          clean_i <= noisy;
          cnt     <= 0;
        else
          cnt <= cnt + 1;
        end if;
      else
        cnt <= 0;
      end if;
    end if;
  end process;
  clean <= clean_i;
end architecture rtl;
