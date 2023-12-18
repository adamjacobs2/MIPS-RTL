library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;


entity mux2to1 is
	generic(
		WIDTH : integer := 32);
	
    port (
        sel    : in  std_logic;
        A    : in  std_logic_vector(WIDTH-1 downto 0);
        B    : in  std_logic_vector(WIDTH-1 downto 0);
        output : out std_logic_vector(WIDTH-1 downto 0)
    );
end mux2to1;

architecture bhv of mux2to1 is

begin
process(A,B,sel)
    begin 
        if (sel = '0') then
            output <= A;
        else
            output <= B;
        end if;
    end process;
end bhv;