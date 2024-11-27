library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_interconn_net_16x4 is
end tb_interconn_net_16x4;

architecture behavior of tb_interconn_net_16x4 is

    -- dichiarazione rete di interconnessione
    component interconn_net_16x4 is
        Port (
            data : in std_logic_vector(15 downto 0);  -- segnali in ingresso  
            sel  : in std_logic_vector(5 downto 0);   -- selezione
            y    : out std_logic_vector(3 downto 0)   -- segnali di uscita             
        );
    end component;

    signal data : std_logic_vector(15 downto 0);
    signal sel  : std_logic_vector(5 downto 0);
    signal y    : std_logic_vector(3 downto 0);

begin

    -- istanziazione rete di interconnessione
    uut: interconn_net_16x4 port map (
        data => data,
        sel  => sel,
        y    => y
    );

    process
    begin
        
        wait for 100ns;
        data <= (others => '0');
        sel <= (others => '0');
        
        wait for 10ns;
        data(0) <= '1';
        
        wait for 10ns;
        sel <= "00000";
        wait for 10ns;
        sel <= "00001";
        wait for 10ns;
        sel <= "00011";
        
        wait for 10ns;
        data(3) <= '1';
        
        wait for 10ns;
        sel <= "00000";
        wait for 10ns;
        sel <= "00001";
        wait for 10ns;
        sel <= "00011";    

        wait;
    end process;

end behavior;
