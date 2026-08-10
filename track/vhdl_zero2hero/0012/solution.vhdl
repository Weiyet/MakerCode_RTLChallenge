library ieee;
use ieee.std_logic_1164.all;

entity ripple_adder is
  generic (
    WIDTH : integer := 4
  );
  port (
    a    : in  std_logic_vector(WIDTH-1 downto 0);
    b    : in  std_logic_vector(WIDTH-1 downto 0);
    cin  : in  std_logic;
    sum  : out std_logic_vector(WIDTH-1 downto 0);
    cout : out std_logic
  );
end entity ripple_adder;

architecture rtl of ripple_adder is
  signal carry : std_logic_vector(WIDTH downto 0);
begin
  carry(0) <= cin;

  gen_stage : for i in 0 to WIDTH-1 generate
    sum(i)     <= a(i) xor b(i) xor carry(i);
    carry(i+1) <= (a(i) and b(i)) or (a(i) and carry(i)) or (b(i) and carry(i));
  end generate;

  cout <= carry(WIDTH);
end architecture rtl;
