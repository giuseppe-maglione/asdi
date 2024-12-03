library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity unit_B is
        port (
            clk: in std_logic;
            rst: in std_logic := '0';
            write: in std_logic := '0';
            addr: in std_logic_vector(2 downto 0);
            data_in: in std_logic;
            reception_ended: out std_logic
        );
end unit_B;

architecture Behavioral of unit_B is

constant N: natural := 8;
constant M: natural := 8;
constant ADDR_LEN: natural := 3;

-- segnali di interconnessione tra componenti
signal rst_components: std_logic := '0';

signal write_mem: std_logic := '0';

signal shift: std_logic := '0';
signal load: std_logic := '0';
signal sr_in: std_logic_vector(M-1 downto 0);
signal sr_serial: std_logic := '0';
signal sr_out: std_logic_vector(M-1 downto 0);      -- BISOGNA PRENDERE SOLO IL LSB

signal rx: std_logic;  
signal rx_end: std_logic := '0';       -- flag di terminazione recezione del frame corrente

begin
         
-- istanziazione della memoria
mem: entity work.generic_mem
    generic map ( N, M, ADDR_LEN )
    port map ( clk => clk, rst => rst, read => '0', write => write, data_in => sr_out, addr => addr, data_out => open ); 

sr_in <= (others => '0');
rx <= data_in;
    
-- istanziazione dello shift register per trasferire dati da rx dell'uart
shift_reg: entity work.generic_shiftreg
    generic map ( M )
    port map ( clk => clk, rst => rst, shift => shift, load => load, data_in => sr_in, serial_in => rx, data_out => sr_out );    
    
-- istanziazione dell'uart dell'unità B (si adotta la convenzione 8N1)
uart_B: entity work.uart_B
    port map ( clk => clk, rst => rst, rx => data_in, rst_components => rst_components, write_mem => write_mem, shift => shift, rx_end => rx_end );

reception_ended <= rx_end;

end Behavioral;
