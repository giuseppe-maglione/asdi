library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testbench_S is
end testbench_S;

architecture Behavioral of testbench_S is

-- segnali per il testbench
signal clk: std_logic := '0';
signal rst: std_logic := '0';
signal start: std_logic := '0';

constant clk_period: time := 10 ns;

begin

    -- instanziazione del sistema
    S: entity work.system_S
        port map ( clk, rst, start );

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
    
    tb: process
      begin
      
        wait for 10*clk_period;
        rst <= '1';
        start <= '0';
        wait for clk_period;
        rst <= '0';
        
        for i in 0 to 10 loop
            wait for 10*clk_period;
            start <= '1';
            wait for clk_period;
            start <= '0';
            wait for 20000 ns;
        end loop;
        
        wait;
      end process;



end Behavioral;
