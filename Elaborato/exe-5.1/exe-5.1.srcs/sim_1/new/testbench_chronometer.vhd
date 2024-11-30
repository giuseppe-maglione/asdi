library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_chronometer is
end tb_chronometer;

architecture Structural of tb_chronometer is

    -- segnali di testbench
    signal clk_tb: std_logic;
    signal start_tb: std_logic := '0';
    signal rst_tb: std_logic := '0';
    
    signal set_tb: std_logic := '0'; 
    signal ss_set_tb: std_logic_vector(5 downto 0) := (others => '0');
    signal mm_set_tb: std_logic_vector(5 downto 0) := (others => '0');
    signal hh_set_tb: std_logic_vector(4 downto 0) := (others => '0');
        
    signal ss_tb: std_logic_vector(5 downto 0);
    signal mm_tb: std_logic_vector(5 downto 0);
    signal hh_tb: std_logic_vector(4 downto 0);
    signal ended_tb: std_logic;

    constant clk_period: time := 10 ns;

begin

    -- istanziazione del sistema S
    chronom: entity work.chronometer
        port map (
            clk => clk_tb,
            start => start_tb,            
            rst => rst_tb,
            set => set_tb,
            ss_set => ss_set_tb,
            mm_set => mm_set_tb,
            hh_set => hh_set_tb,
            mm => mm_tb,
            ss => ss_tb,
            hh => hh_tb,
            ended => ended_tb
        );

    clock: process
    begin
        clk_tb <= '0';
        wait for clk_period/2;
        clk_tb <= '1';
        wait for clk_period/2;
    end process;  
            
    testbench: process
    begin

        wait for 10 ns;
        
        rst_tb <= '1';
        wait for clk_period;
        rst_tb <= '0';
        wait for clk_period;
        
        ss_set_tb <= "001000";
        mm_set_tb <= "111111";
        hh_set_tb <= "11111";  
        set_tb <= '1';
        wait for clk_period;
        set_tb <= '0';
        wait for clk_period;      
                
        start_tb <= '1';
        wait for 1000*clk_period;
        start_tb <= '0';

        wait;

    end process;

end Structural;            
    