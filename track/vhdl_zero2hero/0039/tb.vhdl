library ieee;
use ieee.std_logic_1164.all;
use std.env.all;

entity tb is end entity tb;
architecture sim of tb is
  signal start : std_logic := '0';
  signal flag  : std_logic_vector(2 downto 0);
  signal done  : std_logic;
begin
  dut : entity work.parallel_procs port map (start => start, flag => flag, done => done);

  process
    variable errc : integer := 0;
  begin
    wait for 5 ns; start <= '1';
    wait for 15 ns;                       -- t+15
    if flag /= "001" then errc := errc + 1; report "t+15 flag /= 001 (ran sequentially?)" severity error; end if;
    wait for 10 ns;                       -- t+25
    if flag /= "011" then errc := errc + 1; report "t+25 flag /= 011 (ran sequentially?)" severity error; end if;
    wait for 4 ns;                        -- t+29
    if done /= '0' then errc := errc + 1; report "done asserted before all branches finished" severity error; end if;
    wait for 2 ns;                        -- t+31
    if done /= '1' then errc := errc + 1; report "done not set by +30 (ran sequentially?)" severity error; end if;
    if flag /= "111" then errc := errc + 1; report "flag /= 111 at done" severity error; end if;
    if errc = 0 then report "Test PASS" severity note;
    else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
