library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity chronometer is
    port (
        clk: in std_logic;      -- clock
        start: in std_logic;        -- avvio del cronometro
        rst: in std_logic := '0';      -- segnale per resettare il cronometro
        
        -- segnali per settare il cronometro
        set: in std_logic := '0'; 
        ss_set: in std_logic_vector(5 downto 0) := (others => '0');
        mm_set: in std_logic_vector(5 downto 0) := (others => '0');
        hh_set: in std_logic_vector(4 downto 0) := (others => '0');
        
        -- segnali di uscita
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
signal hh_ended: std_logic := '0';

-- segnali utilizzati per abilitare i contatori
signal ss_enable: std_logic;
signal mm_enable: std_logic;
signal hh_enable: std_logic;

-- segnale di uscita della base dei tempi
signal tmp: std_logic := '0';

begin

-- istanziazione base dei tempi
tmp_base: entity work.base_tempi
    port map ( clk => clk, rst => rst, tmp => tmp );

-- logica per abilitare i contatori in maniera sincrona
ss_enable <= tmp and start;     -- i secondi sono scanditi dalla base dei tempi
mm_enable <= tmp and start and ss_ended;  
hh_enable <= tmp and start and ss_ended and mm_ended;   

-- istanziazione contatore per i secondi
ss_cnt: entity work.load_counter
    generic map ( 60, 6 )
    port map ( clk => clk, rst => rst, load => set, load_val => ss_set, count => ss_enable, counter => ss, counter_end => ss_ended );
  
-- istanziazione contatore per i minuti
mm_cnt: entity work.load_counter
    generic map ( 60, 6 )
    port map ( clk => clk, rst => rst, load => set, load_val => mm_set, count => mm_enable, counter => mm, counter_end => mm_ended );

-- istanziazione contatore per le ore
hh_cnt: entity work.load_counter
    generic map ( 24, 5 )
    port map ( clk => clk, rst => rst, load => set, load_val => hh_set, count => hh_enable, counter => hh, counter_end => hh_ended );  

ended <= hh_ended;
       
end Structural;
