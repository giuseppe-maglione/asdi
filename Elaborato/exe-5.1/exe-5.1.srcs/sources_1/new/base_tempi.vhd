library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity divisore_frequenza is
    port (
        clk: in std_logic;
        rst: in std_logic;
        tmp: out std_logic
    );
end divisore_frequenza;

architecture Behavioral OF divisore_frequenza is

    constant divisor : integer := 100_000_000 / 2;
    signal counter : integer := 0;
    signal clk_out : STD_LOGIC := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then
        
            if rst = '1' then
                counter <= 0;
                clk_out <= '0'; 
                
            else        
                if counter = divisor - 1 then
                        counter <= 0;
                        clk_out <= not clk_out;
                else
                        counter <= counter + 1;
                end if;        
            end if;
            
        end if;        
    end process;

tmp <= clk_out;

end Behavioral;