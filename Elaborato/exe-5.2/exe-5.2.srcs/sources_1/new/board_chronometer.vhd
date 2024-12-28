library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity board_chronometer is
    port (
        clk: in std_logic;
        rst: in std_logic;
        start: in std_logic;

        -- segnali per settare il cronometro
        --set: in std_logic := '0'; 
        ss_load: in std_logic;
        mm_load: in std_logic;
        hh_load: in std_logic;
--        ss_set: in std_logic_vector(5 downto 0) := (others => '0');
--        mm_set: in std_logic_vector(5 downto 0) := (others => '0');
--        hh_set: in std_logic_vector(4 downto 0) := (others => '0');
        shm_set: in std_logic_vector(0 to 5);
        
        anodes_out: out std_logic_vector(7 downto 0);
        cathodes_out: out std_logic_vector(7 downto 0)

    );
end board_chronometer;

architecture Behavioral of board_chronometer is

-- segnali ripuliti
signal cleared_rst: std_logic;

-- segnali di uscita del cronometro
signal ss_temp: std_logic_vector(5 downto 0);
signal mm_temp: std_logic_vector(5 downto 0);
signal hh_temp: std_logic_vector(4 downto 0);
signal temp_value: std_logic_vector(23 downto 0);

signal ss_var: std_logic_vector(5 downto 0);
signal mm_var: std_logic_vector(5 downto 0);
signal hh_var: std_logic_vector(4 downto 0);
signal var_value: std_logic_vector(23 downto 0);

signal display_in: std_logic_vector(23 downto 0);

begin

-- istanziazione del cronometro
chrono: entity work.chronometer
    port map ( clk => clk, start => start, rst => cleared_rst, ss_load => ss_load, mm_load => mm_load,
    hh_load => hh_load, ss_set => shm_set(0 to 5), mm_set => shm_set(0 to 5), hh_set => shm_set(1 to 5), 
    ss => ss_temp, mm => mm_temp, hh => hh_temp );
    
 -- istanziazione del manager per il display
display: entity work.display_seven_segments
    port map ( clk => clk, rst => cleared_rst, value => display_in, enable => "11111111", 
    dots => "00010100", anodes => anodes_out, cathodes => cathodes_out );   

-- istanziazione degli encoder per il cronometro
enc_chrono: entity work.time_encoder
    port map ( ss => ss_temp, mm => mm_temp, hh => hh_temp, data_out => temp_value );
switch_chrono: entity work.time_encoder
    port map ( ss => ss_var, mm => mm_var, hh => hh_var, data_out => var_value );
    
-- istanziazione del button debouncer per il bottone di reset
bd_rst: entity work.ButtonDebouncer
    port map ( rst => '0', clk => clk, btn => rst, cleared_btn => cleared_rst );

select_display_out: process(clk, start, ss_load, mm_load, hh_load)
begin

    if rising_edge(clk) then
        if start = '1' then
            if ss_load = '1' then
                ss_var <= shm_set;
                display_in <= var_value;
            elsif mm_load = '1' then
                mm_var <= shm_set;
                display_in <= var_value;
            elsif hh_load = '1' then
                hh_var <= shm_set(1 to 5);
                display_in <= var_value;
            else    
                display_in <= temp_value;
            end if;
        end if;            
    end if;
    
end process;

end Behavioral;
