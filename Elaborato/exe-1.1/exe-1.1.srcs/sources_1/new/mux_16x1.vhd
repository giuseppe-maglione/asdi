library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_16x1 is
    Port (
            data: in std_logic_vector(15 downto 0);     -- segnali in ingresso  
            sel: in std_logic_vector(3 downto 0);       -- selezione
            y: out std_logic        -- segnale di uscita             
          );
end mux_16x1;

architecture Behavioral of mux_16x1 is

signal inter_y: std_logic_vector(3 downto 0);   -- segnali intermedi da collegare al mux nel livello di output

component mux_4x1 is
    Port (
            data: in std_logic_vector(3 downto 0);
            sel: in std_logic_vector(1 downto 0);
            y: out std_logic             
          );
end component;

begin

mux0: mux_4x1       -- mux 0 nel primo livello
    port map ( data(3 downto 0), sel(1 downto 0), inter_y(0) );
    
mux1: mux_4x1       -- mux 1 nel primo livello
    port map ( data(7 downto 4), sel(1 downto 0), inter_y(1) );
    
mux2: mux_4x1       -- mux 2 nel primo livello
    port map ( data(11 downto 8), sel(1 downto 0), inter_y(2) );
    
mux3: mux_4x1       -- mux 3 nel primo livello
    port map ( data(15 downto 12), sel(1 downto 0), inter_y(3) );

mux_out: mux_4x1       -- mux nel livello di output
    port map ( inter_y, sel(3 downto 2), y );

end Behavioral;
