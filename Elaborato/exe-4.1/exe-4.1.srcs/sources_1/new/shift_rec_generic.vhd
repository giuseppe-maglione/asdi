library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_rec_generic is
    generic ( 
            N: natural := 8     -- numero di elementi nel registro
    );
    port ( 
            clk: in std_logic;      -- clock
            rst: in std_logic;      -- segnale di reset
            shift: in std_logic;        -- segnale di abilitazione dello shift
            shift_dir: in std_logic;        -- direzione dello shift (0 -> destro, 1 -> sinistro)
            shift_num: in std_logic;        -- numero di shift da effettuare (0 -> 1 shift, 1 -> 2 shift)        
            data_in: in std_logic_vector(1 downto 0);      -- dato in ingresso al registro (se shifto di 2 inserisco 2 bit)
            parallel_out: out std_logic_vector(N-1 downto 0);
            data_out: out std_logic      -- dato in uscita dal registro
    );
end shift_rec_generic;

architecture Behavioral of shift_rec_generic is

signal reg: std_logic_vector(N-1 downto 0) := (others => '0');     -- registro

begin

process(clk)
begin

    if rising_edge(clk) then
    
        if rst = '1' then       -- reset sincrono
            reg <= (others => '0');
    
        elsif shift = '1' then     -- controlla se il segnale di shift è alto
    
            if shift_dir = '0' then     -- shift destro
                if shift_num = '0' then
                    reg <= data_in(0) & reg(N-1 downto 1);        -- shifta di 1 e metti il bit in ingresso a sinistra
                elsif shift_num = '1' then
                    reg <= data_in & reg(N-1 downto 2);       -- shifta di 2 e metti i bit in ingresso a sinistra
                end if;
                    
            else        -- shift sinistro
                if shift_num = '0' then
                    reg <= reg(N-2 downto 0) & data_in(0);        -- shifta di 1 e metti il bit in ingresso a destra
                elsif shift_num = '1' then
                    reg <= reg(N-3 downto 0) & data_in;       -- shifta di 2 e metti i bit in ingresso a destra
                end if;
            end if;
            
        end if;
    
    end if;

end process;

data_out <= reg(N-1) when shift_dir = '0' else reg(0);        -- valutazione dell'uscita
parallel_out <= reg;

end Behavioral;
