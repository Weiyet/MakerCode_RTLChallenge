library ieee;
use ieee.std_logic_1164.all;

-- Write a testbench: model the clock and drive reset/enable for the provided DUT.
-- counter_dut (in tb.vhdl) is already instantiated as `dut`.
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
  -- TODO: model a clock on clk

  -- TODO: a stimulus process -> hold reset, release it, then assert en

  -- DUT instance (provided - do not rename)
  dut : counter_dut port map (clk => clk, rst_n => rst_n, en => en, count => count);
end architecture sim;
