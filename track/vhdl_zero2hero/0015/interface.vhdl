library ieee;
use ieee.std_logic_1164.all;

entity ctrl_pack is
  port (
    opcode : in  std_logic_vector(3 downto 0);
    src    : in  std_logic_vector(2 downto 0);
    dst    : in  std_logic_vector(2 downto 0);
    imm    : in  std_logic_vector(5 downto 0);
    word   : out std_logic_vector(15 downto 0)
  );
end entity ctrl_pack;

architecture rtl of ctrl_pack is
begin
  -- your implementation here

end architecture rtl;
