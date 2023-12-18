library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity GCD is
    Port (
        clock : in std_logic;
        reset : in std_logic; 
        buttons : in std_logic_vector(1 downto 0); --IN PORT 0 / 1 Enable
        switches : in std_logic_vector(9 downto 0);
        SSG0 : out std_logic_vector(7 downto 0);
        SSG1 : out std_logic_vector(7 downto 0);
        SSG2 : out std_logic_vector(7 downto 0);
        SSG3 : out std_logic_vector(7 downto 0);
        SSG4 : out std_logic_vector(7 downto 0);
        SSG5 : out std_logic_vector(7 downto 0)

    );
end GCD;

architecture bhv of GCD is
signal outport_signal : std_logic_vector(31 downto 0) := (others => '0');
       
begin


CPU : entity work.top_level
Port map(
    clock => clock,
    reset => reset,
    buttons => buttons,
    switches => switches,
    outPort => outport_signal
);
	SSG5(7) <= '1';
	SSG4(7) <= '1';
	SSG3(7) <= '1';
	SSG2(7) <= '1';
	SSG1(7) <= '1';
	SSG0(7) <= '1';
U_LED5 : entity work.decoder 
    port map (
        input  => OutPort_signal(23 downto 20),
        output => SSG5(6 downto 0)
    );
U_LED4 : entity work.decoder 
    port map (
        input  => OutPort_signal(19 downto 16),
        output => SSG4(6 downto 0)
    );
U_LED3 : entity work.decoder
    port map (
        input  => OutPort_signal(15 downto 12),
        output => SSG3(6 downto 0)
    );

U_LED2 : entity work.decoder Port map(
        input  => OutPort_signal(11 downto 8),
        output => SSG2(6 downto 0)
    );

U_LED1 : entity work.decoder
    port map (
        input  => OutPort_signal(7 downto 4),
        output => SSG1(6 downto 0)
    );
U_LED0 : entity work.decoder
    port map (
        input  => OutPort_signal(3 downto 0),
        output => SSG0(6 downto 0)
    );
      



end architecture;