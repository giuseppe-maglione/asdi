library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity load_counter is
    generic ( 
            N: natural := 16;       -- numero massimo di conteggi
            M: natural := 4     -- dimensione del conteggio (in bit)
        );
    port (  
            clk: in std_logic;
            rst: in std_logic;
            load: in std_logic;     -- segnale di load
            load_val: in std_logic_vector(M-1 downto 0);       -- valore con cui caricare il counter
            count: in std_logic;     -- segnale di abilitazione conteggio
            counter: out std_logic_vector(M-1 downto 0);     -- valore del conteggio attuale
            counter_end: out std_logic := '0'       -- flag termine del conteggio
        );
end load_counter;

architecture Behavioral of load_counter is

signal curr_count: unsigned(M-1 downto 0) := (others => '0');       -- segnale di appoggio per conteggio corrente
signal ended: std_logic := '0';     -- segnale di appoggio per termine conteggio

begin

process(clk)
begin

    if rising_edge(clk) then 
    
        if rst = '1' then       -- reset sincrono
            ended <= '0';
            curr_count <= (others => '0');
           
        elsif load = '1' then   
            ended <= '0';
            curr_count <= unsigned(load_val);    
                   
        elsif count = '1' then       -- segnale di conteggio
            if curr_count = N-1 then    
                ended <= '1';       -- termine conteggio
                curr_count <= (others => '0');
            else
                ended <= '0';
                curr_count <= curr_count + 1;   
            end if;
            
        end if;
        
    end if;

end process;

counter <= std_logic_vector(curr_count);
counter_end <= ended;
    
end Behavioral;