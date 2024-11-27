library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sequence_rec is
    port(
        tmp: in std_logic;      -- segnale di tempificazione
        data_in: in std_logic;      -- valore in ingresso
        mode: in std_logic;     -- modalità di funzionamento (0 -> seq non sovrapposte, 1 -> seq parzialmente sovrapposte)
        data_out: out std_logic       -- segnale di uscita
    );
end sequence_rec;

architecture Behavioral of sequence_rec is

type state is (s0, s1, s2);     -- dichiarazione stati per l'automa
signal curr_state: state := s0;
signal found: std_logic := '0';     -- segnale di appoggio per l'uscita

begin

process(tmp)
begin
    
    if rising_edge(tmp) then
    
        found <= '0';       -- assegna a found il valore default 0 
        
        case curr_state is
        
            when s0 =>
                if data_in = '1' then
                    curr_state <= s1;
                else
                    curr_state <= s0;
                end if;
                
            when s1 =>
                if data_in = '0' then
                    curr_state <= s2;   
                elsif (data_in = '1' and mode = '0') then
                    curr_state <= s0;
                elsif (data_in = '1' and mode = '1') then
                    curr_state <= s1;       -- sequenze parzialmente sovrapposte, rimango in s1                             
                end if;
                
            when s2 =>
                if (data_in = '1' and mode = '1') then
                    curr_state <= s1;
                    found <= '1';       -- sequenza riconosciuta
                elsif (data_in = '1' and mode = '0') then
                    curr_state <= s0;  
                    found <= '1';       -- sequenza riconosciuta
                else
                    curr_state <= s0;
                end if;
                                
        end case;
        
    end if; 
        
end process;

data_out <= found;

end Behavioral;
