library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is generic (CLKS_PER_BIT : integer := 8); end entity tb;
architecture sim of tb is
  signal clk : std_logic := '0';
  signal rst_n, start, tx, busy : std_logic := '0';
  signal data : std_logic_vector(7 downto 0) := (others => '0');
  type byte_arr is array(natural range <>) of std_logic_vector(7 downto 0);
  constant tests : byte_arr := (x"A5", x"00", x"FF", x"3C", x"81");
begin
  clk <= not clk after 5 ns;
  dut : entity work.uart_tx generic map (CLKS_PER_BIT => CLKS_PER_BIT)
        port map (clk => clk, rst_n => rst_n, start => start, data => data, tx => tx, busy => busy);

  process
    variable errc : integer := 0;
    variable rx   : std_logic_vector(7 downto 0);
  begin
    rst_n <= '0'; start <= '0';
    wait until falling_edge(clk); wait until falling_edge(clk);
    rst_n <= '1';

    for t in tests'range loop
      -- issue a one-cycle start pulse; the DUT samples it at the next rising edge
      wait until falling_edge(clk);
      data <= tests(t); start <= '1';
      wait until rising_edge(clk);   -- frame begins here (call this R0)
      start <= '0';
      -- advance to the middle of the start bit
      for k in 0 to (CLKS_PER_BIT/2)-1 loop wait until rising_edge(clk); end loop;
      if tx /= '0' then errc := errc + 1; report "bad start bit" severity error; end if;
      -- sample the 8 data bits, LSB first (one sample per bit period)
      for bi in 0 to 7 loop
        for k in 0 to CLKS_PER_BIT-1 loop wait until rising_edge(clk); end loop;
        rx(bi) := tx;
      end loop;
      -- stop bit
      for k in 0 to CLKS_PER_BIT-1 loop wait until rising_edge(clk); end loop;
      if tx /= '1' then errc := errc + 1; report "bad stop bit" severity error; end if;
      if rx /= tests(t) then errc := errc + 1; report "byte mismatch" severity error; end if;
      wait until busy = '0';
    end loop;

    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
