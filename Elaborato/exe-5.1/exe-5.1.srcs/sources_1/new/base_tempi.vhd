library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity base_tempi is
    port (
        clk: in std_logic;
        rst: in std_logic;
        tmp: out std_logic
    );
end base_tempi;

architecture Behavioral OF base_tempi IS
    signal counter : integer range 0 to 100_000_000 - 1 := 0;
    signal clk_div : std_logic := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then
                if counter = 100_000_000 - 1 then
                    counter <= 0;
                    clk_div <= not clk_div;
                else
                    counter <= counter + 1;
                end if;
            end if;
    end process;

tmp <= clk_div;

end Behavioral;