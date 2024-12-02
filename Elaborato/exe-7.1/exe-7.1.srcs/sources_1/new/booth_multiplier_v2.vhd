library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity booth_multiplier_v2 is
    generic (
        N: natural := 8;     -- dimensione della stringa in ingresso    
        -- SCRIVI UNA FUNZIONE CHE CALCOLA AUTOMATICAMENTE CNT_LEN!
        CNT_LEN: natural := 3       -- log2(N) +1  
    );
    port (
        clk: in std_logic;
        rst: in std_logic;
        start: in std_logic;
        x0: in std_logic_vector(N-1 downto 0);
        x1: in std_logic_vector(N-1 downto 0);
        result: out std_logic_vector(2*N downto 0);
        ended: out std_logic
    );
end booth_multiplier_v2;

architecture Behavioral of booth_multiplier_v2 is

type state is (idle, load_data, scan, rshift);
signal curr_state: state := idle;

-- segnali di interconnessione tra componenti
signal count: std_logic := '0';
signal counter: std_logic_vector(CNT_LEN-1 downto 0);
signal counter_end: std_logic := '0';

signal shift: std_logic := '0';
signal load_AQ: std_logic := '0';
signal AQ_in: std_logic_vector(2*N downto 0);
signal AQ_serial: std_logic := '0';
signal AQ_out: std_logic_vector(2*N downto 0);
signal AQ_sel: std_logic := '0';        -- segnale per scegliere l'ingresso di AQ (varia tra fase di init e successive)
signal AQ_init: std_logic_vector(2*N downto 0);
signal AQ_addsub: std_logic_vector(2*N downto 0);

signal load_M: std_logic := '0';
signal M_out: std_logic_vector(N-1 downto 0);

signal subtract: std_logic := '0';
signal addsub_result: std_logic_vector(N-1 downto 0);

signal q10: std_logic_vector(1 downto 0) := (others => '0');

begin

-- istanziazione del registro M    
M:  entity work.generic_register    
    generic map ( N )
    port map ( clk => clk, rst => rst, load => load_M, data_in => x1, data_out => M_out );

-- istanziazione del registro AQ
AQ: entity work.generic_shiftreg
    generic map ( 2*N+1 )
    port map ( clk => clk, rst => rst, load => load_AQ, shift => shift, data_in => AQ_in, serial_in => AQ_serial, data_out => AQ_out ); 

-- istanziazione del mux per scegliere l'ingresso parallelo del registro AQ
mux_AQ: entity work.ext_mux_2x1
    generic map ( 2*N+1 )
    port map ( x0 => AQ_init, x1 => AQ_addsub, sel => AQ_sel, y => AQ_in );
    
-- istanziazione dell'adder-subtracter
add_subb: entity work.adder_subtracter
    generic map ( N )
    port map ( x0 => AQ_out(2*N downto N+1), x1 => M_out, carry_in => subtract, y => addsub_result, carry_out => open );
    
-- istanziazione del contatore
cnt: entity work.generic_counter
    generic map ( N, CNT_LEN )
    port map ( clk => clk, rst => rst, count => count, counter => counter, counter_end => counter_end );        
    
q10 <= AQ_out(1 downto 0);
AQ_serial <= AQ_out(2*N);          
AQ_init <= "00000000" & x0 & "0";       -- TOGLI GLI 0 E RENDI GENERALIZZABILE QUESTA OPERAZIONE
AQ_addsub <= addsub_result & AQ_out(N downto 0);    
    
-- unità di controllo
control_unit: process(clk)
begin

    if rising_edge(clk) then
        
        count <= '0';
        subtract <= '0';
        AQ_sel <= '0';
        load_M <= '0';
        load_AQ <= '0';
        shift <= '0';
            
        case curr_state is
        
            when idle =>
                if start = '1' then
                    curr_state <= load_data;
                else 
                    curr_state <= idle;
                end if; 
                
            when load_data =>
                AQ_sel <= '0';      -- seleziona il valore di inizializzazione per AQ
                load_AQ <= '1';     -- carica il registro AQ
                load_M <= '1';        -- carica il registro M
                curr_state <= scan;
                
            when scan =>
                if (q10 = "00" or q10 = "11") then
                    curr_state <= rshift;
                else    
                    if q10 = "01" then
                        subtract <= '0';
                    elsif q10 = "10" then
                        subtract <= '1';
                    end if;
                    AQ_sel <= '1';      -- seleziona il risultato per AQ
                    load_AQ <= '1';
                    curr_state <= rshift;
                end if;
                
            when rshift =>
                shift <= '1';
                if counter_end = '1' then
                    curr_state <= idle;
                else
                    count <= '1';
                    curr_state <= scan;
                end if;

        end case;
    
    end if;

end process; 

ended <= counter_end;
result <= AQ_out;

end Behavioral;
