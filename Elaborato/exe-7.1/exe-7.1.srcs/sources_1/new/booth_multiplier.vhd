library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- DA FARE:
-- il segnale di reset dopo ogni operazione deve essere gestito dall'interno tramite rst_components
-- attualmente il moltiplicatore viene resettato a mano nel tb dopo ogni operazione
-- DA FARE:
-- separa unità di controllo e operativa
-- DA FARE:
-- scrivi una funzione per calcolare il nr di bit necessari al contatore per codificare counter

entity booth_multiplier is
    generic (
        N: natural := 8     -- dimensione della stringa in ingresso    
    );
    port (
        clk: in std_logic;
        rst: in std_logic := '0';
        start: in std_logic := '0';     -- avvia moltiplicazione
        x0: in std_logic_vector(N-1 downto 0);      -- primo operando (moltiplicando)
        x1: in std_logic_vector(N-1 downto 0);      -- secondo operando (moltiplicatore)
        result: out std_logic_vector(2*N-1 downto 0);     -- risultato del prodotto
        ended: out std_logic := '0'     -- flag di terminazione della moltiplicazione
    );
end booth_multiplier;

architecture Behavioral of booth_multiplier is

type state is (idle, load_data, mid, scan, rshift, incr, finish);
signal curr_state: state := idle;

-- SCRIVI UNA FUNZIONE CHE CALCOLA AUTOMATICAMENTE CNT_LEN!
signal CNT_LEN: natural := 3;       -- log2(N) +1, necessario per il contatore

-- segnali di interconnessione tra componenti
signal mul_ended: std_logic := '0';     -- segnale di appoggio per indicare la terminazione della moltiplicazione
signal rst_components: std_logic := '0';        -- segnale di reset per i componenti, utilizzato prima di avviare la moltiplicazione

signal count: std_logic := '0';     -- segnale per incrementare il conteggio
signal counter: std_logic_vector(CNT_LEN-1 downto 0);       -- valore corrente del conteggio

signal shift: std_logic := '0';     -- segnale per avviare lo shift
signal load_AQ: std_logic := '0';       -- carica il registro AQ
signal AQ_in: std_logic_vector(2*N downto 0);
signal AQ_serial: std_logic := '0';
signal AQ_out: std_logic_vector(2*N downto 0);
signal AQ_sel: std_logic := '0';        -- segnale per scegliere l'ingresso di AQ (varia tra fase di init e successive)
signal AQ_init: std_logic_vector(2*N downto 0);
signal AQ_addsub: std_logic_vector(2*N downto 0);

signal load_M: std_logic := '0';        -- carica il registro M
signal M_out: std_logic_vector(N-1 downto 0);       -- uscita parallela del registro M

signal subtract: std_logic := '0';
signal addsub_result: std_logic_vector(N-1 downto 0);       -- risultato dell'adder-subtracter

signal q10: std_logic_vector(1 downto 0) := (others => '0');        -- bit negli indici 0, -1 del registro AQ

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
mux_AQ_in: entity work.ext_mux_2x1
    generic map ( 2*N+1 )
    port map ( x0 => AQ_init, x1 => AQ_addsub, sel => AQ_sel, y => AQ_in );
    
-- istanziazione dell'adder-subtracter
add_subb: entity work.adder_subtracter
    generic map ( N )
    port map ( x0 => AQ_out(2*N downto N+1), x1 => M_out, carry_in => subtract, y => addsub_result, carry_out => open );
    
-- istanziazione del contatore
cnt: entity work.generic_counter
    generic map ( N, CNT_LEN )
    port map ( clk => clk, rst => rst, count => count, counter => counter );        
    
q10 <= AQ_out(1 downto 0);
AQ_serial <= AQ_out(2*N);          
AQ_init <= "00000000" & x0 & "0";       -- TOGLI GLI 0 E RENDI GENERALIZZABILE QUESTA OPERAZIONE
AQ_addsub <= addsub_result & AQ_out(N downto 0);    
    
-- unità di controllo
control_unit: process(clk)
begin

    if rising_edge(clk) then
        
        rst_components <= '0';
        count <= '0';
        subtract <= '0';
        AQ_sel <= '0';
        load_M <= '0';
        load_AQ <= '0';
        shift <= '0';
        mul_ended <= '0';
            
        case curr_state is
        
            -- stato di attesa
            when idle =>        
                if start = '1' then
                    rst_components <= '1';
                    curr_state <= load_data;
                else 
                    curr_state <= idle;
                end if; 
                
            -- stato per caricare i dati nei registri    
            when load_data =>      
                AQ_sel <= '0';      -- seleziona il valore di inizializzazione per AQ
                load_AQ <= '1';     -- carica il registro AQ
                load_M <= '1';        -- carica il registro M
                curr_state <= mid; 
            
            when mid =>
                curr_state <= scan;
            
            -- stato per eseguire le operazioni    
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
            
            -- stato per shiftare e controllare la terminazione    
            when rshift =>      
                shift <= '1';
                if counter = "111" then
                    curr_state <= finish;
                else
                    curr_state <= incr;
                end if;
            
            -- stato per incrementare il contatore    
            when incr =>    
                count <= '1';
                curr_state <= scan;
            
            -- stato finale    
            when finish =>
                mul_ended <= '1';       -- alza il flag di terminazione
                curr_state <= idle;

        end case;
    
    end if;

end process; 

ended <= mul_ended;
result <= AQ_out(2*N downto 1);

end Behavioral;