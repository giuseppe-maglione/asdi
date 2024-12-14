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
type state is ( idle, send_data, wait_transmission, incr );
signal curr_state: state := idle;

-- segnali di interconnessione tra componenti
signal tbe: std_logic;
signal wr: std_logic := '0';
signal uart_rst: std_logic := '0';

signal count: std_logic;
signal counter: std_logic_vector(2 downto 0);

signal rom_out: std_logic_vector(7 downto 0);

begin

-- istanziazione del contatore
cnt: entity work.generic_counter
    generic map ( 8, 3 )
    port map ( clk, rst, count, counter, open );
         
-- istanziazione della rom
rom: entity work.generic_rom
    generic map ( 8, 8, 3 )
    port map ( clk, rst, '1', counter, rom_out ); 
    
-- istanziazione dell'uart dell'unità A
uart_A: entity work.UARTcomponent
    port map ( txd => txd, rxd => '1', clk => clk, dbin => rom_out, tbe => tbe, rd => '1', wr => wr, rst => uart_rst );
    
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
                uart_rst <= '1';
                if start = '1' then
                    uart_rst <= '0';
                    curr_state <= send_data;    
                else
                    curr_state <= idle;    
                end if;
                    
            when send_data =>
                wr <= '1';
                if tbe = '0' then
                    curr_state <= wait_transmission;
                else
                    curr_state <= send_data;
                end if;       
                    
            when wait_transmission =>
                wr <= '0';
                if tbe = '1' then
                    curr_state <= incr;
                else
                    curr_state <= wait_transmission;
                end if;       
                
            when incr =>
                count <= '1';  
                curr_state <= idle;                    
    
        end case;
    
    end if;

end process;  
    
end Behavioral;
