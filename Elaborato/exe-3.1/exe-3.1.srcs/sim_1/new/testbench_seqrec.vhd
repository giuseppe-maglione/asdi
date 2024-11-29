library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_sequence_rec is
end tb_sequence_rec;

architecture Behavioral of tb_sequence_rec is

    -- segnali per il testbench
    signal tmp: std_logic := '0'; 
    signal data_in: std_logic := '0';
    signal mode: std_logic := '0'; 
    signal data_out: std_logic;

    constant clk_period : time := 20 ns;

begin

    -- instanziazione del riconoscitore di sequenza
    seq_rec: entity work.sequence_rec
        port map(
            tmp => tmp,
            data_in => data_in,
            mode => mode,
            data_out => data_out
        );

    -- generazione del clock
    clk_process: process
    begin
        while true loop
            tmp <= '0';
            wait for clk_period / 2;
            tmp <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    testbench: process
    begin
    
        wait for 100 ns;
    
        -- test sequenze non sovrapposte
        mode <= '0';
        wait for clk_period;

        data_in <= '1'; wait for clk_period;
        data_in <= '0'; wait for clk_period;
        data_in <= '1'; wait for clk_period;

        data_in <= '1'; wait for clk_period;
        data_in <= '0'; wait for clk_period;

        -- Test sequenze parzialmente sovrapposte
        mode <= '1';
        wait for clk_period;

        data_in <= '1'; wait for clk_period;
        data_in <= '0'; wait for clk_period;
        data_in <= '1'; wait for clk_period;

        data_in <= '0'; wait for clk_period;
        data_in <= '1'; wait for clk_period;

        wait for 100 ns;
        
    end process;

end Behavioral;