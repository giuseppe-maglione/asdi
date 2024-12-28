library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flipflop_t IS
    port (
        clk: in std_logic;
        rst: in std_logic;
        enable: in std_logic;
        rst_counter: in std_logic;
        load: in std_logic;
        load_val: in std_logic;
        counter: out std_logic
    );
end entity flipflop_t;

architecture Behavioral of flipflop_t is

signal curr_counter : std_logic := '0';

begin

process(clk)
begin

    if (falling_edge(clk)) then
    
        if (rst = '1') then
            curr_counter <= '0';
        else
            if (load = '1') then
                curr_counter <= load_val;
            else
                if (rst_counter = '1') then
                    curr_counter <= '0';
                else
                    if (enable = '1') then
                        curr_counter <= not curr_counter;
                    end if;
                end if;
            end if;
        end if;
        
    end if;
        
end process;

counter <= curr_counter;
    
end behavioral;