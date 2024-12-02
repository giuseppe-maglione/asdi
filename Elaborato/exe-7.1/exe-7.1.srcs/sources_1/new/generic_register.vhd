library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity generic_register is
    generic (
        N: natural := 8     -- dimensione del registro    
    );
    port (
        clk: in std_logic;
        rst: in std_logic;
        load: in std_logic;
        data_in: in std_logic_vector(N-1 downto 0);
        data_out: out std_logic_vector(N-1 downto 0)
    );
end generic_register;

architecture Behavioral of generic_register is

signal reg: std_logic_vector(7 downto 0);

begin

process(clk)
begin

    if rising_edge(clk) then
    
        if rst = '1' then
            reg <= (others => '0');
        elsif load = '1' then
            reg <= data_in;        
        end if;    
    
    end if;

end process;

data_out <= reg;

end Behavioral;
