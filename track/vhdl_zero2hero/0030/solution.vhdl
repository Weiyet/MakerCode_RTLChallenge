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
  signal cnt : unsigned(7 downto 0) := (others => '0');
begin
  valid <= '1';
  process(clk, rst_n) begin
    if rst_n = '0' then
      cnt <= (others => '0');
    elsif rising_edge(clk) then
      if ready = '1' then cnt <= cnt + 1; end if;
    end if;
  end process;
  data <= std_logic_vector(cnt);
end architecture rtl;
