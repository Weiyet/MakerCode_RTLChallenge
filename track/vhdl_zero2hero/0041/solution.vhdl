library ieee;
use ieee.std_logic_1164.all;

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
  clk <= not clk after 5 ns;

  process
    procedure send(constant b : in std_logic_vector(7 downto 0)) is
    begin
      wait until falling_edge(clk);
      din <= b; valid <= '1';
      wait until falling_edge(clk);
      valid <= '0';
    end procedure;
  begin
    rst_n <= '0'; valid <= '0'; din <= (others => '0');
    wait for 12 ns; rst_n <= '1';
    send(x"0A");
    send(x"14");
    send(x"1E");
    send(x"28");
    wait;
  end process;

  dut : acc_dut port map (clk => clk, rst_n => rst_n, valid => valid, din => din, sum => sum);
end architecture sim;
