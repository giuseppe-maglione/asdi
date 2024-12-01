library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity booth_encoder is
    generic (
        N: natural := 8     -- dimensione della stringa in ingresso
    );
    port (
        data_in: in std_logic_vector(N-1 downto 0);     -- stringa in ingresso
        data_out: out std_logic_vector(2*(N-1) downto 0)        -- stringa in uscita
    );
end booth_encoder;

architecture Behavioral of booth_encoder is

begin

process(data_in)
begin
    
    for i in 0 to N-1 loop
        if (data_in(i) = '0' and data_in(i-1) = '1') then
            data_out(i) <= '0';
            data_out(i+1) <= '1';
        elsif (data_in(i) = '1' and data_in(i-1) = '0') then
            data_out(i) <= '1';
            data_out(i+1) <= '1';
        else
            data_out(i) <= '0';
            data_out(i+1) <= '0';
        end if;
    end loop;    
    
end process;

end Behavioral;
