library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity demux_1x4 is
    Port (
            data: in std_logic;     -- segnale in ingresso  
            sel: in std_logic_vector(1 downto 0);       -- selezione
            y: out std_logic_vector(3 downto 0)     -- segnali di uscita             
          );
end demux_1x4;

architecture Behavioral of demux_1x4 is

begin

    y(0) <= data when sel = "00" else '0';
    y(0) <= data when sel = "01" else '0';
    y(0) <= data when sel = "10" else '0';
    y(0) <= data when sel = "11" else '0';

end Behavioral;
