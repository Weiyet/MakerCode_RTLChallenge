library ieee;
use ieee.std_logic_1164.all;

entity lfsr8 is
  port (
    clk   : in  std_logic;
    rst_n : in  std_logic;
    en    : in  std_logic;
    q     : out std_logic_vector(7 downto 0)
  );
end entity lfsr8;

architecture rtl of lfsr8 is
  signal q_i : std_logic_vector(7 downto 0);
  signal fb  : std_logic;
begin
  fb <= q_i(7) xor q_i(5) xor q_i(4) xor q_i(3);

  process(clk, rst_n)
  begin
    if rst_n = '0' then
      q_i <= x"FF";
    elsif rising_edge(clk) then
      if en = '1' then
        q_i <= q_i(6 downto 0) & fb;
      end if;
    end if;
  end process;
  q <= q_i;
end architecture rtl;
