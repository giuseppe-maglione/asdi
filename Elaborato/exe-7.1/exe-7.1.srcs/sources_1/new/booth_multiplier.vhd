library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity booth_multiplier is
    generic (
        N: natural := 8     -- dimensione della stringa in ingresso    
    );
    port (
        clk: in std_logic;
        rst: in std_logic;
        start: in std_logic;
        
        x0: in std_logic_vector(N-1 downto 0);
        x1: in std_logic_vector(N-1 downto 0);

        result: out std_logic_vector(2*(N-1) downto 0);
        ended: out std_logic
    );
end booth_multiplier;

architecture Behavioral of booth_multiplier is

constant CNT_LEN: natural := 3;       -- dimensione del conteggio (in bit), log2(N) +1  

type state is (idle, input, scan, shift_reg, incr, check_end);
signal curr_state: state := idle;

-- segnali di interconnessione tra componenti
signal shift: std_logic := '0';
signal load_reg: std_logic := '0';
signal load_sr: std_logic := '0';

signal count: std_logic := '0';
signal counter: std_logic_vector(CNT_LEN-1 downto 0);
signal counter_end: std_logic := '0';

signal AQ_in: std_logic_vector(N-1 downto 0);
signal AQ_serial: std_logic;
signal AQ_out: std_logic_vector(N-1 downto 0);

signal Mreg_out: std_logic_vector(N-1 downto 0);
signal sel_M: std_logic := '0';     -- selezione del mux

signal addsub_1: std_logic_vector(N-1 downto 0);
signal subtract: std_logic := '0';
signal addsub_result: std_logic_vector(N-1 downto 0);
signal addsub_carry_out: std_logic := '0';      -- inutilizzato

begin

-- istanziazione del contatore
cnt: entity work.generic_counter
    generic map ( N, CNT_LEN )
    port map ( clk => clk, rst => rst, count => count, counter => counter, counter_end => counter_end );

-- istanziazione dell'adder-subtracter
add_subb: entity work.adder_subtracter
    generic map ( N )
    port map ( x0 => AQ_out(15 downto 7), x1 => addsub_1, carry_in => subtract, y => addsub_result, carry_out => addsub_carry_out );

-- istanziazione del registro M    
M:  entity work.generic_register    
    generic map ( N )
    port map ( clk => clk, rst => rst, load => load_reg, data_in => x1, data_out => Mreg_out );
    
-- istanziazione della and
--and_port:   
addsub_1 <= Mreg_out and (others => subtract);
    
-- istanziazione del registro AQ
AQ: entity work.generic_shiftreg
    generic map ( 2* N )
    port map ( clk => clk, rst => rst, load => load_sr, shift => shift, data_in => AQ_in, serial_in => AQ_serial, data_out => AQ_out );    
    
-- unità di controllo
control_unit: process(clk)
begin

    if rising_edge(clk) then
    
        case curr_state is
        
            when idle =>
                if start = '1' then
                    curr_state <= input;
                else 
                    curr_state <= idle;
                end if; 
                
            when input =>
                       
        
        end case;
    
    end if;

end process;    

end Behavioral;
