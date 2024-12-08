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

-- stati per l'automa dell'unità di controllo
type state is (idle, read_from_rom, send_data, wait_reception, write_in_mem, incr, finish);
signal curr_state: state := idle;

-- segnali di interconnessione tra componenti
signal count: std_logic := '0';
signal counter: std_logic_vector(2 downto 0);
signal counter_end: std_logic := '0';

signal read_rom: std_logic := '0';
signal write_mem: std_logic := '0';

signal serial: std_logic := '1';

signal start_transmission: std_logic := '0';
signal data_transferred: std_logic := '0';
signal data_received: std_logic := '0';
signal ended: std_logic := '0';

begin

-- istanziazione del contatore per scandire le locazioni di memoria
cnt: entity work.generic_counter
    generic map ( 8, 3 )
    port map ( clk => clk, rst => rst, count => count, counter => counter, counter_end => counter_end );

-- istanziazione dell'unità A
unit_A: entity work.unit_A
    port map ( clk, rst, serial, read_rom, counter, start_transmission, data_transferred ); 

-- istanziazione dell'unità B
unit_B: entity work.unit_B
    port map ( clk, rst, serial, write_mem, counter, data_received );
    
control_unit: process(clk)
begin

    if rising_edge(clk) then
        
    read_rom <= '0';
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
                start_transmission <= '1';
                if data_transferred = '1' then
                    curr_state <= wait_reception;
                else
                    curr_state <= send_data;
                end if;
                
            when wait_reception =>
                if data_received = '1' then
                    curr_state <= write_in_mem;
                else
                    curr_state <= wait_reception;
                end if;    
                 
            when write_in_mem =>
                start_transmission <= '0';
                write_mem <= '1';
                if counter = "111" then
                    ended <= '1';
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
