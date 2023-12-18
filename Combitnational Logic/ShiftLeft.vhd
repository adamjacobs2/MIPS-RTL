library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ShiftLeft is
    Port ( 
        input_32bits : in STD_LOGIC_VECTOR (31 downto 0);
        output_shifted : out STD_LOGIC_VECTOR (31 downto 0)
    );
end ShiftLeft;

architecture Behavioral of ShiftLeft is
begin
    process(input_32bits)
    begin
        output_shifted <= (others => '0');

        output_shifted(31 downto 2) <= input_32bits(29 downto 0);
    end process;
end Behavioral;