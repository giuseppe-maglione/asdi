library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity unit_A is
    port (
        clk: in std_logic;
        rst: in std_logic;
        start: in std_logic;
        txd: out std_logic;
        stop: out std_logic := '0';
        rts: out std_logic := '0';
        cts: in std_logic := '0'
    );
end unit_A;

architecture Behavioral of unit_A is

-- segnali di interconnessione tra componenti
signal rxd: std_logic := '0';
signal tbe: std_logic := '1';
signal wr: std_logic := '0';
signal dbin: std_logic_vector(7 downto 0);
signal dbout: std_logic_vector(7 downto 0);
signal rda: std_logic := '0';
signal p_err: std_logic := '0';
signal f_err: std_logic := '0';
signal o_err: std_logic := '0';

signal counter: std_logic_vector(2 downto 0);
signal count: std_logic := '0';

signal read_rom: std_logic := '0';
signal out_rom: std_logic_vector(7 downto 0);

-- stati dell'automa della control unit
type state is (idle, preparation, transmission);
signal curr_state: state := idle;

begin

-- istanziazione dell'uart
uart_A: entity work.Rs232RefComp
    port map ( txd => txd, rxd => rxd, clk => clk, dbin => dbin, dbout => dbout, rda => rda, tbe => tbe, rd => '0', 
    wr => wr, pe => p_err, fe => f_err, oe => o_err, rst => rst );

-- istanziazione del contatore
cnt: entity work.generic_counter
    generic map ( 8, 3 )
    port map ( clk => clk, rst => rst, count => count, counter => counter, counter_end => open );

-- istanziazione della rom 
rom: entity work.generic_rom
    generic map ( 8, 8, 3 )
    port map ( clk => clk, rst => rst, read => '1', addr => counter, data_out => out_rom );      

cu_A: process(clk)
begin

    if (rising_edge(clk) and clk = '1') then
    
        if rst = '1' then
            curr_state <= idle;
        end if;
    
        case curr_state is
        
            when idle =>
                wr <= '0';
                if start = '1' then
                    count <= '1';
                    read_rom <= '1';
                    curr_state <= preparation;
                else
                    curr_state <= idle;    
                end if;
                
            when preparation =>
                if read_rom = '1' then
                    dbin <= out_rom;
                    count <= '0';
                    read_rom <= '0';
                end if;  
                rts <= '1';
                if cts = '1' then
                    rts <= '0';
                    wr <= '1';
                    curr_state <= transmission;
                else
                    curr_state <= preparation;
                end if;     
                
            when transmission =>
                if wr = '1' then
                    wr <= '0';
                end if;
                
                if rda = '1' then
                    stop <= '1';
                    curr_state <= idle;
                else
                    curr_state <= transmission;
                end if;   
        
            when others =>
                curr_state <= idle;                  
        
        end case;
    
    end if;

end process;

end Behavioral;
