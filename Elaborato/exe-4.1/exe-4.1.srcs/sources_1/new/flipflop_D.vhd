library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flipflop_D is
    Port (
            d: in std_logic;        -- dato in ingresso
            clk: in std_logic;
            rst: in std_logic;
            q: out std_logic        
          );
end flipflop_D;

architecture Behavioral of flipflop_D is

begin

process(clk)
begin
    
    if rising_edge(clk) then
        
        if rst = '1' then
            q <= '0';
        else
            q <= d;
        end if;
        
    end if;
    
end process;

end Behavioral;