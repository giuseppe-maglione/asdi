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
            counter: out std_logic_vector(M-1 downto 0)     -- valore del conteggio attuale
        );
end generic_counter;

architecture Behavioral of generic_counter is

signal curr_count: std_logic_vector(M-1 downto 0) := (others => '0');       -- segnale di appoggio per conteggio corrente

begin

process(clk)
begin

    if rising_edge(clk) then 
    
        if rst = '1' then       -- reset sincrono
            curr_count <= (others => '0');
        else           
            if count = '1' then       -- segnale di conteggio
                curr_count <= std_logic_vector(unsigned(curr_count) + 1);   
            end if;    
        end if;
        
    end if;

end process;

counter <= std_logic_vector(curr_count);
    
end Behavioral;