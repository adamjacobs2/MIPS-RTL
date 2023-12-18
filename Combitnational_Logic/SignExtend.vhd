library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SignExtend is
    Port ( input_16bits : in STD_LOGIC_VECTOR (15 downto 0);
           output_32bits : out STD_LOGIC_VECTOR (31 downto 0);
           isSigned : in std_logic);
end SignExtend;

architecture Behavioral of SignExtend is
begin
    process(input_16bits)
    begin
        if (isSigned = '0') then
            -- Positive number, sign extend with '0'
            output_32bits <= (15 downto 0 => '0') & input_16bits;
        else
            -- Negative number, sign extend with '1'
            output_32bits <= (15 downto 0 => '1') & input_16bits;
        end if;
    end process;
end Behavioral;