library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_4x1 is
    Port (
            data: in std_logic_vector(3 downto 0);      -- segnali in ingresso
            sel: in std_logic_vector(1 downto 0);       -- selezione
            y: out std_logic        -- segnale di uscita                
          );
end mux_4x1;

architecture Behavioral of mux_4x1 is

begin

    y <= data(0) when sel = "00" else
         data(1) when sel = "01" else
         data(2) when sel = "10" else
         data(3) when sel = "11" else
         '0';
    
end Behavioral;
