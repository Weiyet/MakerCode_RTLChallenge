library ieee;
use ieee.std_logic_1164.all;

entity ripple_adder is
  generic (
    WIDTH : integer := 4
  );
  port (
    a    : in  std_logic_vector(WIDTH-1 downto 0);
    b    : in  std_logic_vector(WIDTH-1 downto 0);
    cin  : in  std_logic;
    sum  : out std_logic_vector(WIDTH-1 downto 0);
    cout : out std_logic
  );
end entity ripple_adder;

architecture rtl of ripple_adder is
begin
  -- your implementation here

end architecture rtl;
