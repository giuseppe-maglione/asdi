library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_4x1 is
    Port (
            x: in std_logic_vector(3 downto 0);
            sel: in std_logic_vector(1 downto 0);
            y: out std_logic        
          );
end mux_4x1;

architecture Behavioral of mux_4x1 is

begin

    y <= x(0) when sel = "00" else
         x(1) when sel = "01" else 
         x(2) when sel = "10" else 
         x(3) when sel = "11" else 
         '0';

end Behavioral;