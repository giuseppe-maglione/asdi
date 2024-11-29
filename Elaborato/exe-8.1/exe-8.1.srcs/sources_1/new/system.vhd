library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity system is
    port(
        clk: in std_logic;      -- clock
        rst: in std_logic;      -- reset
        start: in std_logic     -- segnale per avviare i nodi        
    );
end system;

architecture Behavioral of system is

constant N: natural := 4;
constant M: natural := 8;

constant L: natural := 2;       -- bit necessari per codificare per gli indirizzi delle memorie

-- segnali scambiati tra i due nodi
signal req: std_logic;
signal ack: std_logic;
signal data: std_logic_vector(7 downto 0);

begin

-- istanziazione del nodo A
nA: entity work.node_A
    port map ( clk => clk, rst => rst, start => start, req => req, ack => ack, data_out => data );
    
-- istanziazione del nodo B
nB: entity work.node_B
    port map ( clk => clk, rst => rst, start => start, req => req, ack => ack, data_in => data );

end Behavioral;
