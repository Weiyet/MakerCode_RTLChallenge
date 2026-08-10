library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity updown_counter is
  generic (
    W : integer := 8
  );
  port (
    clk      : in  std_logic;
    rst_n    : in  std_logic;
    load     : in  std_logic;
    load_val : in  std_logic_vector(W-1 downto 0);
    en       : in  std_logic;
    up_down  : in  std_logic;
    count    : out std_logic_vector(W-1 downto 0)
  );
end entity updown_counter;

architecture rtl of updown_counter is
  signal cnt : unsigned(W-1 downto 0);
begin
  process(clk, rst_n)
  begin
    if rst_n = '0' then
      cnt <= (others => '0');
    elsif rising_edge(clk) then
      if load = '1' then
        cnt <= unsigned(load_val);
      elsif en = '1' then
        if up_down = '1' then cnt <= cnt + 1; else cnt <= cnt - 1; end if;
      end if;
    end if;
  end process;
  count <= std_logic_vector(cnt);
end architecture rtl;
