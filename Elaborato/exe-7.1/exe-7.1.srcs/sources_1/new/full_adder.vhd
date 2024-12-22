library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is 
	port(
        x0: in std_logic; 
        x1: in std_logic;
        carry_in: in std_logic;
        carry_out: out std_logic;
        y: out std_logic
	);
end full_adder;

architecture Behavioral of full_adder is

begin
	
y <= x0 xor x1 xor carry_in;
carry_out <= (x0 and x1) or (carry_in and (x0 xor x1));
	
end Behavioral;