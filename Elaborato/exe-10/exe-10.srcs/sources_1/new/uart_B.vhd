library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uart_B is
    port(
        clk: in std_logic;
        rst: in std_logic;
        rx: in std_logic;
        rst_components: out std_logic := '0';
        write_mem: out std_logic := '0';
        shift: out std_logic := '0';
        bit_received: out std_logic;
        rx_end: out std_logic := '0'
    );
end uart_B;

architecture Behavioral of uart_B is

signal rst_components_uart: std_logic := '0';
signal write_mem_uart: std_logic := '0';
signal shift_uart: std_logic := '0';
signal rx_end_uart: std_logic := '0';

-- stati per l'automa dell'uart
type state is (idle, delay8, wait0, wait1, receive_bit, finish);
signal curr_state: state := idle;

-- segnali del contatore per gestire l'invio dei bit
signal count_rx: std_logic := '0';
signal counter_rx: std_logic_vector(3 downto 0) := (others => '0');
signal counter_end_rx: std_logic := '0';

-- segnali del contatore per il delay di 8 impulsi
signal count_delay: std_logic := '0';
signal counter_delay: std_logic_vector(3 downto 0) := (others => '0');

begin

-- istanziazione del contatore per per contare i bit da ricevere con l'uart
cnt_delay: entity work.generic_counter
    generic map ( 9, 4 )
    port map ( clk => clk, rst => rst, count => count_rx, counter => counter_rx, counter_end => counter_end_rx );  

-- istanziazione del contatore per posizionarsi al centro del fronte
cnt_delay8: entity work.generic_counter
    generic map ( 8, 4 )
    port map ( clk => clk, rst => rst, count => count_delay, counter => counter_delay, counter_end => open );   

-- uart dell'unità B (si adotta la convenzione 8N1)
uart_B: process(clk)
begin

    if rising_edge(clk) then
    
        rst_components_uart <= '0';
        count_delay <= '0';
        write_mem <= '0';
        count_rx <= '0';    
        shift <= '0';
        rx_end <= '0';
    
        case curr_state is
        
            when idle =>
                if rx = '0' then
                    curr_state <= delay8;    
                else
                    curr_state <= idle;
                end if;

            when delay8 =>
                count_delay <= '1';
                if counter_delay = "1000" then
                    rst_components_uart <= '1';
                    curr_state <= wait0;
                else
                    curr_state <= delay8;
                end if;
                
            when wait0 =>  
                count_delay <= '1';
                if counter_rx = "1010" then
                    curr_state <= finish;
                elsif counter_delay(3) = '1' or counter_rx = "1010" then
                    curr_state <= wait0;
                elsif counter_delay(3) = '0' and counter_rx = "1010" then
                    curr_state <= wait1;
                end if;
            
            when wait1 =>
                count_delay <= '1';
                if counter_delay(3) = '1' then
                    curr_state <= receive_bit;
                else
                    curr_state <= wait1;
                end if;
                
            when receive_bit =>
                count_rx <= '1';
                shift <= '1';
                curr_state <= wait0;    
                   
            when finish =>
                write_mem <= '1';
                rx_end <= '1';
                curr_state <= idle;       
                   
        end case;
                
    end if;                

end process;

rst_components <= rst_components_uart;
write_mem <= write_mem_uart;
shift <= shift_uart;
rx_end <= rx_end_uart;
bit_received <= rx;

end Behavioral;
