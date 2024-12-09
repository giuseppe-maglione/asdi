library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity generic_rom is
    generic ( 
            N: natural := 4;       -- numero di celle nella rom
            M: natural := 8;     -- dimensione di ciascuna cella (in bit)
            ADDR_LEN: natural := 2       -- dimensione dell'indirizzo
        );
    port (  
            clk: in std_logic;
            rst: in std_logic;
            read: in std_logic;     -- segnale di abilitazione lettura
            addr: in std_logic_vector(ADDR_LEN-1 downto 0);       -- indirizzo della cella da leggere
            data_out: out std_logic_vector(M-1 downto 0)        -- valore letto dalla cella
        );
end generic_rom;

architecture Behavioral of generic_rom is

type rom_array is array (0 to N-1) of std_logic_vector(M-1 downto 0);
signal rom: rom_array :=
    ("10101010", "10101010", "10101010", "10101010",
     others => "00000000");

begin

process(clk)
begin

    if rising_edge(clk) then 
    
        if rst = '1' then       -- reset sincrono
            rom <= (others => (others => '1'));       
        elsif read = '1' then       -- segnale di lettura
            data_out <= rom(to_integer(unsigned(addr)));
        end if;
        
    end if;

end process;
    
end Behavioral;