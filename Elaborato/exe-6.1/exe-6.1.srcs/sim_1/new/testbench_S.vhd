library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_system is
end tb_system;

architecture Structural of tb_system is

    -- segnali di testbench
    signal clk_tb: std_logic;
    signal rst_tb: std_logic := '0';
    signal start_tb: std_logic := '0';
    signal ended_tb: std_logic := '0';

    constant clk_period: time := 20 ns;

begin

    -- istanziazione del sistema S
    s: entity work.system_S
        port map (
            clk => clk_tb,
            rst => rst_tb,
            start => start_tb,
            ended => ended_tb
        );

    clk_process: process
    begin
        while true loop
            clk_tb <= '0';
            wait for clk_period / 2;
            clk_tb <= '1';
            wait for clk_period / 2;
        end loop;
    end process;      
            
    testbench: process
    begin

        wait for 10 ns;

        start_tb <= '1';
        wait for clk_period;
        start_tb <= '0';
        
        wait for 1 sec;

    end process;

end Structural;            
    