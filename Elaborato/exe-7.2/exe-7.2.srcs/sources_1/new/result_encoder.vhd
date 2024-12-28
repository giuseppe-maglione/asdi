library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity result_encoder is
    port (
        result: in std_logic_vector(15 downto 0);
        data_out: out std_logic_vector(23 downto 0)
    );        
end result_encoder;

architecture Behavioral of result_encoder is

signal result_u: integer;
signal result_d: integer;
signal result_tot : std_logic_vector(15 downto 0);
signal data_out_temp : std_logic_vector(23 downto 0);

begin

result_u <= to_integer(unsigned(result))mod 10;
result_d <= to_integer(unsigned(result)) / 10;
result_tot(7 downto 0) <= std_logic_vector(to_unsigned(result_u, 8));
result_tot(15 downto 8) <= std_logic_vector(to_unsigned(result_d, 8));

data_out_temp(15 downto 0) <= result_tot;
data_out_temp(23 downto 16) <= (others => '0');

data_out <= data_out_temp;

end Behavioral;
