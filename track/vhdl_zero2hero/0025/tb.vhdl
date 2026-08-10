library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  constant AW : integer := 4;
  constant DW : integer := 8;
  signal clk, we : std_logic := '0';
  signal addr  : std_logic_vector(AW-1 downto 0) := (others => '0');
  signal wdata : std_logic_vector(DW-1 downto 0) := (others => '0');
  signal rdata : std_logic_vector(DW-1 downto 0);
  type model_t is array (0 to 2**AW - 1) of std_logic_vector(DW-1 downto 0);
  signal model : model_t;
begin
  clk <= not clk after 5 ns;
  dut : entity work.ram generic map (AW => AW, DW => DW)
    port map (clk => clk, we => we, addr => addr, wdata => wdata, rdata => rdata);
  process
    variable errc : integer := 0; variable d : integer;
  begin
    we <= '0';
    wait until falling_edge(clk);
    -- write every location = addr*3+1
    for i in 0 to 2**AW - 1 loop
      we <= '1'; addr <= std_logic_vector(to_unsigned(i, AW));
      d := (i*3 + 1) mod 256;
      wdata <= std_logic_vector(to_unsigned(d, DW));
      model(i) <= std_logic_vector(to_unsigned(d, DW));
      wait until falling_edge(clk);
    end loop;
    we <= '0';
    -- read back (registered => sample one rising edge after driving addr)
    for i in 0 to 2**AW - 1 loop
      addr <= std_logic_vector(to_unsigned(i, AW));
      wait until rising_edge(clk); wait for 1 ns;
      if rdata /= model(i) then errc := errc + 1; report "read wrong" severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
