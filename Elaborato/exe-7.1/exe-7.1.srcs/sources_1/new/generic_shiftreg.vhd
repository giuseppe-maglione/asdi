library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity generic_shiftreg is
    generic ( 
        N: natural := 8     -- numero di elementi nel registro
    );
    port ( 
        clk: in std_logic;      -- clock
        rst: in std_logic;      -- reset
        shift: in std_logic;        -- segnale di abilitazione dello shift      
        load: in std_logic;     -- segnale per caricare il dato 
        data_in: in std_logic_vector(N-1 downto 0);       -- ingresso parallelo
        serial_in: in std_logic;        -- ingresso seriale
        data_out: out std_logic_vector(N-1 downto 0)     -- uscita parallela
    );
end generic_shiftreg;

architecture Behavioral of generic_shiftreg is

signal reg: std_logic_vector(N-1 downto 0) := (others => '0');      -- registro

begin

process(clk)
begin
    
    if rising_edge(clk) then
        
        if rst = '1' then       -- reset sincrono
            reg <= (others => '0');
        
        elsif load = '1' then       -- carica il dato in parallelo
            reg <= data_in;
                
        elsif shift = '1' then      -- shift
            reg(N-1 downto 1) <= reg(N-2 downto 0);
            reg(0) <= serial_in;       
        end if;
            
    end if;
        
end process;

data_out <= reg;

end Behavioral;
