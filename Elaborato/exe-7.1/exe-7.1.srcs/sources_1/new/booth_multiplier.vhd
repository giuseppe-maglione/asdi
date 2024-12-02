library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity booth_multiplier is
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
        result: out std_logic_vector(2*N-1 downto 0);
        ended: out std_logic
    );
end booth_multiplier;

architecture Behavioral of booth_multiplier is

type state is (idle, load_data, mid, scan, rshift, incr, check_end);
signal curr_state: state := idle;

-- segnali di interconnessione tra componenti
signal shift: std_logic := '0';
signal load_reg: std_logic := '0';
signal load_sr: std_logic := '0';

signal count: std_logic := '0';
signal counter: std_logic_vector(CNT_LEN-1 downto 0);
signal counter_end: std_logic := '0';

signal AQ_in: std_logic_vector(2*N-1 downto 0);
signal AQ_serial: std_logic := '0';
signal AQ_out: std_logic_vector(2*N-1 downto 0);
signal AQ_sel: std_logic := '0';        -- segnale per scegliere l'ingresso di AQ (varia tra fase di init e successive)
signal AQ_init: std_logic_vector(2*N-1 downto 0);
signal AQ_addsub: std_logic_vector(2*N-1 downto 0);

signal Mreg_out: std_logic_vector(N-1 downto 0);

signal addsub_1: std_logic_vector(N-1 downto 0);
signal subtract: std_logic := '0';
signal addsub_result: std_logic_vector(N-1 downto 0);

signal rst_components: std_logic := '0';

signal x1_enc: std_logic_vector(N-1 downto 0);      -- stringa x1 con codifica di booth

signal qmeno1: std_logic := '0';        -- uscita del flip flop
signal qmeno1_in: std_logic := '0';      -- ingresso del flip flop
signal qmeno1_sel: std_logic := '0';

signal q10: std_logic_vector(1 downto 0) := (others => '0');

begin

-- istanziazione del codificatore di booth
--booth_enc: entity work.booth_encoder
--    generic map ( N )
--    port map ( data_in => x1, data_out => x1_enc );
x1_enc <= x1;
    
-- istanziazione del contatore
cnt: entity work.generic_counter
    generic map ( N, CNT_LEN )
    port map ( clk => clk, rst => rst_components, count => count, counter => counter, counter_end => counter_end );

-- istanziazione dell'adder-subtracter
add_subb: entity work.adder_subtracter
    generic map ( N )
    port map ( x0 => AQ_out(2*N-1 downto N), x1 => addsub_1, carry_in => subtract, y => addsub_result, carry_out => open );

-- istanziazione del registro M    
M:  entity work.generic_register    
    generic map ( N )
    port map ( clk => clk, rst => rst_components, load => load_reg, data_in => x1_enc, data_out => Mreg_out );
    
-- istanziazione della and
ext_and: entity work.extended_and
    generic map ( N )
    port map ( x0 => Mreg_out, x1 => subtract, y => addsub_1 );   

-- istanziazione del flip flop per contenere Q[-1]
ff_qmeno1: entity work.flipflop_d
    port map ( clk => clk, rst => rst_components, d => qmeno1_in, q => qmeno1 );
    
-- istanziazione del mux per scegliere l'ingresso del flip flop Q[-1]    
mux_qmeno1: entity work.mux_2x1
    port map ( x0 => qmeno1, x1 => AQ_out(0), sel => qmeno1_sel, y => qmeno1_in );    

AQ_serial <= AQ_out(2*N-1);  
-- istanziazione del registro AQ
AQ: entity work.generic_shiftreg
    generic map ( 2*N )
    port map ( clk => clk, rst => rst_components, load => load_sr, shift => shift, data_in => AQ_in, serial_in => AQ_serial, data_out => AQ_out ); 
        
AQ_init <= "00000000" & x0;   
AQ_addsub <= addsub_result & AQ_out(N-1 downto 0);
-- istanziazione del mux per scegliere l'ingresso al registro AQ
mux_AQ: entity work.ext_mux_2x1
    generic map ( 2*N )
    port map ( x0 => AQ_addsub, x1 => AQ_init, sel => AQ_sel, y => AQ_in );       
    
-- unità di controllo
control_unit: process(clk)
begin

    if rising_edge(clk) then
    
        case curr_state is
        
            when idle =>
                if start = '1' then
                    rst_components <= '1';
                    curr_state <= load_data;
                else 
                    curr_state <= idle;
                end if; 
                
            when load_data =>
                rst_components <= '0';  
                AQ_sel <= '1';      -- seleziona il valore di inizializzazione per AQ
                load_reg <= '1';        -- carica il registro M
                load_sr <= '1';     -- carica lo shift register
                curr_state <= mid;
                
            when mid =>     
                AQ_sel <= '0';      -- seleziona il valore di corretto per AQ
                load_reg <= '0';
                load_sr <= '0';
                curr_state <= scan;
                
            when scan =>
                if AQ_out(0) = qmeno1 then
                    curr_state <= rshift;
                else    
                    if AQ_out(0) = '0' and qmeno1 = '1' then
                        subtract <= '0';
                    elsif AQ_out(0) = '1' and qmeno1 = '0' then
                        subtract <= '1';
                    end if;
                    qmeno1_sel <= '1';      -- seleziona la memorizzazione del valore Q[-1]
                    load_sr <= '1';
                    curr_state <= rshift;
                end if;
                
            when rshift =>
                qmeno1_sel <= '0';
                load_sr <= '0';
                subtract <= '0';
                shift <= '1';
                curr_state <= incr;
                
            when incr =>
                shift <= '0';
                count <= '1';
                curr_state <= check_end;
                
            when check_end =>
                count <= '0';
                if counter_end = '1' then
                    curr_state <= idle;
                else
                    curr_state <= scan;
                end if;

        end case;
    
    end if;

end process; 

ended <= counter_end;
result <= AQ_out;

end Behavioral;
