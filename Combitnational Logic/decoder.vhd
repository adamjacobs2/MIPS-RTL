LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY decoder IS
    PORT (   Input    : IN     STD_LOGIC_VECTOR(3 DOWNTO 0) ;
            Output     : OUT     STD_LOGIC_VECTOR(6 DOWNTO 0) ) ;
END decoder ;

ARCHITECTURE Behavior OF decoder IS
    SIGNAL result : STD_LOGIC_VECTOR(6 DOWNTO 0) ;
BEGIN
    WITH Input SELECT
        result <=     "0111111" WHEN "0000",--0
                        "0000110" WHEN "0001",--1
                        "1011011" WHEN "0010",--2
                        "1001111" WHEN "0011",--3
                        "1100110" WHEN "0100",--4
                        "1101101" WHEN "0101",--5
                        "1111101" WHEN "0110",--6
                        "0000111" WHEN "0111",--7
                        "1111111" WHEN "1000",--8
                        "1100111" WHEN "1001",--9
                        "1110111" WHEN "1010",
                        "1111100" WHEN "1011",
                        "0111001" WHEN "1100",
                        "1011110" WHEN "1101",
                        "1111001" WHEN "1110",
                        "1110001" WHEN "1111",
                        "0000000" WHEN OTHERS ;
        Output<= not result;
END Behavior ;