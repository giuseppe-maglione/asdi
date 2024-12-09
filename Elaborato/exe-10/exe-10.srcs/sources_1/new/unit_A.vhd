library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity unit_A is
        port (
            clk: in std_logic;
            rst: in std_logic := '0';
            start: in std_logic;
            txd: out std_logic
        );
end unit_A;

architecture Behavioral of unit_A is

-- stati per l'automa dell'unità di controllo
type state is (idle, read_rom, send_data, wait_transmission, incr);
signal curr_state: state := idle;

-- segnali di interconnessione tra componenti
signal tbe: std_logic := '1';				
signal wr: std_logic;	

signal count: std_logic;
signal counter: std_logic_vector(2 downto 0);

signal rom_out: std_logic_vector(7 downto 0);
signal read: std_logic;		

begin

-- istanziazione del contatore
cnt: entity work.generic_counter
    generic map ( 8, 3 )
    port map ( clk, rst, count, counter, open );
         
-- istanziazione della rom
rom: entity work.generic_rom
    generic map ( 8, 8, 3 )
    port map ( clk, rst, read, counter, rom_out ); 
    
-- istanziazione dell'uart dell'unità A
uart_A: entity work.Rs232RefComp
    port map ( txd => txd, rxd => '1', clk => clk, dbin => rom_out, tbe => tbe, rd => '0', wr => wr, rst => rst );
    
-- unità di controllo
cu_A: process(clk)
begin 

    if rising_edge(clk) then
    
        if rst = '1' then
            curr_state <= idle;
        end if; 
    
        case curr_state is
            
            when idle =>
                wr <= '0';
                count <= '0';
                read <= '0';
                if start = '1' then
                    curr_state <= read_rom;    
                else
                    curr_state <= idle;    
                end if;
            
            when read_rom =>
                read <= '1';
                curr_state <= send_data;
                    
            when send_data =>
                read <= '0';
                wr <= '1';
                curr_state <= incr;
             
            when incr =>
                wr <= '0';
                count <= '1';
                if counter = "111" then
                    curr_state <= idle;
                else     
                    curr_state <= wait_transmission;
                end if;               
                    
            when wait_transmission =>
                count <= '0';
                if tbe = '1' then
                    curr_state <= read_rom;
                else
                    curr_state <= wait_transmission;
                end if;                        
    
        end case;
    
    end if;

end process;  
    
end Behavioral;
