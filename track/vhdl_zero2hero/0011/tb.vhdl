library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal d     : std_logic_vector(3 downto 0) := "0000";
  signal pos   : std_logic_vector(1 downto 0);
  signal valid : std_logic;
begin
  dut : entity work.priority_encoder port map (d => d, pos => pos, valid => valid);
  process
    variable errc : integer := 0;
    variable exp_pos : std_logic_vector(1 downto 0);
    variable exp_val : std_logic;
  begin
    for i in 0 to 15 loop
      d <= std_logic_vector(to_unsigned(i, 4));
      wait for 5 ns;
      exp_val := or d;
      exp_pos := "00";
      for k in 0 to 3 loop
        if d(k) = '1' then exp_pos := std_logic_vector(to_unsigned(k, 2)); end if;
      end loop;
      if valid /= exp_val then errc := errc + 1; report "valid wrong" severity error; end if;
      if exp_val = '1' and pos /= exp_pos then errc := errc + 1; report "pos wrong" severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
