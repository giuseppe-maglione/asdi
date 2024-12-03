library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_systemS is
end tb_systemS;

architecture Behavioral of tb_systemS is

    -- segnali per il testbench
    signal clk: std_logic;
    signal rst: std_logic := '0';
    signal start: std_logic := '0';
    signal process_end: std_logic := '0';  
    
    constant clk_period: time := 10 ns;

begin

    -- instanziazione del sistema
    S: entity work.system_S
        port map ( clk => clk, rst => rst, start => start, process_end => process_end );

    -- generazione del clock
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    process
    begin

        wait for clk_period;
        start <= '1';
        wait for clk_period;
        start <= '0';
        wait until process_end = '1';
        wait for clk_period;

        wait;

    end process;

end Behavioral;