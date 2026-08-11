library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

-- ---- DUT the student must drive (do not edit) ----
entity acc_dut is
  port (clk, rst_n, valid : in std_logic;
        din : in  std_logic_vector(7 downto 0);
        sum : out std_logic_vector(15 downto 0));
end entity acc_dut;
architecture rtl of acc_dut is
  signal s : unsigned(15 downto 0) := (others => '0');
begin
  process(clk, rst_n) begin
    if rst_n = '0' then s <= (others => '0');
    elsif rising_edge(clk) then
      if valid = '1' then s <= s + resize(unsigned(din), 16); end if;
    end if;
  end process;
  sum <= std_logic_vector(s);
end architecture rtl;

-- ---- Outer checker: probe the student's dut for correct accumulation ----
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is end entity tb;
architecture check of tb is
  signal redges : integer := 0;
  signal beats  : integer := 0;
  signal saw_rst : boolean := false;
begin
  u : entity work.tb_top;

  probe : block
    alias dclk   is << signal .tb.u.dut.clk   : std_logic >>;
    alias drst   is << signal .tb.u.dut.rst_n : std_logic >>;
    alias dvalid is << signal .tb.u.dut.valid : std_logic >>;
    alias dsum   is << signal .tb.u.dut.sum   : std_logic_vector(15 downto 0) >>;
  begin
    process(dclk) begin
      if rising_edge(dclk) then
        redges <= redges + 1;
        if drst = '1' and dvalid = '1' then beats <= beats + 1; end if;
      end if;
    end process;
    process(drst) begin
      if drst = '0' then saw_rst <= true; end if;
    end process;

    process
      variable errc : integer := 0;
    begin
      wait for 400 ns;
      if redges < 10           then errc := errc + 1; report "clock not toggling - model a clock" severity error; end if;
      if not saw_rst           then errc := errc + 1; report "reset never applied" severity error; end if;
      if beats /= 4            then errc := errc + 1; report "expected 4 valid transactions (hold valid one clock each)" severity error; end if;
      if unsigned(dsum) /= 100 then errc := errc + 1; report "accumulator /= 100 (send 10,20,30,40)" severity error; end if;
      if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
      finish;
    end process;
  end block;
end architecture check;
