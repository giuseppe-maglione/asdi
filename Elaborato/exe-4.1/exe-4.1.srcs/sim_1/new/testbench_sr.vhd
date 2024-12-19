library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_shift_reg_generic is
end tb_shift_reg_generic;

architecture Behavioral of tb_shift_reg_generic is

    -- dichiarazione dello shift register
    component shift_reg_generic
        generic (
            N: natural := 8
        );
        port (
            clk: in std_logic;
            rst: in std_logic;
            shift: in std_logic;
            shift_dir: in std_logic;
            shift_num: in std_logic;
            data_in: in std_logic;
            data_out: out std_logic
        );
    end component;

    constant N: natural := 8;
    signal clk: std_logic := '0';      
    signal rst: std_logic := '0';     
    signal shift: std_logic := '0';     
    signal shift_dir: std_logic := '0';
    signal shift_num: std_logic := '0';
    signal data_in: std_logic:= '0';
    signal data_out: std_logic;    

begin

    -- instanziazione dello shift register
    uut: shift_reg_generic
        generic map (
            N => N
        )
        port map (
            clk => clk,
            rst => rst,
            shift => shift,
            shift_dir => shift_dir,
            shift_num => shift_num,
            data_in => data_in,
            data_out => data_out
        );

    -- generazione del clock
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

    process
    begin

        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        shift <= '1';
        shift_dir <= '0';  -- shift destro
        shift_num <= '0';  -- shift di 1        
        data_in <= '1';
        wait for 10 ns;
        shift <= '0';
        wait for 20 ns; 

        shift <= '1';
        shift_num <= '1';  -- shift di 2
        data_in <= '0';
        wait for 10 ns;
        shift <= '0';
        wait for 20 ns;

        shift <= '1';
        shift_dir <= '1';  -- shift sinistro
        shift_num <= '0';  -- shift di 1
        data_in <= '1';
        wait for 10 ns;
        shift <= '0';
        wait for 20 ns;

        shift <= '1';
        shift_num <= '1';  -- shift di 2
        data_in <= '0';
        wait for 10 ns;
        shift <= '0';
        wait for 20 ns;

        wait;
    end process;

end Behavioral;
