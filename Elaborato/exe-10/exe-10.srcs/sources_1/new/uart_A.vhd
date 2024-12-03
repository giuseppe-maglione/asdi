library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uart_A is
    port(
        clk: in std_logic;
        rst: in std_logic;
        wr: in std_logic;
        rst_components: out std_logic := '0';
        load_sr: out std_logic := '0';
        shift: out std_logic := '0';
        tx_end: out std_logic := '0'
    );
end uart_A;

architecture Behavioral of uart_A is

signal rst_components_uart: std_logic := '0';
signal load_sr_uart: std_logic := '0';
signal shift_uart: std_logic := '0';
signal tx_end_uart: std_logic := '0';

-- stati per l'automa dell'uart
type state is (idle, load, send_bit, delay_and_incr, finish);
signal curr_state: state := idle;

-- segnali del contatore per gestire l'invio dei bit
signal count_tx: std_logic := '0';
signal counter_tx: std_logic_vector(3 downto 0) := (others => '0');
signal counter_end_tx: std_logic := '0';

begin

-- istanziazione del contatore per contare i bit da trasmettere con l'uart
cnt_tx: entity work.generic_counter
    generic map ( 10, 4 )
    port map ( clk => clk, rst => rst, count => count_tx, counter => counter_tx, counter_end => counter_end_tx );   

-- uart dell'unità A (si adotta la convenzione 8N1)
uart_A: process(clk)
begin

    if rising_edge(clk) then
    
        rst_components_uart <= '0';
        load_sr_uart <= '0';
        count_tx <= '0';    
        shift_uart <= '0';
        tx_end_uart <= '0';

    
        case curr_state is
        
            when idle =>
                if wr = '1' then
                    rst_components_uart <= '1';
                    curr_state <= load;    
                else
                    curr_state <= idle;
                end if;

            when load =>
                load_sr_uart <= '1';        -- carica lo shift register con tx
                curr_state <= send_bit;
                
            when send_bit =>
                shift_uart <= '1';
                if counter_tx = "1010" then
                    curr_state <= finish;
                else
                    curr_state <= delay_and_incr;    
                end if;
                
            when delay_and_incr =>     -- stato di delay ?
                count_tx <= '1';
                curr_state <= finish;    
                
            when finish =>
                tx_end_uart <= '1';      -- qui l'unità di controllo incrementa il counter!
                curr_state <= idle;
                   
        end case;
                
    end if;                

end process;

rst_components <= rst_components_uart;
load_sr <= load_sr_uart;
shift <= shift_uart;
tx_end <= tx_end_uart;

end Behavioral;
