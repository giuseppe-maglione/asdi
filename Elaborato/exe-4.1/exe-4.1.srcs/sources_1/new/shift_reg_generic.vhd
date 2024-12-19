library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_reg_generic is
    generic ( 
        N: natural := 8     -- numero di elementi nel registro
    );
    port ( 
        clk: in std_logic;      -- clock
        rst: in std_logic;      -- reset
        shift: in std_logic;        -- segnale di abilitazione dello shift
        shift_dir: in std_logic;        -- direzione dello shift (0 -> destro, 1 -> sinistro)
        shift_num: in std_logic;        -- numero di shift da effettuare (0 -> 1 shift, 1 -> 2 shift)        
        data_in: in std_logic;       -- dato in ingresso
        data_out: out std_logic     -- dato in uscita
    );
end shift_reg_generic;

architecture Structural of shift_reg_generic is

signal sel: std_logic_vector(1 downto 0);       -- segnale di selezione
signal ff_out: std_logic_vector(N+3 downto 0);      -- segnale di uscita dei flip flop
signal ff_in: std_logic_vector(N-1 downto 0);      -- segnale di uscita dei flip flop

begin

    -- setup dei segnali per shiftare correttamente anche il primo e ultimo flip flop
    ff_out(0) <= '0';
    ff_out(1) <= data_in;
    ff_out(N+3) <= '0';
    ff_out(N+2) <= data_in;
    sel <= shift_dir & shift_num;
        
    -- istanziazione dei mux per scegliere quale dato fornire a ciascun flip flop
    mux_generate: for i in 0 to N-1 generate
        mux: entity work.mux_4x1
            port map ( data(0) => ff_out(i+3), data(1) => ff_out(i+4), data(2) => ff_out(i+1), 
            data(3) => ff_out(i), sel => sel, y => ff_in(i) );
    end generate mux_generate;
    
    -- instanziazione dei flip flop
    ff_generate: for i in 0 to N-1 generate
        ff: entity work.flipflop_D
            port map ( d => ff_in(i), clk => clk, rst => rst, q => ff_out(i) );
    end generate ff_generate;
    
    -- mux per selezionare quale uscita fornire
    mux_out_sel: entity work.mux_2x1
        port map ( x0 => ff_out(N-1), x1 => ff_out(2), sel => shift_dir, y => data_out );

end Structural;

architecture Behavioral of shift_reg_generic is

signal reg: std_logic_vector(N-1 downto 0) := (others => '0');      -- registro

begin

process(clk)
begin
    
    if rising_edge(clk) then
        
        if rst = '1' then       -- reset sincrono
            reg <= (others => '0');
                
        elsif shift = '1' then      -- shift abilitato
            
            if shift_dir = '0' then     -- shift destro
                if shift_num = '0' then
                    reg <= data_in & reg(N-1 downto 1);      -- shifta di 1 e inserisci a sinistra   
                elsif shift_num = '1' then
                    reg <= '0' & data_in & reg(N-1 downto 2);     -- shifta di 2 e inserisci a sinistra   
                end if;
                
            else        -- shift sinistro
                if shift_num = '0' then
                    reg <= reg(N-2 downto 0) & data_in;      -- shifta di 1 e inserisci a destra   
                elsif shift_num = '1' then
                    reg <= reg(N-3 downto 0) & data_in & '0';     -- shifta di 2 e inserisci a destra   
                end if;
                    
            end if;
                
        end if;
            
    end if;
        
end process;

data_out <= reg(0) when shift_dir = '0' else reg(N-1);      -- valutazione dell'uscita

end Behavioral;
