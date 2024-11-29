library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity node_B is
    generic (
        N: natural := 4;        -- numero di celle di memoria 
        M: natural := 8;     -- dimensione di ciascuna cella (in bit)
        L: natural := 2        -- dimensione degli indirizzi di memoria
    );
    port (
        clk: in std_logic;      -- clock
        rst: in std_logic;      -- reset
        start: in std_logic;        -- segnale avvio della macchina        
        
        req: in std_logic;      -- richiesta handshake 
        ack: out std_logic;     -- ack handshake
        
        data_in: in std_logic_vector(M-1 downto 0)      -- segnale di ingresso (dato fornito dalla rom del nodo A)
    );
end node_B;

architecture Behavioral of node_B is

-- stati per l'automa dell'unità di controllo
type state is (idle, wait_req, send_ack, elaborate_data, save_data, incr_addr, check_end);
signal curr_state: state := idle;

-- segnali di interconnessione tra componenti
signal count: std_logic := '0';
signal ended: std_logic := '0';
signal read_addr: std_logic_vector(L-1 downto 0) := (others => '0');       -- indirizzo base, dove leggo
signal write_addr: std_logic_vector(L downto 0) := (others => '0');        -- indirizzo con offset, dove scrivo
signal addr: std_logic_vector(L downto 0) := (others => '0');        -- indirizzo effettivo usato
signal read: std_logic := '0';
signal write: std_logic := '0';
signal mem_data: std_logic_vector(M-1 downto 0) := (others => '0');       -- operando prelevato dalla memoria del nodo B
signal result: std_logic_vector(M-1 downto 0) := (others => '0');     -- segnale per memorizzare il risultato della somma
--  GESTIRE EVENTUALE OVERFLOW

constant offset: std_logic_vector(L downto 0) := "100";       -- offset memoria per scrittura
--  GENERALIZZARE LA RAPPRESENTAZIONE DI N PER OFFSET

begin

-- calcolo l'indirizzo di scrittura con offset
write_addr <= std_logic_vector(unsigned(read_addr) + unsigned(offset));

-- istanziazione del contatore
cnt_B: entity work.generic_counter
    generic map ( N, L )
    port map ( clk => clk, rst => rst, count => count, counter => read_addr, counter_end => ended );
    
-- istanziazione della memoria
mem_B: entity work.generic_mem
    generic map ( 2*N, M, L+1 )        -- supponiamo la memoria abbia 8 locazioni (4 per gli operandi e 4 per memorizzare i risultati) da 8 bit
    port map ( clk => clk, rst => rst, read => read, write => write, addr => addr, data_in => result, data_out => mem_data );
    
-- unità di controllo
control_unit_B: process(clk)
begin
    
    if rising_edge(clk) then
    
        case curr_state is
        
            when idle =>
                if start = '1' then
                    curr_state <= wait_req;
                else
                    curr_state <= idle;
                end if;      
        
            when wait_req =>
                if req = '1' then
                    curr_state <= send_ack;
                else
                    curr_state <= wait_req;
                end if;    
                    
            when send_ack =>
                ack <= '1';
                curr_state <= elaborate_data;     
                
            when elaborate_data =>
                ack <= '0';
                addr <= '0' & read_addr;        -- usa l'indirizzo di lettura
                read <= '1';
                result <= std_logic_vector( unsigned(mem_data) + unsigned(data_in) );
                curr_state <= save_data; 
                
            when save_data =>
                read <= '0'; 
                addr <= write_addr;      -- usa l'indirizzo di scrittura          
                write <= '1';
                curr_state <= incr_addr;              
        
            when incr_addr =>
                write <= '0';  
                count <= '1';
                addr <= '0' & read_addr;        -- ripristina l'indirizzo di lettura
                curr_state <= check_end;
                
            when check_end =>
                count <= '0';
                if ended = '1' then
                    curr_state <= idle;
                else
                    curr_state <= wait_req;
                end if;        
        
        end case;
   
    end if;
    
end process;        

end Behavioral;
