library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity system_S is
    port (
        clk: in std_logic;
        rst: in std_logic;
        start_sys: in std_logic
    );
end system_S;

architecture Behavioral of system_S is

-- segnali di interconnessione tra componenti
signal serial_data: std_logic;      -- collegamento tra txd e rxd delle due unità
signal rts: std_logic;
signal cts: std_logic;
signal stop: std_logic := '0';

begin

-- istanziazione dell'unità A
uA: entity work.unit_A
    port map ( clk => clk, rst => rst, start => start_sys, txd => serial_data, 
    stop => stop, rts => rts, cts => cts );

-- istanziazione dell'unità B
uB: entity work.unit_B
    port map ( clk => clk, rst => rst, rxd => serial_data, 
    stop => stop, rts => rts, cts => cts );

update: process(clk)
begin
end process;

end Behavioral;
