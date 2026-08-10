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
  function bin2gray(b : std_logic_vector) return std_logic_vector is
  begin
    return b xor ('0' & b(b'high downto 1));
  end function;

  function gray2bin(g : std_logic_vector) return std_logic_vector is
    variable b : std_logic_vector(g'range);
  begin
    b(b'high) := g(g'high);
    for i in g'high-1 downto 0 loop
      b(i) := b(i+1) xor g(i);
    end loop;
    return b;
  end function;
begin
  gray    <= bin2gray(bin);
  bin_out <= gray2bin(gray_in);
end architecture rtl;
