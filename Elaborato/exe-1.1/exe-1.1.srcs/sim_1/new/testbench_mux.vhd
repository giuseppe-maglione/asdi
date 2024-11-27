library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_mux_16x1 is
end tb_mux_16x1;

architecture behavior of tb_mux_16x1 is
    
    -- dichirazione mux
    component mux_16x1 is
        Port (
            data : in std_logic_vector(15 downto 0);  -- segnali in ingresso  
            sel  : in std_logic_vector(3 downto 0);   -- selezione
            y    : out std_logic                      -- segnale di uscita             
        );
    end component;

    signal data : std_logic_vector(15 downto 0);
    signal sel  : std_logic_vector(3 downto 0);
    signal y    : std_logic;

begin

    -- istanziazione mux
    uut: mux_16x1 
        port map ( data => data, sel  => sel, y    => y );

    process
    begin
        -- test con selezione 0000
        data <= "0000000000000001";
        sel  <= "0000";
        wait for 10 ns;

        -- test con selezione 0001
        data <= "0000000000000010";
        sel  <= "0001";         
        wait for 10 ns;

        -- test con selezione 0010
        data <= "0000000000000100"; 
        sel  <= "0010";             
        wait for 10 ns;

        -- test con selezione 0011
        data <= "0000000000001000"; 
        sel  <= "0011";       
        wait for 10 ns;

        -- test con selezione 0100
        data <= "0000000000010000";  
        sel  <= "0100";    
        wait for 10 ns;

        -- test con selezione 0101
        data <= "0000000000100000"; 
        sel  <= "0101";         
        wait for 10 ns;

        -- test con selezione 0110
        data <= "0000000001000000";  
        sel  <= "0110";      
        wait for 10 ns;

        -- test con selezione 0111
        data <= "0000000010000000";  
        sel  <= "0111";        
        wait for 10 ns;

        -- test con selezione 1000
        data <= "0000000100000000";  
        sel  <= "1000";            
        wait for 10 ns;

        -- test con selezione 1001
        data <= "0000001000000000";  
        sel  <= "1001";             
        wait for 10 ns;

        -- test con selezione 1010
        data <= "0000010000000000";  
        sel  <= "1010";          
        wait for 10 ns;

        -- test con selezione 1011
        data <= "0000100000000000";
        sel  <= "1011";          
        wait for 10 ns;

        -- test con selezione 1100
        data <= "0001000000000000";
        sel  <= "1100";        
        wait for 10 ns;

        -- test con selezione 1101
        data <= "0010000000000000"; 
        sel  <= "1101";           
        wait for 10 ns;

        -- test con selezione 1110
        data <= "0100000000000000"; 
        sel  <= "1110";          
        wait for 10 ns;

        -- test con selezione 1111
        data <= "1000000000000000"; 
        sel  <= "1111";        
        wait for 10 ns;

        wait;
    end process;

end behavior;
