library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is
  generic (WIDTH : integer := 4);
end entity tb;
architecture sim of tb is
  signal a, b, sum : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
  signal cin, cout : std_logic := '0';
begin
  dut : entity work.ripple_adder generic map (WIDTH => WIDTH)
        port map (a => a, b => b, cin => cin, sum => sum, cout => cout);
  process
    variable errc : integer := 0;
    variable exp  : unsigned(WIDTH downto 0);
  begin
    for ai in 0 to (2**WIDTH)-1 loop
      for bi in 0 to (2**WIDTH)-1 loop
        for ci in 0 to 1 loop
          a <= std_logic_vector(to_unsigned(ai, WIDTH));
          b <= std_logic_vector(to_unsigned(bi, WIDTH));
          if ci = 1 then cin <= '1'; else cin <= '0'; end if;
          wait for 1 ns;
          exp := resize(unsigned(a), WIDTH+1) + resize(unsigned(b), WIDTH+1) + ("" & cin);
          if (cout & sum) /= std_logic_vector(exp) then
            errc := errc + 1; report "sum wrong" severity error;
          end if;
        end loop;
      end loop;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
