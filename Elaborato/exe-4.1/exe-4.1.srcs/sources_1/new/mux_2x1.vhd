library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2x1 is
    Port (
            x0: in std_logic;
            x1: in std_logic;
            sel: in std_logic;
            y: out std_logic        
          );
end mux_2x1;

architecture Behavioral of mux_2x1 is

begin

    y <= x0 when sel = '0' else
         x1 when sel = '1' else 
         '0';

end Behavioral;