library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity unit_B is
        port (
            clk: in std_logic;
            rst: in std_logic := '0';
            rxd_in: in std_logic;
            write: in std_logic := '0';
            addr: in std_logic_vector(2 downto 0);
            data_received: out std_logic
        );
end unit_B;

architecture Behavioral of unit_B is

-- segnali di interconnessione tra componenti
signal txd: std_logic := '1';
--signal rxd: std_logic;					
signal dbin: std_logic_vector (7 downto 0) := (others => '0');
signal dbout: std_logic_vector (7 downto 0);	
signal rda: std_logic;						
signal tbe: std_logic := '1';	
signal rd: std_logic := '0';								
signal wr: std_logic := '0';					
					
begin
         
-- istanziazione della memoria
mem: entity work.generic_mem
    generic map ( 8, 8, 3 )
    port map ( clk => clk, rst => rst, read => '0', write => write, data_in => dbout, addr => addr, data_out => open ); 
    
-- istanziazione dell'uart dell'unità B
uart_B: entity work.Rs232RefComp
    port map ( txd, rxd_in, clk, dbin, dbout, rda, tbe, rd, wr, open, open, open, rst );
      
data_received <= rda;    

end Behavioral;
