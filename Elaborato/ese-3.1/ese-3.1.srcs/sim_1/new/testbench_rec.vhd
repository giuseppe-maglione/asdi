library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_sequence_rec is
end tb_sequence_rec;

architecture Behavioral of tb_sequence_rec is

    -- dichiarazione del riconoscitore di sequenza
    component sequence_rec
        port(
            tmp: in std_logic;
            data_in: in std_logic;
            mode: in std_logic;
            data_out: out std_logic
        );
    end component;

    signal tmp: std_logic := '0'; 
    signal data_in: std_logic := '0';
    signal mode: std_logic := '0'; 
    signal data_out: std_logic;

    -- periodo di clock
    constant clk_period : time := 20 ns;

begin

    -- instanziazione del riconoscitore di sequenza
    uut: sequence_rec
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

    process
    begin
    
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

        wait;
    end process;

end Behavioral;
