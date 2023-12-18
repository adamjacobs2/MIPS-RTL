library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
    port (
        clock       : in std_logic;
        reset       : in std_logic;
        Baddr   : in  std_logic_vector(31 downto 0);
        DataOut      : out std_logic_vector(31 downto 0);
        DataIn      : in  std_logic_vector(31 downto 0);
        MemRead   : in std_logic;
        MemWrite  : in std_logic;
        InPort1_en : in  std_logic := '0';
        InPort0_en : in  std_logic := '0';
        InPort0, InPort1    : in  std_logic_vector(31 downto 0); 
        OutPort    : out std_logic_vector(31 downto 0)
    );
end memory;

architecture IO_WRAP of memory is

    signal OutPortin : std_logic_vector(31 downto 0) := (others => '0');
    signal Ram_en   : std_logic;
    signal InPort0_out    : std_logic_vector(31 downto 0);
    signal InPort1_out    : std_logic_vector(31 downto 0);
    signal RamOut     : std_logic_vector(31 downto 0);
    signal OutMuxSel  : std_logic_vector(1 downto 0);

begin 

    U_4to1Mux: entity work.mux4to1
        port map (
            sel    => OutMuxSel,
            A    => InPort0_out,
            B    => InPort1_out,
            C    => RamOut,
            D    => (others => '0'),
            output => DataOut
        );
    
    OUT_PORT: entity work.reg32
        port map (
            clock    => clock,
            reset    => '0',
            en     => '1',
            input  => outPortIn,
            output => OutPort
        );
    IN_PORT_0: entity work.reg32
        port map (
            clock    => clock,
            reset    => '0',
            en     => InPort0_en,
            input  => InPort0,
            output => InPort0_out
        );

    IN_PORT_1: entity work.reg32      
        port map (
            clock    => clock,
            reset    => '0',
            en     => InPort1_en,
            input  => InPort1,
            output => InPort1_out
        );

    U_RAM: entity work.Ram
        port map (
            address	=> Baddr(9 downto 2), -- uses word-aligned addresses
            clock   => clock,
            data	=> DataIn,
            wren	=> Ram_en,
            q		=> RamOut
        );

		  
	 process(Baddr, MemWrite)
    begin 
        Ram_en <= '0';
        
        if (MemWrite = '1') then
            if (Baddr = x"0000FFFC") then -- write to the output port 
                OutPortIn<=DataIn;
            else -- write to the RAM 
                Ram_en <= '1'; -- RAM -> any address other than $0000FFFC
            end if; 
        end if;	  
	 end process;
		  
		  
    process (clock,reset)
    begin -- process
		  
        if (reset = '1') then -- select the 0 output of the mux
            OutMuxSel <= "11";
        elsif (rising_edge(clock)) then 
            if (MemRead = '1') then
                if (Baddr = x"0000FFF8") then -- input 0 goes to InPort0 
                    OutMuxSel <= "00"; 
                elsif (Baddr = x"0000FFFC") then --input 1 goes to InPort01
                    OutMuxSel <= "01"; 
                else --input 2 goes to RAM
                    OutMuxSel <= "10";
                end if;
            end if;
        end if;
    end process;

end IO_WRAP;