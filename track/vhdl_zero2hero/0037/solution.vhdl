library ieee;
use ieee.std_logic_1164.all;

entity addsub32 is
  port (a, b : in  std_logic_vector(31 downto 0);
        sub  : in  std_logic;
        sum  : out std_logic_vector(31 downto 0));
end entity addsub32;

architecture rtl of addsub32 is
  component add16
    port (a, b : in  std_logic_vector(15 downto 0);
          cin  : in  std_logic;
          sum  : out std_logic_vector(15 downto 0);
          cout : out std_logic);
  end component;
  signal b_x   : std_logic_vector(31 downto 0);
  signal carry : std_logic;
begin
  b_x <= b xor (b'range => sub);
  u_lo : add16 port map (a => a(15 downto 0),  b => b_x(15 downto 0),
                         cin => sub,   sum => sum(15 downto 0),  cout => carry);
  u_hi : add16 port map (a => a(31 downto 16), b => b_x(31 downto 16),
                         cin => carry, sum => sum(31 downto 16), cout => open);
end architecture rtl;
