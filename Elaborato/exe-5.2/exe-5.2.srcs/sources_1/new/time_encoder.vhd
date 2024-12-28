library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity time_encoder is
    port (
        ss: in std_logic_vector(0 to 5);
        mm: in std_logic_vector(0 to 5);
        hh: in std_logic_vector(0 to 4);
        data_out: out std_logic_vector(23 downto 0)
    );
end time_encoder;

architecture Behavioral of time_encoder is

signal ss_u: integer;
signal ss_d: integer;
signal mm_u: integer;
signal mm_d: integer;
signal hh_u: integer;
signal hh_d: integer;

signal ss_tot : std_logic_vector(7 downto 0);
signal mm_tot : std_logic_vector(7 downto 0);
signal hh_tot : std_logic_vector(7 downto 0);
signal data_out_temp : std_logic_vector(23 downto 0);

begin

ss_u <= to_integer(unsigned(ss))mod 10;
ss_d <= to_integer(unsigned(ss)) / 10;

ss_tot(3 downto 0) <= std_logic_vector
(to_unsigned(ss_u, 4));
ss_tot(7 downto 4) <= std_logic_vector
(to_unsigned(ss_d, 4));

mm_u <= to_integer(unsigned(mm)) mod 10;
mm_d <= to_integer(unsigned(mm)) / 10;

mm_tot(3 downto 0) <= std_logic_vector
(to_unsigned(mm_u, 4));
mm_tot(7 downto 4) <= std_logic_vector
(to_unsigned(mm_d, 4));

hh_u <= to_integer(unsigned(hh)) mod 10;
hh_d <= to_integer(unsigned(hh)) / 10;

hh_tot(3 downto 0) <= std_logic_vector
(to_unsigned(hh_u, 4));
hh_tot(7 downto 4) <= std_logic_vector
(to_unsigned(hh_d, 4));

data_out_temp(7 downto 0) <= ss_tot;
data_out_temp(15 downto 8) <= mm_tot;
data_out_temp(23 downto 16) <= hh_tot;
data_out <= data_out_temp;

end Behavioral;
