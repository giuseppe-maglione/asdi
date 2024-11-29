library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_chronometer is
end tb_chronometer;

architecture Behavioral of tb_chronometer is

    -- segnali di testbench
    signal tmp_tb: std_logic := '0';
    signal rst_tb: std_logic := '0';
    signal start_tb: std_logic := '0';
    
    signal set_tb: std_logic := '0'; 
    signal set_hh_tb: std_logic_vector(4 downto 0);
    signal set_mm_tb: std_logic_vector(5 downto 0);
    signal set_ss_tb: std_logic_vector(5 downto 0);
        
    signal hh_tb: std_logic_vector(4 downto 0);
    signal mm_tb: std_logic_vector(5 downto 0);
    signal ss_tb: std_logic_vector(5 downto 0);
    signal ended_tb: std_logic := '0';

    constant tmp_period: time := 20 ns;

begin

    -- istanziazione del sistema S
    chronom: entity work.chronometer
        port map (
            tmp => tmp_tb,
            rst => rst_tb,
            start => start_tb,
            set => set_tb,
            set_hh => set_hh_tb,
            set_mm => set_mm_tb,
            set_ss => set_ss_tb,
            hh => hh_tb,
            mm => mm_tb,
            ss => ss_tb,
            ended => ended_tb
        );

    tmp_process: process
    begin
        while true loop
            tmp_tb <= '0';
            wait for tmp_period / 2;
            tmp_tb <= '1';
            wait for tmp_period / 2;
        end loop;
    end process;      
            
    testbench: process
    begin

        wait for 100 ns;
        
        start_tb <= '1';
        wait for 100*tmp_period;
        start_tb <= '0';
        
        wait for 100 ns;

    end process;

end Behavioral;            
    