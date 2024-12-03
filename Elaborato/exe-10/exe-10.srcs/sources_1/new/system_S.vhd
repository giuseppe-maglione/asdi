library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity system_S is
    port (
        clk: in std_logic;
        rst: in std_logic := '0';    
        start: in std_logic;
        process_end: out std_logic
    );
end system_S;

architecture Behavioral of system_S is

type state is (idle, read_from_rom, send_data, wait_reception, write_in_mem, incr, finish);
signal curr_state: state := idle;

signal wr: std_logic := '0';
signal tx: std_logic := '0';
signal rx: std_logic := '0';

signal count: std_logic := '0';
signal counter: std_logic_vector(2 downto 0);
signal counter_end: std_logic := '0';

signal read_rom: std_logic := '0';
signal write_mem: std_logic := '0';

signal tx_ended: std_logic := '0';
signal rx_ended: std_logic := '0';

signal ended: std_logic := '0';

begin

-- istanziazione del contatore per scandire le locazioni di memoria
cnt: entity work.generic_counter
    generic map ( 8, 3 )
    port map ( clk => clk, rst => rst, count => count, counter => counter, counter_end => counter_end );

-- istanziazione dell'unità A
unit_A: entity work.unit_A
    port map ( clk => clk, rst => rst, wr => wr, read => read_rom, addr => counter, data_out => tx, transmission_ended => tx_ended );
    
rx <= tx;    

-- istanziazione dell'unità B
unit_B: entity work.unit_B
    port map ( clk => clk, rst => rst, write => write_mem, addr => counter, data_in => rx, reception_ended => rx_ended );
    
control_unit: process(clk)
begin

    if rising_edge(clk) then
        
    read_rom <= '0';
    wr <= '0';
    write_mem <= '0';
    ended <= '0';
    
        case curr_state is
        
            when idle =>
                if start = '1' then
                    curr_state <= read_from_rom;    
                else
                    curr_state <= idle;
                end if;

            when read_from_rom =>
                read_rom <= '1'; 
                curr_state <= send_data;
                
            when send_data =>
                wr <= '1';
                curr_state <= wait_reception;
                
            when wait_reception =>
                if rx_ended = '1' then
                    curr_state <= write_in_mem;
                else
                    curr_state <= wait_reception;
                end if;    
                 
            when write_in_mem =>
                write_mem <= '1';
                if counter = "1000" then
                    curr_state <= finish;
                else
                    curr_state <= incr;
                end if;
                
            when incr =>
                count <= '1';
                curr_state <= read_from_rom;    
                
            when finish =>
                ended <= '1'; 
                curr_state <= idle;
                   
        end case;
                
    end if;

end process;  

process_end <= ended; 

end Behavioral;
