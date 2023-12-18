library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top_level_tb is
end top_level_tb;

architecture tb_arch of top_level_tb is
    signal clock_tb : std_logic := '0';
    signal reset_tb : std_logic := '0';
    signal buttons_tb : std_logic_vector(1 downto 0) := "00";
    signal switches_tb : std_logic_vector(9 downto 0) := (others => '0');
    signal outPort_tb : std_logic_vector(31 downto 0);

    

    constant clock_period : time := 10 ns; -- You may adjust this based on your clock frequency

begin
    -- Instantiate the top_level entity
    uut : entity work.top_level
        port map(
            clock => clock_tb,
            reset => reset_tb,
            buttons => buttons_tb,
            switches => switches_tb,
            outPort => outPort_tb
           
        );

    -- Clock process
    clock_process : process
    begin
        while now < 6000 ns -- Simulate for 1000 ns, you can adjust as needed
            loop
                clock_tb <= not clock_tb after clock_period / 2;
                wait for clock_period / 2;
            end loop;
        wait;
    end process;

    -- Stimulus process
    stimulus_process : process
    begin
        -- Initialize inputs
        reset_tb <= '1';
		  buttons_tb <= "11";
        wait for 10 ns;
        reset_tb <= '0';
			
		  --switches_tb <= "0111111111";
		  --buttons_tb <= "10";
		  --wait for 20 ns;
		  
		  --buttons_tb <= "11";

         --load inport 0
          switches_tb <= "0000000011";
		  buttons_tb <= "10";
		  wait for 20 ns;

          --load in port 1
		  switches_tb <= "1000000101";
		  buttons_tb <= "10";
          wait for 20 ns;

          buttons_tb <= "11";
       
		  wait for 990 ns;
        wait;
    end process;

end tb_arch;
