library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity extended_and is
    generic (
        N: natural := 8
    );
    port (
        x0: in std_logic_vector(N-1 downto 0);
        x1: in std_logic;
        y: out std_logic_vector(N-1 downto 0)
    );
end extended_and;

architecture Behavioral of extended_and is

begin

y <= x0 when x1 = '1' else (others => '0');

end Behavioral;
