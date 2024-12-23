library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity unit_B is
    port (
        clk: in std_logic;
        rst: in std_logic;
        rxd: in std_logic;
        stop: in std_logic := '0';
        rts: in std_logic := '0';
        cts: out std_logic := '0'
    );
end unit_B;

architecture Behavioral of unit_B is

-- segnali di interconnessione tra componenti
signal txd: std_logic := '0';
signal rda: std_logic := '0';
signal rd: std_logic := '0';
signal dbin: std_logic_vector(7 downto 0);
signal dbout: std_logic_vector(7 downto 0);
signal tbe: std_logic := '0';
signal p_err: std_logic := '0';
signal f_err: std_logic := '0';
signal o_err: std_logic := '0';
signal temp5: std_logic_vector(7 downto 0);
	
signal counter: std_logic_vector(2 downto 0);
signal count: std_logic := '0';
	
signal write_mem: std_logic := '0';
signal out_mem: std_logic_vector(7 downto 0);
signal in_mem: std_logic_vector(7 downto 0);


-- stati dell'automa della control unit
type state is (idle, reception, write);
signal curr_state: state := idle;
	
begin

-- istanziazione dell'uart
uart_B: entity work.Rs232RefComp
    port map ( txd => txd, rxd => rxd, clk => clk, dbin => dbin, dbout => dbout, rda => rda, tbe => tbe, rd => rd, 
    wr => '0', pe => p_err, fe => f_err, oe => o_err, rst => rst ); 

-- istanziazione del contatore
cnt: entity work.generic_counter
    generic map ( 8, 3 )
    port map ( clk => clk, rst => rst, count => count, counter => counter, counter_end => open );
   
-- istanziazione della memoria 
mem: entity work.generic_mem
    generic map ( 8, 8, 3 )
    port map ( clk => clk, rst => rst, read => '0', write => write_mem, addr => counter, data_in => in_mem, data_out => out_mem );       

cu_B: process(clk)
begin

    if (rising_edge(clk) and clk = '1') then
    
        if rst = '1' then
            curr_state <= idle;
        end if;
    
        case curr_state is
        
            when idle =>
                count <= '0';
                write_mem <= '0';
                if rts = '1' then
                    cts <= '1';
                    rd <= '1';
                    curr_state <= reception;
                else
                    rd <= '0';
                    curr_state <= idle;    
                end if;
                
            when reception =>
                cts <= '0';
                if stop = '1' then
                    curr_state <= write;
                else
                    curr_state <= reception;    
                end if;     
                
            when write =>
                rd <= '0';
                in_mem <= dbout;
                if rda = '1' then
                    write_mem <= '1';
                    count <= '1';
                    curr_state <= idle;
                else
                    curr_state <= write;    
                end if;
                
            when others =>
                curr_state <= idle;        
        
        end case;
    
    end if;

end process;

end Behavioral;
