library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity machine_M is
    port ( 
            data_in: in std_logic_vector(7 downto 0);       -- stringa di bit in ingresso
            data_out: out std_logic_vector(3 downto 0)      -- stringa di bit in uscita
        );
end machine_M;

architecture Behavioral of machine_M is

begin

data_out(0) <= data_in(0) xor data_in(1);
data_out(1) <= data_in(2) xor data_in(3);
data_out(2) <= data_in(4) xor data_in(5);
data_out(3) <= data_in(6) xor data_in(7);

end Behavioral;