library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CONTROLLER is
    Port ( 
          clock          : in std_logic; 
          reset          : in std_logic; 
          IR31to26 : in std_logic_vector(5 downto 0);
          PCWriteCond : out std_logic;
          PCWrite: out std_logic;
          IorD : out std_logic;
          MemRead : out std_logic;
          MemWrite : out std_logic;
          MemToReg : out std_logic;
          IRWrite : out std_logic;
		 JumpAndLink : out std_logic;
			 IsSigned : out std_logic;
			 ALUOP	:	out std_logic_vector(1 downto 0);
          PCSource : out std_logic_vector(1 downto 0);
          ALUSrcA : out std_logic;
          ALUSrcB : out std_logic_vector(1 downto 0);
          RegWrite : out std_logic;
          RegDst : out std_logic);

end CONTROLLER;
architecture rtl of CONTROLLER is

	type STATE_TYPE is (INSTRUCTION_FETCH,INSTRUCTION_FETCH_2, INSTRUCTION_DECODE,
                        
								R_type_EXECUTION, R_TYPE_EXECUTION_2, I_TYPE_EXECUTION, I_TYPE_EXECUTION_2,
                        R_TYPE_COMPLETION, I_TYPE_COMPLETION,
								LOAD_MEMORY_DATA_REG_WAIT,
                        MEMORY_ADDRESS_COMPUTATION, MEMORY_ADDRESS_COMPUTATION_2,
                        MEMORY_ACCESS_READ, LOAD_MEMORY_DATA_REG, MEMORY_READ_COMPLETION,
						BRANCH_COMPLETION_2,
                        MEMORY_ACCESS_WRITE,
                        BRANCH_COMPLETION,
                        JUMPANDLINK_STATE,
                        JUMP,HALT); 
    signal state, next_state : STATE_TYPE;
	 
begin

process(clock,reset)
    begin --process
        if (reset = '1') then
            state <= INSTRUCTION_FETCH;
        elsif (rising_edge(clock)) then
            state <= next_state;
        end if;
    end process;
	 
 process(IR31to26, state)
    begin --process

        -- set default values for any of the combinational logic decided in this process
        PCWriteCond <= '0';
        PCWrite     <= '0';
        IorD        <= '0';
        MemRead     <= '0';
        MemWrite    <= '0';
        MemToReg    <= '0';
        IRWrite     <= '0';
        JumpAndLink <= '0';
        IsSigned    <= '0';
        PCSource    <= "00";
        ALUOP    <= (others => '0');
        ALUSrcA     <= '0';
        ALUSrcB     <= "00";
        RegWrite    <= '0';
        RegDst      <= '0'; 
        next_state  <= state;
		  
	case state is

            -- at the end of this state, the next instruction (that is currently at PC) will be at the output of the memory and the PC will be at PC+4
            -- 
			  when INSTRUCTION_FETCH =>

                -- read the instruction from the memory
                IorD <= '0'; 
                MemRead <= '1'; 

				ALUSrcA <= '0';
                ALUSrcB <= "01";
                ALUOP <= "01"; 
				PCSource<= "00";
				PCWrite<= '1';
                -- must load the instruction register from the output of the memory, which will be available after the next clock edge
                next_state <= INSTRUCTION_FETCH_2;

            -- load the next instruction into the instruction register
            when INSTRUCTION_FETCH_2 => 

                IRWrite <= '1';
					 
                next_state <= INSTRUCTION_DECODE;	
			   when INSTRUCTION_DECODE=>
				
					 ALUSrcA <= '0'; -- PC+4 into ALU Input A
               		 IsSigned <= '1'; -- sign extend IR(15 downto 0) to 32 bits
                	 ALUSrcB <= "11"; -- load in the sign extended version of IR(15 downto 0) that has been shifted to the left twice
                	 ALUOP <= "01"; -- add these things together
					 
					  if ("00" & IR31to26 = x"00")
                    then next_state <= R_TYPE_EXECUTION;

                elsif ("00" & IR31to26 = x"09" or "00" & IR31to26 = x"10" or
                        "00" & IR31to26 = x"0C" or "00" & IR31to26 = x"0D" or
                        "00" & IR31to26 = x"0E" or "00" & IR31to26 = x"0A" or
                        "00" & IR31to26 = x"0B" )
                    then next_state <= I_TYPE_EXECUTION;

                elsif ("00" & IR31to26 = x"23" or "00" & IR31to26 = x"2B")
                    then next_state <= MEMORY_ADDRESS_COMPUTATION;

                elsif("00" & IR31to26 = x"04" or "00" & IR31to26 = x"05" or
                        "00" & IR31to26 = x"06" or "00" & IR31to26 = x"07" or
                        "00" & IR31to26 = x"01")
                    then next_state <= BRANCH_COMPLETION;

                elsif ("00" & IR31to26 = x"02")
                    then next_state <= JUMP;

                elsif ("00" & IR31to26 = x"03") -- JAL
                    then next_state <= JUMPANDLINK_STATE;

                elsif ("00" & IR31to26 = x"3F")
                    then next_state <= HALT;

                end if;
					 
				when R_TYPE_EXECUTION =>
				
				next_state <= R_TYPE_EXECUTION_2;
				
				
				when R_TYPE_EXECUTION_2 =>
				-- select the two registered outputs from the instruction register (registers A and B). IR(25 downto 21) (which is rs)
				-- and IR(20 downto 16) (which is rt) are available at the outside of the registers in this state
				ALUSrcA <= '1';
				ALUSrcB <= "00";
				ALUOP <= "11"; --get the OP code from IR 5:0
				next_state <= R_TYPE_COMPLETION;
				
				when R_TYPE_COMPLETION=>
				ALUOP <= "11"; --get the OP code from IR 5:0
				ALUSrcA <= '1';
				ALUSrcB <= "00";
				RegDst <= '1';
				RegWrite<= '1';
				MemToReg<= '0';
				PCWriteCond<='1';
				next_state<= INSTRUCTION_FETCH;
				--
				when I_TYPE_EXECUTION =>
				next_state<= I_TYPE_EXECUTION_2;
				
				when I_TYPE_EXECUTION_2 =>

				ALUOp <= "10";
				ALUSrcA<='1';
				ALUSrcB<="10";
				next_state<= I_TYPE_COMPLETION;
				
				when I_TYPE_COMPLETION=>
				RegDst<= '0';
				RegWrite<= '1';
				MemToReg<= '0';
				next_state<= INSTRUCTION_FETCH;

				when MEMORY_ADDRESS_COMPUTATION =>
				next_state <= MEMORY_ADDRESS_COMPUTATION_2;

				when MEMORY_ADDRESS_COMPUTATION_2=>
				ALUOp <= "01";
				ALUSrcA<='1';
				ALUSrcB<="10";
				IsSigned<= '0';


				
				if("00" & IR31to26 =x"23") then
				next_state<= MEMORY_ACCESS_WRITE;
				elsif("00" & IR31to26=x"2B") then
				next_state<= MEMORY_ACCESS_READ;
				end if;
				
				when MEMORY_ACCESS_READ=>
				MemWrite<='1';
				IorD<='1';
				next_state<= INSTRUCTION_FETCH;


				
				when MEMORY_ACCESS_WRITE=>
				next_state<= LOAD_MEMORY_DATA_REG;
				MemRead<='1';
				IorD<='1';
				
				
				when LOAD_MEMORY_DATA_REG=>				
				next_state<=MEMORY_READ_COMPLETION;

				
				when MEMORY_READ_COMPLETION=>
				
				RegDst<= '0';
				RegWrite<= '1';
				MemToReg<= '1';
				
				next_state<=INSTRUCTION_FETCH;
				
				when BRANCH_COMPLETION=>
				ALUSrcA <= '0'; -- PC+4 into ALU Input A
                IsSigned <= '1'; -- sign extend IR(15 downto 0) to 32 bits
                ALUSrcB <= "11"; -- load in the sign extended version of IR(15 downto 0) that has been shifted to the left twice
                ALUOP <= "01"; -- add these things together
				next_state <= BRANCH_COMPLETION_2;



				when BRANCH_COMPLETION_2=>
				ALUSrcA<='1';
				ALUSrcB<="00";
				ALUOP<="10";
				PCWriteCond<='1';
				PCSource<="01";
				next_state<= INSTRUCTION_FETCH;
				
				when JUMP=> 
				PCWrite<='1';
				PCSource<="10";
				next_state<= INSTRUCTION_FETCH;
				
				When JUMPANDLINK_STATE=>
				ALUOP<="00";
				MemToReg<= '0';
				JumpAndLink<='1';
				RegWrite<= '1';
				next_state<=JUMP;
				
				when HALT=>
				next_state<=Halt;
				
				when others=>
				Null;
				
end case;
end process;
end architecture;