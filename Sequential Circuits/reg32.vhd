library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;


entity reg32 is
    port (
        clock : in std_logic;
        reset : in std_logic;
        en : in std_logic;
        input : in std_logic_vector(31 downto 0);
        output : out std_logic_vector(31 downto 0)
    );
end reg32;

architecture bhv of reg32 is

begin

process(clock, reset, en)
begin
    if reset = '1' then 
        output <= (others=>'0');
    elsif clock'event AND clock = '1' AND en = '1' then
        output <= input; 
    end if;
end process;
end bhv;