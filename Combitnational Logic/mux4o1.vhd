library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;


entity mux4to1 is
	generic(
		WIDTH : integer := 32);
    port (
        sel    : in  std_logic_vector(1 downto 0);
        A, B, C, D : in  std_logic_vector(WIDTH-1 downto 0);
        output : out std_logic_vector(WIDTH-1 downto 0)
    );
end mux4to1;

architecture bhv of mux4to1 is

begin
process(A, B, C, D, sel)
    begin 
        if (sel = "00") then
            output <= A;
        elsif (sel = "01") then
            output <= B;
        elsif (sel = "10") then
            output <= C;
        elsif (sel = "11") then
            output <= D;
        end if;
    end process;
end bhv;