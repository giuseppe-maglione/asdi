library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ext_mux_2x1 is
    generic (
        N: natural := 8
    );
    port (
            x0: in std_logic_vector(N-1 downto 0);
            x1: in std_logic_vector(N-1 downto 0);
            sel: in std_logic;
            y: out std_logic_vector(N-1 downto 0)        
          );
end ext_mux_2x1;

architecture Behavioral of ext_mux_2x1 is

begin

    y <= x0 when sel = '0' else
         x1 when sel = '1' else 
         (others => '0');

end Behavioral;