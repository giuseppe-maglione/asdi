library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity system_S is
    Port ( 
            clk: in std_logic;
            rst: in std_logic;
            addr: in std_logic_vector(3 downto 0);      -- indirizzo da cui leggere nella rom
            enable: in std_logic;       -- segnale di abilitazione
            data_out: out std_logic_vector(3 downto 0)      -- uscita elaborata dalla macchina M
    );
end system_S;

architecture Behavioral of system_S is

signal rom_data: std_logic_vector(7 downto 0);      -- segnale di appoggio per il dato prelevato dalla rom

begin

-- istanziazione rom
rom_16x8: entity work.generic_rom
    generic map ( 16, 8 , 4)
    port map ( clk => clk, rst => rst, read => enable, addr => addr, data_out => rom_data );
    
-- istanziazione machine M
machine_M: entity work.machine_M
    port map ( data_in => rom_data, data_out => data_out );

end Behavioral;