library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity node_A is
    generic (
        N: natural := 4;        -- numero di celle di memoria
        M: natural := 8;     -- dimensione di ciascuna cella (in bit)
        L: natural := 2        -- dimensione degli indirizzi di memoria
    );
    port (
        clk: in std_logic;      -- clock
        rst: in std_logic;      -- reset
        start: in std_logic;        -- segnale avvio della macchina
        
        req: out std_logic;     -- richiesta handshake 
        ack: in std_logic;      -- ack handshake
        
        data_out: out std_logic_vector(M-1 downto 0)      -- segnale di uscita (dato nella rom)
    );
end node_A;

architecture Behavioral of node_A is

-- stati per l'automa dell'unità di controllo
type state is (idle, send_req, wait_ack, send_data, incr_addr, check_end);
signal curr_state: state := idle;

-- segnali intermedi tra i componenti
signal count: std_logic := '0';
signal ended: std_logic := '0';
signal addr: std_logic_vector(L-1 downto 0) := (others => '0');
signal read: std_logic := '0';

begin

-- istanziazione del contatore
cnt_A: entity work.generic_counter
    generic map ( N, L )
    port map ( clk => clk, rst => rst, count => count, counter => addr, counter_end => ended );
    
-- istanziazione della rom
rom_A: entity work.generic_rom
    generic map ( N, M, L )        -- supponiamo la rom abbia 4 locazioni da 8 bit
    port map ( clk => clk, rst => rst, read => read, addr => addr, data_out => data_out );
    
-- unità di controllo
control_unit_A: process(clk)
begin
    
    if rising_edge(clk) then
    
        case curr_state is
        
            when idle =>
                if start = '1' then
                    curr_state <= send_req;
                else
                    curr_state <= idle;
                end if;    
                    
            when send_req =>
                req <= '1';
                curr_state <= wait_ack;     
                
            when wait_ack =>
                req <= '0';
                if ack = '1' then
                    curr_state <= send_data;
                else
                    curr_state <= wait_ack;
                end if;
                
            when send_data =>       -- si immagina che sia direttamente la rom a fornire l'uscita del nodo A
                read <= '1';  
                curr_state <= incr_addr;              
        
            when incr_addr =>
                read <= '0';  
                count <= '1';
                curr_state <= check_end;
                
            when check_end =>
                count <= '0';
                if ended = '1' then
                    curr_state <= idle;
                else
                    curr_state <= send_req;
                end if;        
        
        end case;
   
    end if;
    
end process;       

end Behavioral;
