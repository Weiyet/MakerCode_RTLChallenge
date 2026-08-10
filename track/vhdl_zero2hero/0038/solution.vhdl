library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stats is
  port (a, b    : in  std_logic_vector(7 downto 0);
        mx      : out std_logic_vector(7 downto 0);
        sum     : out std_logic_vector(8 downto 0);
        absdiff : out std_logic_vector(7 downto 0));
end entity stats;

architecture rtl of stats is
  function get_max(x, y : unsigned(7 downto 0)) return unsigned is
  begin
    if x > y then return x; else return y; end if;
  end function;

  procedure sum_absdiff(x, y : in  unsigned(7 downto 0);
                        s     : out unsigned(8 downto 0);
                        ad    : out unsigned(7 downto 0)) is
  begin
    s := resize(x, 9) + resize(y, 9);
    if x > y then ad := x - y; else ad := y - x; end if;
  end procedure;
begin
  process(all)
    variable vs  : unsigned(8 downto 0);
    variable vad : unsigned(7 downto 0);
  begin
    mx <= std_logic_vector(get_max(unsigned(a), unsigned(b)));
    sum_absdiff(unsigned(a), unsigned(b), vs, vad);
    sum     <= std_logic_vector(vs);
    absdiff <= std_logic_vector(vad);
  end process;
end architecture rtl;
