library ieee;
use ieee.std_logic_1164.all;

entity priority_encoder is
  port (
    d     : in  std_logic_vector(3 downto 0);
    pos   : out std_logic_vector(1 downto 0);
    valid : out std_logic
  );
end entity priority_encoder;

architecture rtl of priority_encoder is
begin
  -- your implementation here

end architecture rtl;
