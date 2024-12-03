library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity unit_A is
        port (
            clk: in std_logic;
            rst: in std_logic := '0';
            wr: in std_logic := '0';
            read: in std_logic := '0';
            addr: in std_logic_vector(2 downto 0);
            data_out: out std_logic;
            transmission_ended: out std_logic
        );
end unit_A;

architecture Behavioral of unit_A is

constant N: natural := 8;
constant M: natural := 8;
constant ADDR_LEN: natural := 3;

-- segnali di interconnessione tra componenti
signal rst_components: std_logic := '0';

signal rom_out: std_logic_vector(M-1 downto 0);

signal shift: std_logic := '0';
signal load: std_logic := '0';
signal sr_in: std_logic_vector((M-1)+2 downto 0);
signal sr_serial: std_logic := '0';
signal sr_out: std_logic_vector((M-1)+2 downto 0);      -- BISOGNA PRENDERE SOLO IL LSB

signal tx: std_logic;  
signal tx_end: std_logic := '0';       -- flag di terminazione invio del frame corrente

begin
         
-- istanziazione della memoria rom
rom: entity work.generic_rom
    generic map ( N, M, ADDR_LEN )
    port map ( clk => clk, rst => rst, read => read, addr => addr, data_out => rom_out ); 
    
-- istanziazione dello shift register per trasferire dati al tx dell'uart
shift_reg: entity work.generic_shiftreg
    generic map ( M+2 )     -- 10 bit: 8 per il dato, 2 per start e stop
    port map ( clk => clk, rst => rst, shift => shift, load => load, data_in => sr_in, serial_in => sr_serial, data_out => sr_out );    

sr_in <= "1" & rom_out & "0";
sr_serial <= '0';
tx <= sr_out(0);
    
-- istanziazione dell'uart dell'unità A (si adotta la convenzione 8N1)
uart_A: entity work.uart_A
    port map ( clk => clk, rst => rst, wr => wr, rst_components => rst_components, load_sr => load, shift => shift, tx_end => tx_end );

data_out <= tx;
transmission_ended <= tx_end;

end Behavioral;
