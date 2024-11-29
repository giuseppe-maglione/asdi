library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_node_B is
end tb_node_B;

architecture behavior of tb_node_B is

    -- segnali di testbench
    signal clk_tb: std_logic := '0';
    signal rst_tb: std_logic := '0';
    signal start_tb: std_logic := '0';
    signal req_tb: std_logic := '0';
    signal ack_tb: std_logic;
    signal data_in_tb: std_logic_vector(7 downto 0) := (others => '0');

    constant clk_period: time := 20 ns;

begin
    
    -- istanziazione del nodo B
    nB: entity work.node_B
        port map (
            clk => clk_tb,
            rst => rst_tb,
            start => start_tb,
            req => req_tb,
            ack => ack_tb,
            data_in => data_in_tb
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

        wait for 100 ns;
        
        start_tb <= '0';
        wait for clk_period;
        
        start_tb <= '1';
        wait for clk_period;
        start_tb <= '0';

        for i in 0 to 3 loop
            req_tb <= '1';      -- simula recezione req dal nodo A
            data_in_tb <= "10101010";
            wait for clk_period;
            wait until ack_tb = '1';
            req_tb <= '0';
            wait for clk_period;
            wait until ack_tb = '0';
        end loop;

        wait for 100 ns;

    end process;

end behavior;
