library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity generic_counter is
    generic ( 
            N: natural := 16;       -- numero massimo di conteggi
            M: natural := 4     -- dimensione del conteggio (in bit)
        );
    port (  
            clk: in std_logic;
            rst: in std_logic;
            count: in std_logic;     -- segnale di abilitazione conteggio
            counter: out std_logic_vector(M-1 downto 0);     -- valore del conteggio attuale
            counter_end: out std_logic := '0'       -- flag termine del conteggio
        );
end generic_counter;

architecture Behavioral of generic_counter is

signal curr_count: unsigned(M-1 downto 0) := (others => '0');       -- segnale di appoggio per conteggio corrente
signal ended: std_logic := '0';     -- segnale di appoggio per termine conteggio

begin

process(clk)
begin

    if (clk'event and clk = '1') then 
    
        if rst = '1' then       -- reset sincrono
            ended <= '0';
            curr_count <= (others => '0');
        
        elsif curr_count = N-1 then
            if count = '1' then
                curr_count <= (others => '0');
                ended <= '1';
            end if;  
        else
            if count = '1' then
                curr_count <= curr_count + 1;
                ended <= '0';
             end if;
            
        end if;
        
    end if;

end process;

counter <= std_logic_vector(curr_count);
counter_end <= ended;
    
end Behavioral;