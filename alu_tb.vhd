library ieee;
use ieee.std_logic_1164.all;

entity alu_tb is
end alu_tb;

architecture sim of alu_tb is
    -- Constants for opcode values
    constant ADD_UNSIGNED_OP : std_logic_vector(7 downto 0) := X"21";
    constant SUB_UNSIGNED_OP : std_logic_vector(7 downto 0) := X"23";
    constant MULT_SIGNED_OP : std_logic_vector(7 downto 0) := X"18";
    constant MULT_UNSIGNED_OP : std_logic_vector(7 downto 0) := X"19";
    constant AND_OP : std_logic_vector(7 downto 0) := X"24";
    constant OR_OP : std_logic_vector(7 downto 0) := X"25";
    constant XOR_OP : std_logic_vector(7 downto 0) := X"26";
    constant SHIFT_RIGHT_LOGICAL_OP : std_logic_vector(7 downto 0) := X"02";
    constant SHIFT_LEFT_LOGICAL_OP : std_logic_vector(7 downto 0) := X"00";
    constant SHIFT_RIGHT_ARITHMETIC_OP : std_logic_vector(7 downto 0) := X"03";
    constant SET_ON_LESS_THAN_SIGNED_OP : std_logic_vector(7 downto 0) := X"2A";
    constant SET_ON_LESS_THAN_UNSIGNED_OP : std_logic_vector(7 downto 0) := X"2B";
    constant MOVE_FROM_HI_OP : std_logic_vector(7 downto 0) := X"10";
    constant MOVE_FROM_LOW_OP: std_logic_vector(7 downto 0) := X"12";
    constant JUMP_REGISTER: std_logic_vector(7 downto 0) := X"08";
    constant BRANCH_ON_LT_ZERO : std_logic_vector(7 downto 0) := X"01";
    constant BRANCH_ON_GTE_ZERO : std_logic_vector(7 downto 0) := X"09";
    -- Add constants for other opcodes...

    -- Signals for testbench
    signal input1_tb, input2_tb: std_logic_vector(31 downto 0);
	signal shiftAmount_tb : std_logic_vector(4 downto 0);
	signal opCode_tb : std_logic_vector(7 downto 0);
    signal output_tb, outputHI_tb : std_logic_vector(31 downto 0);
    signal branchTaken_tb : std_logic;

    -- Component instantiation
    component alu
        port (
            input1 : in std_logic_vector(31 downto 0);
            input2 : in std_logic_vector(31 downto 0);
            shiftAmount : in std_logic_vector(4 downto 0);
            OpCode : in std_logic_vector(7 downto 0);
            output : out std_logic_vector(31 downto 0);
            outputHI : out std_logic_vector(31 downto 0);
            branchTaken : out std_logic
        );
    end component;

begin
    -- ALU instantiation
    uut: alu
        port map (
            input1 => input1_tb,
            input2 => input2_tb,
            shiftAmount => shiftAmount_tb,
            OpCode => OpCode_tb,
            output => output_tb,
            outputHI => outputHI_tb,
            branchTaken => branchTaken_tb
        );

    -- Testbench process
    process
    begin
        -- Initialize signals and inputs
        input1_tb <= (others => '0');
        input2_tb <= (others => '0');
        shiftAmount_tb <= (others => '0');
        OpCode_tb <= (others => '0');

        -- Test case 1: 10 + 15
        input1_tb <= X"0000000A";
        input2_tb <= X"0000000F";
        OpCode_tb <= ADD_UNSIGNED_OP;

        wait for 10 ns;

        -- Test case 2: 25 - 10
        input1_tb <= X"00000019";
        input2_tb <= X"0000000A";
        OpCode_tb <= SUB_UNSIGNED_OP;

        wait for 10 ns;

        -- Test case 3: 10 * -4
        input1_tb <= X"0000000A";
        input2_tb <= X"FFFFFFFC";
        OpCode_tb <= MULT_SIGNED_OP;

        wait for 10 ns;


        -- Test case 4: 64k * 132k
        input1_tb <= X"00010000";
        input2_tb <= X"00020000";
        OpCode_tb <= MULT_UNSIGNED_OP;

    
           
         wait for 10 ns;

         -- Test case 5: AND
         input1_tb <= X"0000FFFF";
         input2_tb <= X"FFFF1234";
         OpCode_tb <= AND_OP;
        -- Add more test cases for other operations...
        wait for 10 ns;

        -- Test case 6: Shift Right LOGICAL
        input1_tb <= X"0000000F";
        input2_tb <= X"00000000";
        shiftAmount_tb <= "00100";
        OpCode_tb <= SHIFT_RIGHT_LOGICAL_OP;
        wait for 10 ns;


        -- Test case 7: Shift Right arithmetic
        input1_tb <= X"F0000001";
        input2_tb <= X"00000000";
        shiftAmount_tb <= "00001";
        OpCode_tb <= SHIFT_RIGHT_ARITHMETIC_OP;
        wait for 10 ns;


        -- Test case 8: Shift Right arithmetic
        input1_tb <= X"00000008";
        input2_tb <= X"00000000";
        shiftAmount_tb <= "00001";
        OpCode_tb <= SHIFT_RIGHT_ARITHMETIC_OP;
        wait for 10 ns;


        -- Test case 9: Set on less than than
        input1_tb <= X"0000000A";
        input2_tb <= X"0000000F";
        OpCode_tb <= SET_ON_LESS_THAN_UNSIGNED_OP;
        wait for 10 ns;

        -- Test case 10: Set on less than than
        input1_tb <= X"0000000F";
        input2_tb <= X"0000000A";
        OpCode_tb <= SET_ON_LESS_THAN_UNSIGNED_OP;
        wait for 10 ns;

        input1_tb <= X"00000005";
        input2_tb <= X"00000000";
        OpCode_tb <= BRANCH_ON_LT_ZERO;
        wait for 10 ns;

        input1_tb <= X"00000005";
        input2_tb <= X"00000000";
        OpCode_tb <= BRANCH_ON_GTE_ZERO;
        wait for 10 ns;
        
        -- End the simulation after all test cases
        wait;
    end process;

end sim;
