library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

-- ---- DUT the student must drive (do not edit) ----
entity counter_dut is
  port (clk, rst_n, en : in std_logic; count : out std_logic_vector(7 downto 0));
end entity counter_dut;
architecture rtl of counter_dut is
  signal c : unsigned(7 downto 0) := (others => '0');
begin
  process(clk, rst_n) begin
    if rst_n = '0' then c <= (others => '0');
    elsif rising_edge(clk) then if en = '1' then c <= c + 1; end if; end if;
  end process;
  count <= std_logic_vector(c);
end architecture rtl;

-- ---- Outer checker: instantiate tb_top and probe dut.* via external names ----
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is end entity tb;
architecture check of tb is
  signal redges : integer := 0;
  signal saw_rl, saw_rh, saw_en : boolean := false;
begin
  u : entity work.tb_top;

  probe : block
    alias dclk   is << signal .tb.u.dut.clk   : std_logic >>;
    alias drst   is << signal .tb.u.dut.rst_n : std_logic >>;
    alias den    is << signal .tb.u.dut.en    : std_logic >>;
    alias dcount is << signal .tb.u.dut.count : std_logic_vector(7 downto 0) >>;
  begin
    process(dclk) begin if rising_edge(dclk) then redges <= redges + 1; end if; end process;
    process(drst, den) begin
      if drst = '0' then saw_rl <= true; end if;
      if drst = '1' then saw_rh <= true; end if;
      if den  = '1' then saw_en <= true; end if;
    end process;

    process
      variable errc : integer := 0;
    begin
      wait for 400 ns;
      if redges < 10          then errc := errc + 1; report "clock not toggling - model a clock" severity error; end if;
      if not saw_rl           then errc := errc + 1; report "reset never asserted low" severity error; end if;
      if not saw_rh           then errc := errc + 1; report "reset never released high" severity error; end if;
      if not saw_en           then errc := errc + 1; report "enable never driven high" severity error; end if;
      if unsigned(dcount) = 0 then errc := errc + 1; report "DUT never counted - your stimulus did not exercise it" severity error; end if;
      if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
      finish;
    end process;
  end block;
end architecture check;
