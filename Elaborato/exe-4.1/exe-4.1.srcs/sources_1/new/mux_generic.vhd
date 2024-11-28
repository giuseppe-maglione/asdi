library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux_generic is
    generic ( 
            N: natural := 4;     -- numero di ingressi
            M: natural := 3        -- numero di bit di selezione    
    );
    port ( 
            data_in: in std_logic_vector(N-1 downto 0);     -- segnali in ingresso
            sel: in std_logic_vector(M-1 downto 0);     -- segnale di selezione
            data_out: out std_logic      -- segnale in uscita
    );
end mux_generic;

architecture Behavioral of mux_generic is

begin

process(sel, inputs)
    variable sel_idx: integer; -- Indice calcolato a partire dal selettore
begin
    sel_idx := to_integer(unsigned(sel)); -- Converti il selettore in un indice intero
    if sel_idx < N then
        -- Estrai l'ingresso selezionato dalla concatenazione e assegnalo all'uscita
        output <= inputs(sel_idx*W + W-1 downto sel_idx*W);
    else
        -- In caso di indice non valido, assegna valori di default
        output <= (others => '0');
    end if;
end process;

end Behavioral;
