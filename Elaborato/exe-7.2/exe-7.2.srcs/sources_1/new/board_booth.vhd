library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity board_booth is
    port (
        clk: in std_logic;
        rst: in std_logic := '0';
        start: in std_logic := '0';     -- avvia moltiplicazione
        
        x: in std_logic_vector(7 downto 0);      -- primo operando (moltiplicando)
        y: in std_logic_vector(7 downto 0);      -- secondo operando (moltiplicatore)
        
        --result: out std_logic_vector(15 downto 0);     -- risultato del prodotto
        anodes_out: out std_logic_vector(7 downto 0);
        cathodes_out: out std_logic_vector(7 downto 0);
        ended: out std_logic := '0'     -- flag di terminazione della moltiplicazione
    );
end board_booth;

architecture Behavioral of board_booth is

-- segnali ripuliti
signal cleared_rst: std_logic;
signal cleared_start: std_logic;

signal result_temp: std_logic_vector(15 downto 0);
signal ended_temp: std_logic;

signal value_temp: std_logic_vector(23 downto 0);
signal display_in: std_logic_vector(23 downto 0);

begin

display_in <= value_temp;
ended <= ended_temp; 

-- istanziazione del moltiplicatore
booth_mul: entity work.booth_multiplier
    generic map ( 8 )
    port map ( clk => clk, rst => cleared_rst, start => cleared_start, x0 => x, x1 => y, result => result_temp, ended => ended_temp ); 
    
-- istanziazione del manager per il display
display: entity work.display_seven_segments
    port map ( clk => clk, rst => cleared_rst, value => display_in, enable => "11111111", 
    dots => "00000000", anodes => anodes_out, cathodes => cathodes_out );      

-- istanziazione del button debouncer per il bottone di reset e start
bd_rst: entity work.ButtonDebouncer
    port map ( rst => '0', clk => clk, btn => rst, cleared_btn => cleared_rst );
bd_start: entity work.ButtonDebouncer
    port map ( rst => '0', clk => clk, btn => start, cleared_btn => cleared_start ); 
    
-- istanziazione del encoder per il risultato
enc: entity work.result_encoder
    port map ( result => result_temp, data_out => value_temp );    

end Behavioral;
