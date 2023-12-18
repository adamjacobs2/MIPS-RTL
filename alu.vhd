library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity alu is
    port (
    input1 : in std_logic_vector(31 downto 0);
    input2 : in std_logic_vector(31 downto 0);
    shiftAmount : in std_logic_vector(4 downto 0);
    OpCode : in std_logic_vector(7 downto 0);
    output : out std_logic_vector(31 downto 0);
    outputHI : out std_logic_vector(31 downto 0);
    branchTaken : out std_logic
    );
end alu;

architecture rtl of alu is

    constant ADD_UNSIGNED_OP : std_logic_vector(7 downto 0) := X"21";
    constant ADD_UNSIGNEDI_OP : std_logic_vector(7 downto 0) := X"09";
    constant SUB_UNSIGNED_OP : std_logic_vector(7 downto 0) := X"23";
    constant SUB_UNSIGNEDI_OP : std_logic_vector(7 downto 0) := X"F1"; --changed bc duplicate
    constant MULT_SIGNED_OP : std_logic_vector(7 downto 0) := X"18";
    constant MULT_UNSIGNED_OP : std_logic_vector(7 downto 0) := X"19";
    constant AND_OP : std_logic_vector(7 downto 0) := X"24";
    constant ANDI_OP : std_logic_vector(7 downto 0) := X"0C";
    constant OR_OP : std_logic_vector(7 downto 0) := X"25";
    constant ORI_OP : std_logic_vector(7 downto 0) := X"0D";
    constant XOR_OP : std_logic_vector(7 downto 0) := X"26";
    constant XORI_OP : std_logic_vector(7 downto 0) := X"0E";
    constant SHIFT_RIGHT_LOGICAL_OP : std_logic_vector(7 downto 0) := X"02";
    constant SHIFT_LEFT_LOGICAL_OP : std_logic_vector(7 downto 0) := X"00";

    constant SHIFT_RIGHT_ARITHMETIC_OP : std_logic_vector(7 downto 0) := X"03";

    constant SET_ON_LESS_THAN_SIGNED_OP : std_logic_vector(7 downto 0) := X"0A";
    constant SET_ON_LESS_THAN_SIGNEDI_OP : std_logic_vector(7 downto 0) := X"2A";

    constant SET_ON_LESS_THAN_UNSIGNED_OP : std_logic_vector(7 downto 0) := X"2B";
    constant SET_ON_LESS_THAN_UNSIGNEDI_OP : std_logic_vector(7 downto 0) := X"0B";
    constant MOVE_FROM_HI_OP : std_logic_vector(7 downto 0) := X"10";
    constant MOVE_FROM_LOW_OP: std_logic_vector(7 downto 0) := X"12";
    constant JUMP: std_logic_vector(7 downto 0) := X"08";
    constant BRANCH_ON_EQUAL : std_logic_vector(7 downto 0) := X"04";
    constant BRANCH_ON_NOT_EQUAL : std_logic_vector(7 downto 0) := X"05";
    constant BRANCH_ON_LT_ZERO : std_logic_vector(7 downto 0) := X"01";
    constant BRANCH_ON_GTE_ZERO : std_logic_vector(7 downto 0) := X"99";
    


    

begin
process(input1, input2, OpCode, shiftAmount)

variable temp_Mult : std_logic_vector(63 downto 0);
begin
    branchTaken <= '0';
    outputHI <= (others=>'0');
	output <= (others=>'0');

    case(Opcode) is
        when ADD_UNSIGNED_OP =>
            output <= input1 + input2;
        when ADD_UNSIGNEDI_OP =>
            output <= input1 + input2;
        when SUB_UNSIGNED_OP =>
            output <= input1 - input2;
        when SUB_UNSIGNEDI_OP =>
            output <= input1 - input2;
        when MULT_SIGNED_OP =>
	     temp_mult := std_logic_vector(signed(Input1) * signed(Input2));
             output <= temp_mult(31 downto 0);
             outputHI <= temp_mult(63 downto 32);
        when MULT_UNSIGNED_OP =>
             temp_mult := std_logic_vector(unsigned(Input1) * unsigned(Input2));
             output <= temp_mult(31 downto 0);
             outputHI <= temp_mult(63 downto 32);
        when AND_OP =>
            output <= input1 and input2;
        when ANDI_OP =>
            output <= input1 and input2;
        when OR_OP =>
            output <= input1 or input2;
        when ORI_OP =>
            output <= input1 or input2;
        when XOR_OP =>
            output <= input1 xor input2;
        when XORI_OP =>
            output <= input1 xor input2;
        when SHIFT_RIGHT_LOGICAL_OP =>
            output <= std_logic_vector(shift_right(unsigned(input2), to_integer(unsigned(shiftAmount))));
        when SHIFT_LEFT_LOGICAL_OP =>
			
            output <= std_logic_vector(shift_left(unsigned(input2), to_integer(unsigned(shiftAmount))));
        when SHIFT_RIGHT_ARITHMETIC_OP =>
            output <= std_logic_vector(shift_right(signed(Input2), to_integer(unsigned(ShiftAmount))));
          
        when SET_ON_LESS_THAN_SIGNED_OP =>
            if signed(input1) < signed(input2) then
                output <= X"00000001";
            else
                output <= (others => '0');
            end if;
        when SET_ON_LESS_THAN_SIGNEDI_OP =>
            if signed(input1) < signed(input2) then
                    output <= X"00000001";
            else
                    output <= (others => '0');
            end if;
        when SET_ON_LESS_THAN_UNSIGNED_OP =>
            if unsigned(input1) < unsigned(input2) then
                output <= X"00000001";
            else
                output <= (others => '0');
            end if;
        when SET_ON_LESS_THAN_UNSIGNEDI_OP =>
            if unsigned(input1) < unsigned(input2) then
                output <= X"00000001";
            else
                output <= (others => '0');
            end if;
        when MOVE_FROM_HI_OP =>
            output <= (others => '0');
            
        when MOVE_FROM_LOW_OP =>
            output <= (others => '0');
        
        when JUMP =>
            branchTaken <= '1';
            output <= input1;
          
       
        when BRANCH_ON_LT_ZERO =>
            if (to_integer(signed(input1)) < 0) then
                branchTaken <= '1';
            else 
                branchTaken <= '0';
            end if;

        when BRANCH_ON_GTE_ZERO =>
            if (to_integer(signed(input1)) < 0) then
                branchTaken <= '0';
            else 
                branchTaken <= '1';
            end if;
        when BRANCH_ON_EQUAL =>
            if (to_integer(signed(input1)) = to_integer(signed(input2))) then
                branchTaken <= '1';
            else 
                branchTaken <= '0';
            end if;
        when BRANCH_ON_NOT_EQUAL =>
            if (to_integer(signed(input1)) = to_integer(signed(input2))) then
                branchTaken <= '0';
            else 
                branchTaken <= '1';
            end if;

        when others=> 
		  output <= (others => '0');
    end case;
        
	 end process;
end architecture;