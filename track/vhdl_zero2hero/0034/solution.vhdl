library ieee;
use ieee.std_logic_1164.all;

entity param_inst is
  port (clk : in  std_logic;
        d4  : in  std_logic_vector(3 downto 0);
        q4  : out std_logic_vector(3 downto 0);
        d12 : in  std_logic_vector(11 downto 0);
        q12 : out std_logic_vector(11 downto 0));
end entity param_inst;

architecture rtl of param_inst is
  component wide_reg
    generic (WIDTH : integer := 8);
    port (clk : in  std_logic;
          d   : in  std_logic_vector(WIDTH-1 downto 0);
          q   : out std_logic_vector(WIDTH-1 downto 0));
  end component;
begin
  u4  : wide_reg generic map (WIDTH => 4)  port map (clk => clk, d => d4,  q => q4);
  u12 : wide_reg generic map (WIDTH => 12) port map (clk => clk, d => d12, q => q12);
end architecture rtl;
