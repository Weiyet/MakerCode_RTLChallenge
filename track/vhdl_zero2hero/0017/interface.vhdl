library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  generic (
    W : integer := 8
  );
  port (
    a    : in  std_logic_vector(W-1 downto 0);
    b    : in  std_logic_vector(W-1 downto 0);
    op   : in  std_logic_vector(2 downto 0);
    y    : out std_logic_vector(W-1 downto 0);
    zero : out std_logic
  );
end entity alu;

architecture rtl of alu is
begin
  -- your implementation here

end architecture rtl;
