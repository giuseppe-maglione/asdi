library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_system_S is
end tb_system_S;

architecture Behavioral of tb_system_S is

    -- dichiarazione del sistema S
    component system_S
        Port (
            clk : in std_logic;
            addr : in std_logic_vector(3 downto 0);
            enable : in std_logic;
            data_out : out std_logic_vector(3 downto 0)
        );
    end component;

    signal clk : std_logic := '0';
    signal addr : std_logic_vector(3 downto 0);
    signal enable : std_logic;
    signal data_out : std_logic_vector(3 downto 0);

    -- periodo di clock
    constant clk_period : time := 10 ns;

begin

    -- instanziazione del sistema S
    uut: system_S
        port map ( clk => clk, addr => addr, enable => enable, data_out => data_out );

    -- generazione del clock
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    process
    begin

        enable <= '0';
        addr <= (others => '0');
        wait for clk_period;

        enable <= '1';
        wait for clk_period;

        for i in 0 to 15 loop
            addr <= std_logic_vector(to_unsigned(i, 4));        -- testa il sistema per gli indirizzi possibili
            wait for clk_period;
        end loop;

        enable <= '0';
        wait for clk_period;

        wait;
    end process;

end Behavioral;
