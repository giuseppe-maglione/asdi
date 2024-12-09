library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity system_S is
    port (
        clk: in std_logic;
        rst: in std_logic := '0';    
        start: in std_logic
    );
end system_S;

architecture Behavioral of system_S is

-- segnali di interconnessione tra componenti
signal serial: std_logic;

begin

-- istanziazione dell'unità A
unit_A: entity work.unit_A
    port map ( clk, rst, start, serial ); 

-- istanziazione dell'unità B
unit_B: entity work.unit_B
    port map ( clk, rst, serial );

end Behavioral;
