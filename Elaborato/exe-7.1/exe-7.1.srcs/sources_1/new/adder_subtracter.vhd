library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_subtracter is
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
end adder_subtracter;

architecture Structural of adder_subtracter is

signal x1_complement: std_logic_vector(N-1 downto 0);       -- complemento della stringa x1

begin

complement: for i in 0 to N-1 generate
    x1_complement(i) <= x1(i) xor carry_in;
end generate;

ra: entity work.ripple_carry
    port map ( x0 => x0, x1 => x1_complement, carry_in => carry_in, carry_out => carry_out, y => y );

end Structural;