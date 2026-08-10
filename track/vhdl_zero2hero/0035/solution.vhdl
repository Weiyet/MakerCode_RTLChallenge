library ieee;
use ieee.std_logic_1164.all;

entity shift8_mux is
  port (clk : in std_logic;
        d   : in  std_logic_vector(7 downto 0);
        sel : in  std_logic_vector(1 downto 0);
        q   : out std_logic_vector(7 downto 0));
end entity shift8_mux;

architecture rtl of shift8_mux is
  component my_dff8
    port (clk : in std_logic;
          d   : in  std_logic_vector(7 downto 0);
          q   : out std_logic_vector(7 downto 0));
  end component;
  signal o1, o2, o3 : std_logic_vector(7 downto 0);
begin
  a : my_dff8 port map (clk => clk, d => d,  q => o1);
  b : my_dff8 port map (clk => clk, d => o1, q => o2);
  c : my_dff8 port map (clk => clk, d => o2, q => o3);

  with sel select q <=
    d  when "00",
    o1 when "01",
    o2 when "10",
    o3 when others;
end architecture rtl;
