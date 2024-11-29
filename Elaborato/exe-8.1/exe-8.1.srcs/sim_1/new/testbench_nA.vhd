library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_node_A is
end tb_node_A;

architecture behavior of tb_node_A is

    -- segnali di testbench
    signal clk_tb: std_logic := '0';
    signal rst_tb: std_logic := '0';
    signal start_tb: std_logic := '0';
    signal req_tb: std_logic;
    signal ack_tb: std_logic := '0';
    signal data_out_tb: std_logic_vector(7 downto 0);

    constant clk_period: time := 20 ns;

begin

    -- istanziazione del nodo A
    nA: entity work.node_A
        port map (
            clk => clk_tb,
            rst => rst_tb,
            start => start_tb,
            req => req_tb,
            ack => ack_tb,
            data_out => data_out_tb
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

        wait for clk_period;
        ack_tb <= '1';  -- simula recezione ack dal nodo B
        wait for clk_period;
        ack_tb <= '0';
        wait for clk_period;
        
        wait for 100 ns;

    end process;

end behavior;
