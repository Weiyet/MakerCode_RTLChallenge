library ieee;
use ieee.std_logic_1164.all;

entity parallel_procs is
  port (start : in  std_logic;
        flag  : out std_logic_vector(2 downto 0);
        done  : out std_logic);
end entity parallel_procs;

architecture rtl of parallel_procs is
  signal f : std_logic_vector(2 downto 0) := "000";
begin
  p0 : process begin
    wait until rising_edge(start); wait for 10 ns; f(0) <= '1'; wait;
  end process;
  p1 : process begin
    wait until rising_edge(start); wait for 20 ns; f(1) <= '1'; wait;
  end process;
  p2 : process begin
    wait until rising_edge(start); wait for 30 ns; f(2) <= '1'; wait;
  end process;

  flag <= f;
  done <= '1' when f = "111" else '0';
end architecture rtl;
