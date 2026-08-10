library ieee;
use ieee.std_logic_1164.all;

entity gray_codec is
  generic (
    W : integer := 4
  );
  port (
    bin     : in  std_logic_vector(W-1 downto 0);
    gray_in : in  std_logic_vector(W-1 downto 0);
    gray    : out std_logic_vector(W-1 downto 0);
    bin_out : out std_logic_vector(W-1 downto 0)
  );
end entity gray_codec;

architecture rtl of gray_codec is
begin
  -- your implementation here

end architecture rtl;
