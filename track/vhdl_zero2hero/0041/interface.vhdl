library ieee;
use ieee.std_logic_1164.all;

-- Write a testbench: clock + reset, then a procedure that sends transactions.
-- acc_dut (in tb.vhdl) is already instantiated as `dut`.
entity tb_top is end entity tb_top;

architecture sim of tb_top is
  component acc_dut
    port (clk, rst_n, valid : in std_logic;
          din : in std_logic_vector(7 downto 0);
          sum : out std_logic_vector(15 downto 0));
  end component;
  signal clk   : std_logic := '0';
  signal rst_n : std_logic := '0';
  signal valid : std_logic := '0';
  signal din   : std_logic_vector(7 downto 0)  := (others => '0');
  signal sum   : std_logic_vector(15 downto 0);
begin
  -- TODO: model a clock on clk

  -- TODO: a stimulus process with a procedure send(b) that pulses valid one clock;
  --       reset, then send 10, 20, 30, 40

  -- DUT instance (provided - do not rename)
  dut : acc_dut port map (clk => clk, rst_n => rst_n, valid => valid, din => din, sum => sum);
end architecture sim;
