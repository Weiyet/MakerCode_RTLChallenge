library ieee;
use ieee.std_logic_1164.all;

entity shift3 is
  port (clk : in  std_logic;
        din : in  std_logic;
        q   : out std_logic_vector(2 downto 0));
end entity shift3;

architecture rtl of shift3 is
  signal r : std_logic_vector(2 downto 0) := "000";
begin
  process(clk) begin
    if rising_edge(clk) then
      r(0) <= din;
      r(1) <= r(0);
      r(2) <= r(1);
    end if;
  end process;
  q <= r;
end architecture rtl;
