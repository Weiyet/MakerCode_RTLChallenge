library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  generic (
    W : integer := 8
  );
  port (
    a    : in  std_logic_vector(W-1 downto 0);
    b    : in  std_logic_vector(W-1 downto 0);
    op   : in  std_logic_vector(2 downto 0);
    y    : out std_logic_vector(W-1 downto 0);
    zero : out std_logic
  );
end entity alu;

architecture rtl of alu is
  type op_t is (OP_ADD, OP_SUB, OP_AND, OP_OR, OP_XOR, OP_SLL, OP_SRL, OP_SLT);
begin
  process(all)
    variable ys  : std_logic_vector(W-1 downto 0);
    variable sh  : integer;
  begin
    sh := to_integer(unsigned(b(2 downto 0)));
    case op_t'val(to_integer(unsigned(op))) is
      when OP_ADD => ys := std_logic_vector(unsigned(a) + unsigned(b));
      when OP_SUB => ys := std_logic_vector(unsigned(a) - unsigned(b));
      when OP_AND => ys := a and b;
      when OP_OR  => ys := a or b;
      when OP_XOR => ys := a xor b;
      when OP_SLL => ys := std_logic_vector(shift_left(unsigned(a), sh));
      when OP_SRL => ys := std_logic_vector(shift_right(unsigned(a), sh));
      when OP_SLT => if unsigned(a) < unsigned(b) then
                       ys := std_logic_vector(to_unsigned(1, W));
                     else
                       ys := (others => '0');
                     end if;
    end case;
    y <= ys;
    if unsigned(ys) = 0 then zero <= '1'; else zero <= '0'; end if;
  end process;
end architecture rtl;
