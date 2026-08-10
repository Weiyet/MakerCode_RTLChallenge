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
  type ctrl_t is record
    opcode : std_logic_vector(3 downto 0);
    src    : std_logic_vector(2 downto 0);
    dst    : std_logic_vector(2 downto 0);
    imm    : std_logic_vector(5 downto 0);
  end record;
begin
  process(all)
    variable c : ctrl_t;
  begin
    c.opcode := opcode;
    c.src    := src;
    c.dst    := dst;
    c.imm    := imm;
    word <= c.opcode & c.src & c.dst & c.imm;
  end process;
end architecture rtl;
