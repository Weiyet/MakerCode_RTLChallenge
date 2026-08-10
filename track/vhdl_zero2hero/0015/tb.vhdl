library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal opcode : std_logic_vector(3 downto 0) := (others => '0');
  signal src, dst : std_logic_vector(2 downto 0) := (others => '0');
  signal imm : std_logic_vector(5 downto 0) := (others => '0');
  signal word : std_logic_vector(15 downto 0);
begin
  dut : entity work.ctrl_pack port map (opcode => opcode, src => src, dst => dst, imm => imm, word => word);
  process
    variable errc : integer := 0;
    variable exp  : std_logic_vector(15 downto 0);
  begin
    for t in 0 to 60 loop
      opcode <= std_logic_vector(to_unsigned((t*3)  mod 16, 4));
      src    <= std_logic_vector(to_unsigned((t*5)  mod 8, 3));
      dst    <= std_logic_vector(to_unsigned((t*7)  mod 8, 3));
      imm    <= std_logic_vector(to_unsigned((t*11) mod 64, 6));
      wait for 5 ns;
      exp := opcode & src & dst & imm;
      if word /= exp then errc := errc + 1; report "word wrong" severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
