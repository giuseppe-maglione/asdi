library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity booth_encoder is
    generic (
        N : natural := 8  -- simensione della stringa in ingresso
    );
    port (
        data_in  : in  std_logic_vector(N-1 downto 0); -- stringa in ingresso
        data_out : out std_logic_vector(N-1 downto 0)  -- stringa in uscita compatta
    );
end booth_encoder;

architecture Behavioral of booth_encoder is

    signal extended_data : std_logic_vector(N downto 0); -- stringa estesa (per trovarci con gli indici)
    
begin

    extended_data <= '0' & data_in;     -- estendi la stringa con uno 0

    process(extended_data)
    begin
        for i in 0 to N-1 loop
            if (extended_data(i+1) = '0' and extended_data(i) = '1') then
                data_out(i) <= '1';
            elsif (extended_data(i+1) = '1' and extended_data(i) = '0') then
                data_out(i) <= '1';
            else
                data_out(i) <= '0';
            end if;
        end loop;
    end process;

end Behavioral;
