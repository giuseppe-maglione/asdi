library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_mod60 is
    port (
        clk: in std_logic;
        rst: in std_logic;
        enable: in std_logic;
        load: in std_logic;
        load_val: in std_logic_vector(0 to 5);
        count: out std_logic_vector(0 to 5);
        enable_next: out std_logic
    );
end counter_mod60;

architecture Behavioral of counter_mod60 is

signal counter : std_logic_vector(5 downto 0) := (others => '0');
signal reset : std_logic := '0';

signal rst_ff: std_logic := '0';

signal enable_ff0: std_logic := '0';
signal enable_ff1: std_logic := '0';
signal enable_ff2: std_logic := '0';
signal enable_ff3: std_logic := '0';
signal enable_ff4: std_logic := '0';
signal enable_ff5: std_logic := '0';

begin

    reset <= counter(5) and counter(4) and counter(3) and not counter(2) and counter(1) and counter(0); -- codifica binaria: 111011
    
    rst_ff <= reset and enable;
    
    enable_ff0 <= enable;
    enable_ff1 <= counter(0) and enable;
    enable_ff2 <= counter(0) and counter(1) and enable;
    enable_ff3 <= counter(0) and counter(1) and counter(2) and enable;
    enable_ff4 <= counter(0) and counter(1) and counter(2) and counter(3) and enable;
    enable_ff5 <= counter(0) and counter(1) and counter(2) and counter(3) and counter(4) and enable;

    ff0: entity work.flipflop_t 
    port map(
        clk => clk,
        rst => rst,
        enable => enable_ff0,
        rst_counter => rst_ff,
        load => load,
        load_val => load_val(5),
        counter => counter(0)
    );

    ff1: entity work.flipflop_t 
    port map(
        clk => clk,
        rst => rst,
        enable => enable_ff1,
        rst_counter => rst_ff,
        load => load,
        load_val => load_val(4),
        counter => counter(1)
    );

    ff2: entity work.flipflop_t 
    port map(
        clk => clk,
        rst => rst,
        enable => enable_ff2,
        rst_counter => rst_ff,
        load => load,
        load_val => load_val(3),
        counter => counter(2)
    );

    ff3: entity work.flipflop_t 
    port map(
        clk => clk,
        rst => rst,
        enable => enable_ff3,
        rst_counter => rst_ff,
        load => load,
        load_val => load_val(2),
        counter => counter(3)
    );

    ff4: entity work.flipflop_t 
    port map(
        clk => clk,
        rst => rst,
        enable => enable_ff4,
        rst_counter => rst_ff,
        load => load,
        load_val => load_val(1),
        counter => counter(4)
    );
    
    ff5: entity work.flipflop_t 
    port map(
        clk => clk,
        rst => rst,
        enable => enable_ff5,
        rst_counter => rst_ff,
        load => load,
        load_val => load_val(0),
        counter => counter(5)
    );

    count <= counter;
    enable_next <= reset;

end Behavioral;
