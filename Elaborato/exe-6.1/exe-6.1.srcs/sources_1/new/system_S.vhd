library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity system_S is
    port (
        clk: in std_logic;
        rst: in std_logic;
        start: in std_logic;      
        ended: out std_logic
    );
end system_S;

architecture Structural of system_S is

constant N: integer := 4;
constant DIM_ROM: integer := 8;     -- fornito dal problema
constant DIM_MEM: integer := 4;     -- fornito dal problema
constant ADDR_LEN: integer := 2;     -- bit per rappresentare gli indirizzi

-- segnali di interconnessione tra componenti
signal read: std_logic := '0';      -- segnale per lettura dalla rom
signal rom_data: std_logic_vector(DIM_ROM-1 downto 0);       -- dato contenuto nella rom
signal machine_data: std_logic_vector(DIM_MEM-1 downto 0);      -- dato usito dalla macchina M 
signal count: std_logic := '0';     -- segnale per abilitare il conteggio
signal write: std_logic := '0';      -- segnale per scrittura nella mem
signal addr: std_logic_vector(ADDR_LEN-1 downto 0) := (others => '0');     -- indirizzo generato dal contatore
signal process_ended: std_logic := '0';

-- stati per l'automa dell'unità di controllo
type state is (idle, read_rom, write_mem, incr_addr, check_end);
signal curr_state: state := idle;       -- stato corrente

begin

-- istanziazione del contatore
cnt_N: entity work.generic_counter
    generic map ( N, ADDR_LEN )
    port map ( clk => clk, rst => rst, count => count, counter => addr, counter_end => process_ended );
    
-- istanziazione della rom
rom: entity work.generic_rom
    generic map ( N, DIM_ROM, ADDR_LEN )
    port map ( clk => clk, rst => rst, read => read, addr => addr, data_out => rom_data );  
    
-- istanziazione della macchina M
M: entity work.machine_M
    port map ( data_in => rom_data, data_out => machine_data );      

-- istanziazione della memoria
mem: entity work.generic_mem
    generic map ( N, DIM_MEM, ADDR_LEN )
    port map ( clk => clk, rst => rst, read => '0', write => write, addr => addr, data_in => machine_data, data_out => open );    
        
control_unit: process(clk)
begin    

    if rising_edge(clk) then
    
        case curr_state is
        
            when idle =>
                if start = '1' then
                    curr_state <= read_rom;
                else
                    curr_state <= idle;
                end if;

            when read_rom =>
                read <= '1';        -- la lettura dalla rom preleva il dato e fa attivare direttamente la macchina M
                curr_state <= write_mem;
                
            when write_mem =>
                read <= '0';
                write <= '1';    
                curr_state <= incr_addr;
                
            when incr_addr =>
                write <= '0';
                count <= '1';
                curr_state <= check_end;
                          
            when check_end =>
                count <= '0';
                if process_ended = '1' then
                    curr_state <= idle;
                else
                    curr_state <= read_rom;
                end if;    

        end case;
    
    end if;

end process;

ended <= process_ended;
        
end Structural;
