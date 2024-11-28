library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity demux_gen is
    Port (
            x: in std_logic_vector(1 downto 0);
            sel: in std_logic;
            y: out std_logic_vector(3 downto 0)   
          );
end demux_gen;

architecture Behavioral of demux_gen is

begin

    y <= x & "00" when sel = '0' else x & "00";

end Behavioral;