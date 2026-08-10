library ieee;
use ieee.std_logic_1164.all;

entity parallel_procs is
  port (start : in  std_logic;
        flag  : out std_logic_vector(2 downto 0);
        done  : out std_logic);
end entity parallel_procs;

architecture rtl of parallel_procs is
  -- an internal signal for the flags may help
begin
  -- write THREE concurrent processes (one per delay), then drive done
  -- your implementation here

end architecture rtl;
