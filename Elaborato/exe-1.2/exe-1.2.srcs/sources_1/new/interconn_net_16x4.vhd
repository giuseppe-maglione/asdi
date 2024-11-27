library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;

entity interconn_net_16x4 is
    Port (
            data: in std_logic_vector(15 downto 0);     -- segnali in ingresso  
            sel: in std_logic_vector(5 downto 0);       -- selezione
            y: out std_logic_vector(3 downto 0)     -- segnali di uscita             
          );
end interconn_net_16x4;

architecture Behavioral of interconn_net_16x4 is

signal mux_out: std_logic;

begin

mux16: entity work.mux_16x1
    port map ( data => data, sel => sel(5 downto 2), y => mux_out );

demux4: entity work.demux_1x4
    port map ( data => mux_out, sel => sel(1 downto 0), y => y ); 

end Behavioral;
