library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity base_tempi is
    port (
        clk_in: in std_logic;
        rst: in std_logic;
        clk_out: out std_logic
    );
end base_tempi;

architecture Behavioral of base_tempi is

signal count: unsigned(26 downto 0) := (others => '0');
signal clk_out_temp: std_logic := '0';

begin
    process(clk_in, rst)
    begin
        if rst = '1' then
            count <= (others => '0');
            clk_out_temp <= '0';
        elsif rising_edge(clk_in) then
            if count = 99999999 then
                count <= (others => '0');
                clk_out_temp <= not clk_out_temp;
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    clk_out <= clk_out_temp;
end Behavioral;