library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ripple_carry is
    generic (
        N: natural := 8     -- dimensione delle stringhe in ingresso
    );
    port (
        x0: in std_logic_vector(N-1 downto 0);     -- stringa in ingresso
        x1: in std_logic_vector(N-1 downto 0);     -- stringa in ingresso
        carry_in: in std_logic;
        y: out std_logic_vector(N-1 downto 0);        -- stringa in uscita
        carry_out: out std_logic
    );
end ripple_carry;

architecture Structural of ripple_carry is
	
signal temp: std_logic_vector(N-1 downto 0);
	
begin
	
fa0: entity work.full_adder 
    port map( x0 => x0(0), x1 => x1(0), carry_in => carry_in, y => y(0), carry_out => temp(0) );
    
generate_fa: for i in 1 to N-2 generate
    RA: entity work.full_adder 
        port map( x0 => x0(i), x1 => x1(i), carry_in => temp(i-1), y => y(i), carry_out => temp(i) );
end generate;
    
fa_last: entity work.full_adder 
    port map( x0 => x0(N-1), x1 => x1(N-1), carry_in => temp(N-2), y => y(N-1), carry_out => carry_out );
    
	
end Structural;