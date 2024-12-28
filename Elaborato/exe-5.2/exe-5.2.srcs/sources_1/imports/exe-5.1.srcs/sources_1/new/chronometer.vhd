library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity chronometer is
    port (
        clk: in std_logic;      -- clock
        start: in std_logic;        -- avvio del cronometro
        rst: in std_logic := '0';      -- segnale per resettare il cronometro
        
        -- segnali per settare il cronometro
        --set: in std_logic := '0'; 
        ss_load: in std_logic;
        mm_load: in std_logic;
        hh_load: in std_logic;
        ss_set: in std_logic_vector(5 downto 0) := (others => '0');
        mm_set: in std_logic_vector(5 downto 0) := (others => '0');
        hh_set: in std_logic_vector(4 downto 0) := (others => '0');
        
        -- segnali di uscita
        ss: out std_logic_vector(5 downto 0);
        mm: out std_logic_vector(5 downto 0);
        hh: out std_logic_vector(4 downto 0);
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
signal tmp: std_logic;

begin

-- istanziazione base dei tempi
tmp_base: entity work.base_tempi
    port map ( clk_in => clk, rst => rst, clk_out => tmp );  

--tmp <= clk; 

-- logica per abilitare i contatori in maniera sincrona
ss_enable <= tmp and start;     -- i secondi sono scanditi dalla base dei tempi
--ss_enable <= start and clk;
mm_enable <= tmp and start and ss_ended;  
--mm_enable <= ss_ended and start and clk;
hh_enable <= tmp and start and ss_ended and mm_ended;   
--hh_enable <= mm_ended and ss_ended and start and clk;

-- istanziazione contatore per i secondi
ss_cnt: entity work.counter_mod60
    port map ( clk => tmp, rst => rst, load => ss_load, load_val => ss_set, enable => ss_enable, count => ss, enable_next => ss_ended );
  
-- istanziazione contatore per i minuti
mm_cnt: entity work.counter_mod60
    port map ( clk => tmp, rst => rst, load => mm_load, load_val => mm_set, enable => mm_enable, count => mm, enable_next => mm_ended );

-- istanziazione contatore per le ore
hh_cnt: entity work.counter_mod24
    port map ( clk => tmp, rst => rst, load => hh_load, load_val => hh_set, enable => hh_enable, count => hh, enable_next => hh_ended );  

ended <= hh_ended;
       
end Structural;
