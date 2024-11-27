library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rom_generic is
    generic ( 
            N: natural := 16;       -- numero di celle nella rom
            M: natural := 8;     -- dimensione di ciascuna cella (in bit)
            ADDR_LEN: natural := 4       -- dimensione dell'indirizzo
        );
    port ( 
            clk: in std_logic;
            read: in std_logic;     -- segnale di abilitazione
            addr: in std_logic_vector(ADDR_LEN-1 downto 0);       -- indirizzo della cella da leggere
            data_out: out std_logic_vector(M-1 downto 0)        -- valore letto dalla cella
        );
end rom_generic;

architecture Behavioral of rom_generic is

type rom_array is array (0 to N-1) of std_logic_vector(M-1 downto 0);
signal rom: rom_array :=
    ("00110010", "01011100", "00101101", "11111111",
     "00110110", "00111101", "10100101", "11011111",
     others => "00000000");

begin

process(clk)
begin

    if rising_edge(clk) and read = '1' then
        data_out <= rom(to_integer(unsigned(addr)));
    end if;

end process;
    
end Behavioral;
