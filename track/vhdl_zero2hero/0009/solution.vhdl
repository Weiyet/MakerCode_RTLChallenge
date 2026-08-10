library ieee;
use ieee.std_logic_1164.all;

entity mux4to1 is
  generic (
    W : integer := 8
  );
  port (
    d0  : in  std_logic_vector(W-1 downto 0);
    d1  : in  std_logic_vector(W-1 downto 0);
    d2  : in  std_logic_vector(W-1 downto 0);
    d3  : in  std_logic_vector(W-1 downto 0);
    sel : in  std_logic_vector(1 downto 0);
    y   : out std_logic_vector(W-1 downto 0)
  );
end entity mux4to1;

architecture rtl of mux4to1 is
begin
  process(all)
  begin
    case sel is
      when "00"   => y <= d0;
      when "01"   => y <= d1;
      when "10"   => y <= d2;
      when others => y <= d3;
    end case;
  end process;
end architecture rtl;
