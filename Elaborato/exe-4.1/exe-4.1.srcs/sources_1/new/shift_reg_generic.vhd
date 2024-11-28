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
        data_in: in std_logic_vector(1 downto 0);       -- dato in ingresso (se shifto di 2 inserisco 2)
        data_out: out std_logic     -- dato in uscita
    );
end shift_reg_generic;

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
                    reg <= data_in(0) & reg(N-1 downto 1);      -- shifta di 1 e inserisci a sinistra   
                elsif shift_num = '1' then
                    reg <= data_in & reg(N-1 downto 2);     -- shifta di 2 e inserisci a sinistra   
                end if;
                
            else        -- shift sinistro
                if shift_num = '0' then
                    reg <= reg(N-2 downto 0) & data_in(0);      -- shifta di 1 e inserisci a destra   
                elsif shift_num = '1' then
                    reg <= reg(N-3 downto 0) & data_in;     -- shifta di 2 e inserisci a destra   
                end if;
                    
            end if;
                
        end if;
            
    end if;
        
end process;

data_out <= reg(0) when shift_dir = '0' else reg(N-1);      -- valutazione dell'uscita

end Behavioral;

architecture Structural of shift_reg_generic is

signal demux_out: std_logic_vector(3 downto 0);     -- segnale di uscita del demux generalizzato
signal mux_out: std_logic_vector(N-1 downto 0);     -- segnale di uscita dei mux (da porre in ingresso ai flip flop)
signal mux_sel: std_logic_vector(1 downto 0) := shift_num & shift_dir;      -- segnale di selezione per i mux
signal mux_in: std_logic_vector(3 downto 0);        -- segnale in ingresso ai mux 
signal ff_out: std_logic_vector(N-1 downto 0);      -- segnale di uscita dei flip flop

begin

    -- demux generalizzato per far passare l'ingresso a sinistra o destra del registro in base alla direzione
    demux_in_sel: entity work.demux_gen
        port map ( x => data_in, sel => shift_dir, y => demux_out );

    -- istanziazione dei mux per scegliere quale dato fornire a ciascun flip flop
    -- la scelta avviene in base alla direzione e il numero di shift
    mux_generate: for i in N-1 downto 0 generate
    
        with i select       -- gestisco gli ingressi al mux in base all'indice del flip flop
            mux_in <=  demux_out(0) & ff_out(1) & demux_out(1) & ff_out(2) when 0,
                       ff_out(i+1) & ff_out(i-1) & ff_out(i+2) & ff_out(i-2) when 1,  
                       ff_out(N-2) & demux_out(2) & ff_out(N-3) & demux_out(3) when N-2,
                       ff_out(N-2) & demux_out(2) & ff_out(N-3) & demux_out(3) when N-1,
                       ff_out(i+1) & ff_out(i-1) & ff_out(i+2) & ff_out(i-2) when others;
        
        ff: entity work.mux_4x1
            port map ( x => mux_in, sel => mux_sel, y => mux_out(i) );
    end generate mux_generate;
    
    -- instanziazione dei flip flop
    ff_generate: for i in N-1 downto 0 generate
        ff: entity work.flipflop_D
            port map ( d => mux_out(i), clk => clk, rst => rst, q => ff_out(i) );
    end generate ff_generate;
    
    -- mux per selezionare quale uscita fornire
    mux_out_sel: entity work.mux_2x1
        port map ( x0 => ff_out(0), x1 => ff_out(N-1), sel => shift_dir, y => data_out );

end Structural;
