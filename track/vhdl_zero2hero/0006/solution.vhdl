library ieee;
use ieee.std_logic_1164.all;

entity reverser is
  port (d       : in  std_logic_vector(31 downto 0);
        bitrev  : out std_logic_vector(31 downto 0);
        byterev : out std_logic_vector(31 downto 0));
end entity reverser;

architecture rtl of reverser is
begin
  process(all) begin
    for i in 0 to 31 loop
      bitrev(i) <= d(31 - i);
    end loop;
  end process;

  byterev <= d(7 downto 0) & d(15 downto 8) & d(23 downto 16) & d(31 downto 24);
end architecture rtl;
