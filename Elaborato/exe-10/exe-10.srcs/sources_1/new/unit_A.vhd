library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity unit_A is
        port (
            clk: in std_logic;
            rst: in std_logic := '0';
            txd_out: out std_logic := '1';
            read: in std_logic := '0';
            addr: in std_logic_vector(2 downto 0);
            start_transmission: in std_logic := '0';
            data_transferred: out std_logic
        );
end unit_A;

architecture Behavioral of unit_A is

-- segnali di interconnessione tra componenti
signal txd: std_logic := '1';
signal rxd: std_logic := '1';					
signal dbin: std_logic_vector (7 downto 0);
signal dbout: std_logic_vector (7 downto 0);	
signal rda: std_logic;						
signal tbe: std_logic;				
signal rd: std_logic := '1';					
					
begin
         
-- istanziazione della rom
rom: entity work.generic_rom
    generic map ( 8, 8, 3 )
    port map ( clk => clk, rst => rst, read => read, addr => addr, data_out => dbin ); 
    
-- istanziazione dell'uart dell'unità B
uart_A: entity work.Rs232RefComp
    port map ( txd, rxd, clk, dbin, dbout, rda, tbe, rd, start_transmission, open, open, open, rst );
    
txd_out <= txd;    
data_transferred <= tbe;    

end Behavioral;
