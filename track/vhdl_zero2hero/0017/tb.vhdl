library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb is
  generic (W : integer := 4);
end entity tb;
architecture sim of tb is
  signal bin, gray_in, gray, bin_out : std_logic_vector(W-1 downto 0) := (others => '0');
begin
  dut : entity work.gray_codec generic map (W => W)
        port map (bin => bin, gray_in => gray_in, gray => gray, bin_out => bin_out);
  process
    variable errc : integer := 0;
    variable exp_gray, exp_bin, gv, bv : std_logic_vector(W-1 downto 0);
  begin
    for v in 0 to (2**W)-1 loop
      bv  := std_logic_vector(to_unsigned(v, W));
      bin <= bv;
      gv  := bv xor ('0' & bv(W-1 downto 1));
      gray_in <= gv;
      wait for 2 ns;
      exp_gray := bin xor ('0' & bin(W-1 downto 1));
      -- gray->bin : xor-prefix
      exp_bin(W-1) := gray_in(W-1);
      for i in W-2 downto 0 loop exp_bin(i) := exp_bin(i+1) xor gray_in(i); end loop;
      if gray    /= exp_gray then errc := errc + 1; report "bin2gray wrong" severity error; end if;
      if bin_out /= exp_bin  then errc := errc + 1; report "gray2bin wrong" severity error; end if;
    end loop;
    if errc = 0 then report "Test PASS" severity note; else report "Test FAILED" severity note; end if;
    finish;
  end process;
end architecture sim;
