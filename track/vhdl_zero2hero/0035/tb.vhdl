-- =====================================================================
-- Provided sub-entity -- you MUST instantiate this in your block.
--   entity my_dff8 port(clk : in std_logic;
--                       d   : in  std_logic_vector(7 downto 0);
--                       q   : out std_logic_vector(7 downto 0));
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
entity my_dff8 is
  port (clk : in std_logic;
        d   : in  std_logic_vector(7 downto 0);
        q   : out std_logic_vector(7 downto 0));
end entity my_dff8;
architecture rtl of my_dff8 is
begin
  process (clk) begin
    if rising_edge(clk) then q <= d; end if;
  end process;
end architecture rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal clk : std_logic := '0';
  signal d, q, s1r, s2r, s3r : std_logic_vector(7 downto 0) := (others => '0');
  signal sel : std_logic_vector(1 downto 0) := "00";
begin
  clk <= not clk after 5 ns;
  dut : entity work.shift8_mux port map (clk => clk, d => d, sel => sel, q => q);

  -- golden delay line
  process (clk) begin
    if rising_edge(clk) then s1r <= d; s2r <= s1r; s3r <= s2r; end if;
  end process;

  process
    variable s1 : positive := 11; variable s2 : positive := 71; variable r : real;
    variable dv : std_logic_vector(7 downto 0); variable sv : std_logic_vector(1 downto 0);
    variable exp : std_logic_vector(7 downto 0); variable errc : integer := 0;
  begin
    -- warm up: flush 'U' out of the DUT flops (and golden line) with d=0
    d <= (others => '0');
    for w in 0 to 3 loop wait until rising_edge(clk); end loop;
    wait until falling_edge(clk);
    for i in 0 to 59 loop
      uniform(s1, s2, r); dv := std_logic_vector(to_unsigned(integer(r * 255.0), 8));
      uniform(s1, s2, r); sv := std_logic_vector(to_unsigned(integer(r * 3.0), 2));
      d <= dv; sel <= sv;
      wait until rising_edge(clk);
      wait for 1 ns;
      case sel is
        when "00" => exp := d;
        when "01" => exp := s1r;
        when "10" => exp := s2r;
        when others => exp := s3r;
      end case;
      if q /= exp then errc := errc + 1; report "shift8_mux wrong" severity error; end if;
      wait until falling_edge(clk);
    end loop;
    if errc = 0 then report "Test PASS" severity note;
    else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
