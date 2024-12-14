library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity unit_B is
        port (
            clk: in std_logic;
            rst: in std_logic := '0';
            rxd: in std_logic
        );
end unit_B;

architecture Behavioral of unit_B is

-- stati per l'automa dell'unità di controllo
type state is ( wait_reception, write_mem, end_reception, incr );
signal curr_state: state := wait_reception;

-- segnali di interconnessione tra componenti
signal rda: std_logic;	
signal rd: std_logic;					
signal uart_rst: std_logic := '0';

signal count: std_logic;
signal counter: std_logic_vector(2 downto 0);

signal mem_in: std_logic_vector(7 downto 0);
signal write: std_logic;
						
begin

-- istanziazione del contatore
cnt: entity work.generic_counter
    generic map ( 8, 3 )
    port map ( clk, rst, count, counter, open );
         
-- istanziazione della memoria
mem: entity work.generic_mem
    generic map ( 8, 8, 3 )
    port map ( clk, rst, read => '0', write => write, data_in => mem_in, addr => counter, data_out => open ); 
    
-- istanziazione dell'uart dell'unità B
uart_B: entity work.UARTcomponent
    port map ( rxd => rxd, clk => clk, dbin => (others => '0'), dbout => mem_in, rda => rda, rd => '0', wr => '0', rst => uart_rst );
    
-- unità di controllo
cu_B: process(clk)
begin

    if rising_edge(clk) then
    
        if rst = '1' then
            curr_state <= wait_reception;
        end if; 
        
        case curr_state is 
            
            when wait_reception =>
                uart_rst <= '0';
                rd <= '0';
                count <= '0';
                if rda = '1' then
                    curr_state <= write_mem;
                else
                    curr_state <= wait_reception;
                end if;
                    
            when write_mem =>
                write <= '1';
                curr_state <= end_reception;    
                    
            when end_reception =>
                uart_rst <= '1';
                rd <= '1';
                write <= '0';
                curr_state <= incr;
                
            when incr =>
                rd <= '0';
                count <= '1';
                curr_state <= wait_reception;    
    
        end case;
    
    end if;

end process;    
      
end Behavioral;
