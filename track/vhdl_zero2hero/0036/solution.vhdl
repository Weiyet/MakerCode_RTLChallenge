library ieee;
use ieee.std_logic_1164.all;

entity adder32 is
  port (a, b : in  std_logic_vector(31 downto 0);
        sum  : out std_logic_vector(31 downto 0));
end entity adder32;

architecture rtl of adder32 is
  component add16
    port (a, b : in  std_logic_vector(15 downto 0);
          cin  : in  std_logic;
          sum  : out std_logic_vector(15 downto 0);
          cout : out std_logic);
  end component;
  signal carry : std_logic;
begin
  u_lo : add16 port map (a => a(15 downto 0),  b => b(15 downto 0),
                         cin => '0',   sum => sum(15 downto 0),  cout => carry);
  u_hi : add16 port map (a => a(31 downto 16), b => b(31 downto 16),
                         cin => carry, sum => sum(31 downto 16), cout => open);
end architecture rtl;
