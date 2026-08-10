library ieee;
use ieee.std_logic_1164.all;

entity concat_replicate is
  port (
    a        : in  std_logic_vector(7 downto 0);
    b        : in  std_logic_vector(7 downto 0);
    cat      : out std_logic_vector(15 downto 0);
    rep4     : out std_logic_vector(31 downto 0);
    nib_swap : out std_logic_vector(7 downto 0)
  );
end entity concat_replicate;

architecture rtl of concat_replicate is
begin
  -- your implementation here

end architecture rtl;
