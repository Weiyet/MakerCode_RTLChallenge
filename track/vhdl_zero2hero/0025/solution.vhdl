library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
  generic (AW : integer := 4; DW : integer := 8);
  port (clk   : in  std_logic;
        we    : in  std_logic;
        addr  : in  std_logic_vector(AW-1 downto 0);
        wdata : in  std_logic_vector(DW-1 downto 0);
        rdata : out std_logic_vector(DW-1 downto 0));
end entity ram;

architecture rtl of ram is
  type mem_t is array (0 to 2**AW - 1) of std_logic_vector(DW-1 downto 0);
  signal mem : mem_t;
begin
  process(clk) begin
    if rising_edge(clk) then
      if we = '1' then mem(to_integer(unsigned(addr))) <= wdata; end if;
      rdata <= mem(to_integer(unsigned(addr)));
    end if;
  end process;
end architecture rtl;
