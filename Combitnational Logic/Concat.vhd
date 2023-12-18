library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Concat is
    Port ( 
        input_28bits : in STD_LOGIC_VECTOR (27 downto 0);
        input_4bits  : in STD_LOGIC_VECTOR (3 downto 0);
        output_concat : out STD_LOGIC_VECTOR (31 downto 0)
    );
end Concat;

architecture Behavioral of Concat is
begin
    process(input_28bits, input_4bits)
    begin
        output_concat <= input_4bits & input_28bits;
    end process;
end Behavioral;
