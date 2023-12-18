library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memory_tb is
end memory_tb;

architecture tb_architecture of memory_tb is
    signal clock : std_logic := '0';
    signal reset : std_logic := '0';
    signal baddr : std_logic_vector(31 downto 0) := (others => '0');
    signal dataIn : std_logic_vector(31 downto 0) := (others => '0');
    signal memRead : std_logic := '0';
    signal memWrite : std_logic := '0';
    signal inPort0, inPort1 : std_logic_vector(31 downto 0) := (others => '0');
    signal inPort0_en, inPort1_en : std_logic := '0';
    signal outPort : std_logic_vector(31 downto 0);
    signal dataOut : std_logic_vector(31 downto 0);

    component Memory is
        port (
            clock, reset: in std_logic;
            baddr : in std_logic_vector(31 downto 0);
            dataIn : in std_logic_vector(31 downto 0);
            memRead : in std_logic;
            memWrite : in std_logic;
            inPort0, inPort1 : in  std_logic_vector(31 downto 0);
            inPort0_en, inPort1_en : in  std_logic;
            outPort : out std_logic_vector(31 downto 0);
            dataOut : out std_logic_vector(31 downto 0)
        );
    end component;

begin
    -- Instantiate the memory module
    UUT: Memory
    port map (
        clock => clock,
        reset => reset,
        baddr => baddr,
        dataIn => dataIn,
        memRead => memRead,
        memWrite => memWrite,
        inPort0 => inPort0,
        inPort1 => inPort1,
        inPort0_en => inPort0_en,
        inPort1_en => inPort1_en,
        outPort => outPort,
        dataOut => dataOut
    );

    -- Clock process
    process
    begin
        while now < 300 ns loop  -- Simulation time of 200 ns
            clock <= not clock;
            wait for 5 ns;  -- Adjust the clock period as needed
        end loop;
        wait;
    end process;

    -- Stimulus process
    process
    begin
        wait for 5 ns;
        
        reset <= '1';  -- Apply reset
        wait for 10 ns;
        reset <= '0';  -- Deassert reset

        -- Write to 0
        dataIn <= X"0A0A0A0A";
        baddr  <= X"00000000";
        memWrite <= '1';
        memread <= '0'; 
        inPort0_en <= '0';
        inPort1_en <= '0';
        wait for 20 ns;
        --write to 1
        dataIn <= X"F0F0F0F0";
        baddr  <= X"00000004";
        memWrite <= '1';
        memread <= '0'; 
        inPort0_en <= '0';
        inPort1_en <= '0';
        wait for 20 ns;
        --read from 0
        baddr  <= X"00000000";
        memWrite <= '0';
        memread <= '1'; 
        inPort0_en <= '0';
        inPort1_en <= '0';
        wait for 20 ns;
         --read from 0
         baddr  <= X"00000001";
         memWrite <= '0';
         memread <= '1'; 
         inPort0_en <= '0';
         inPort1_en <= '0';
         wait for 20 ns;
        --read from 1
        baddr  <= X"00000004";
        memWrite <= '0';
        memread <= '1'; 
        inPort0_en <= '0';
        inPort1_en <= '0';
        wait for 20 ns;
        --read from 1
        baddr  <= X"00000005";
        memWrite <= '0';
        memread <= '1'; 
        inPort0_en <= '0';
        inPort1_en <= '0';
        wait for 20 ns;
        --Write 0x00001111 to the outport (should see value appear on outport)
        dataIn <= X"00001111";
        baddr  <= X"0000FFFC";
        memWrite <= '1';
        memread <= '0'; 
        inPort0_en <= '0';
        inPort1_en <= '0';
        wait for 20 ns;
        --Load 0x00010000 into inport 0
        inPort0 <= X"00010000";
        baddr  <= X"0000FFF8";
        memWrite <= '1';
        memread <= '0'; 
        inPort0_en <= '1';
        inPort1_en <= '0';
        wait for 20 ns;

        --Load 0x00000001 into inport 1
        inport1 <= X"00000001";
        baddr  <= X"0000FFFC";
        memWrite <= '1';
        memread <= '0'; 
        inPort0_en <= '0';
        inPort1_en <= '1';
        wait for 20 ns;

        --Read from inport 0 (should show 0x00010000 on read data output)
        dataIn <= X"00000000";
        baddr  <= X"0000FFF8";
        memWrite <= '0';
        memread <= '1'; 
        inPort0_en <= '0';
        inPort1_en <= '0';
        wait for 20 ns;

        --Read from inport 1 (should show 0x00000001 on read data output)
        dataIn <= X"00000000";
        baddr  <= X"0000FFFC";
        memWrite <= '0';
        memread <= '1'; 
        inPort0_en <= '0';
        inPort1_en <= '0';
        wait for 20 ns;
       
       

        wait;
    end process;

end tb_architecture;
