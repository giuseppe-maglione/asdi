library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity generic_mem is
    generic ( 
            N: natural := 4;       -- numero di celle nella memoria
            M: natural := 8;     -- dimensione di ciascuna cella (in bit)
            ADDR_LEN: natural := 2       -- dimensione dell'indirizzo
        );
    port ( 
            clk: in std_logic;
            rst: in std_logic;
            read: in std_logic;     -- segnale di abilitazione lettura
            write: in std_logic;        -- segnale di abilitazione scrittura
            addr: in std_logic_vector(ADDR_LEN-1 downto 0);       -- indirizzo della cella da leggere
            data_in: in std_logic_vector(M-1 downto 0);     -- dato da inserire in caso di scrittura 
            data_out: out std_logic_vector(M-1 downto 0)        -- valore letto dalla cella
        );
end generic_mem;

architecture Behavioral of generic_mem is

type mem_array is array (0 to N-1) of std_logic_vector(M-1 downto 0);
signal mem: mem_array := (others => (others => '0'));

begin

process(clk)
begin

    if rising_edge(clk) then
    
        if rst = '1' then       -- reset sincrono
            mem <= (others => (others => '0'));       
    
        elsif read = '1' and write = '0' then      -- lettura
            data_out <= mem(to_integer(unsigned(addr)));
        elsif write = '1' and read = '0' then       -- scrittura
            mem(to_integer(unsigned(addr))) <= data_in;    
        
        end if;
        
    end if;

end process;
    
end Behavioral;