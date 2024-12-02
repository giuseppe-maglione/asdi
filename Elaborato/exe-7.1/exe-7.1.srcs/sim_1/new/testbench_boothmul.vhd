library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_booth_mutliplier is
end tb_booth_mutliplier;

architecture Behavioral of tb_booth_mutliplier is

    -- segnali per il testbench
    constant N: natural := 8;
    signal clk: std_logic;
    signal rst: std_logic := '0';
    signal start: std_logic := '0';
    signal x0: std_logic_vector(N-1 downto 0);
    signal x1: std_logic_vector(N-1 downto 0);
    signal result: std_logic_vector(2*N downto 0);
    signal ended: std_logic := '0';  
    
    constant clk_period: time := 10 ns;

begin

    -- instanziazione del moltiplicatore di booth
    booth_mul: entity work.booth_multiplier_v2
        generic map ( 8 )
        port map ( clk => clk, rst => rst, start => start, x0 => x0, x1 => x1, result => result, ended => ended );

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
        
        rst <= '1';
        wait for clk_period;
        rst <= '0';
        wait for clk_period;
        
        x0 <= "00000010";
        x1 <= "00000010";
        wait for clk_period;
        
        start <= '1';
        wait for clk_period;
        start <= '0';
        wait for 10*clk_period;

        wait;

    end process;

end Behavioral;