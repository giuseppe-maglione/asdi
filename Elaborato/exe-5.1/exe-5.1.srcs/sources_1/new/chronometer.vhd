library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity chronometer is
    port (
        tmp: in std_logic;      -- base dei tempi fissata (ad esempio clock di sistema)
        start: in std_logic;        -- avvio del cronometro
        rst: in std_logic;      -- segnale per resettare il cronometro
        
        -- segnali per settare il cronometro
        set: in std_logic; 
        set_hh: in std_logic_vector(4 downto 0) := (others => '0');
        set_mm: in std_logic_vector(5 downto 0) := (others => '0');
        set_ss: in std_logic_vector(5 downto 0) := (others => '0');
        
        hh: out std_logic_vector(4 downto 0);
        mm: out std_logic_vector(5 downto 0);
        ss: out std_logic_vector(5 downto 0);
        ended: out std_logic        -- flag di terminazione
    );
end chronometer;

architecture Structural of chronometer is

-- segnali di fine del conteggio per ogni contatore
signal ss_ended: std_logic := '0';
signal mm_ended: std_logic := '0';

-- segnali utilizzati per abilitare i contatori
signal count_hh: std_logic := '0';
signal count_ss: std_logic := '0';
signal count_mm: std_logic := '0';

begin

-- logica per abilitare i contatori in maniera sincrona
count_ss <= tmp and start;        -- come richiesto, i secondi vengono scanditi dalla base dei tempi in ingresso
count_mm <= tmp and start and ss_ended;  
count_hh <= tmp and start and ss_ended and mm_ended;

-- istanziazione counter per i secondi
ss_counter: entity work.load_counter
    generic map ( 60, 6 )
    port map ( clk => tmp, rst => rst, load => set, load_val => set_ss, count => count_ss, counter => ss, counter_end => ss_ended );
  
-- istanziazione counter per i minuti
mm_counter: entity work.load_counter
    generic map ( 60, 6 )
    port map ( clk => tmp, rst => rst, load => set, load_val => set_mm, count => count_mm, counter => mm, counter_end => mm_ended );

-- istanziazione counter per le ore
hh_counter: entity work.load_counter
    generic map ( 24, 5 )
    port map ( clk => tmp, rst => rst, load => set, load_val => set_hh, count => count_hh, counter => hh, counter_end => ended );  
       
end Structural;
