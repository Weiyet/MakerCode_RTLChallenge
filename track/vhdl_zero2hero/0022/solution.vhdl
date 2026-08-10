library ieee;
use ieee.std_logic_1164.all;

entity shift_register is
  generic (
    W : integer := 8
  );
  port (
    clk   : in  std_logic;
    rst_n : in  std_logic;
    sin   : in  std_logic;
    q     : out std_logic_vector(W-1 downto 0)
  );
end entity shift_register;

architecture rtl of shift_register is
  signal q_i : std_logic_vector(W-1 downto 0);
begin
  process(clk, rst_n)
  begin
    if rst_n = '0' then
      q_i <= (others => '0');
    elsif rising_edge(clk) then
      q_i <= q_i(W-2 downto 0) & sin;
    end if;
  end process;
  q <= q_i;
end architecture rtl;
