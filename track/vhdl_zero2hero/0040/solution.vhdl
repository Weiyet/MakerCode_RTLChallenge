library ieee;
use ieee.std_logic_1164.all;

entity tb_top is end entity tb_top;

architecture sim of tb_top is
  component counter_dut
    port (clk, rst_n, en : in std_logic; count : out std_logic_vector(7 downto 0));
  end component;
  signal clk   : std_logic := '0';
  signal rst_n : std_logic := '0';
  signal en    : std_logic := '0';
  signal count : std_logic_vector(7 downto 0);
begin
  clk <= not clk after 5 ns;

  process begin
    rst_n <= '0'; en <= '0';
    wait for 12 ns; rst_n <= '1';
    wait for 10 ns; en    <= '1';
    wait;
  end process;

  dut : counter_dut port map (clk => clk, rst_n => rst_n, en => en, count => count);
end architecture sim;
