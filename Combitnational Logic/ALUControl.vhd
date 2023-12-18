library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALUControl is
    Port ( 
        IR5to0 : in std_logic_vector(5 downto 0); --Function Code (R-Type)
        IR31to26 : in std_logic_vector(5 downto 0); --op 
        ALUOp : in std_logic_vector(1 downto 0);
        OpSelect : out std_logic_vector(7 downto 0);
        HI_EN, LO_EN : out std_logic;
		ALU_LO_HI : out  std_logic_vector(1 downto 0)
    );
end ALUControl;
architecture rtl of ALUControl is

constant ADD_UNSIGNED_OP : std_logic_vector(7 downto 0) := X"21";

constant MOVE_FROM_HI_OP : std_logic_vector(7 downto 0) := X"10";
constant MOVE_FROM_LOW_OP: std_logic_vector(7 downto 0) := X"12";

constant MULT_SIGNED_OP : std_logic_vector(7 downto 0) := X"18";
constant MULT_UNSIGNED_OP : std_logic_vector(7 downto 0) := X"19";

begin


process(IR31to26, IR5to0, ALUOp)
begin 

OpSelect <= ADD_UNSIGNED_OP;
HI_EN <= '0';
LO_EN <= '0';
ALU_LO_HI <= "00";

--PC = PC + 4
if ALUOp = "01" then 
    Opselect <= ADD_UNSIGNED_OP;
--I-Type Instruction 
elsif ALUOp = "10" then 
    --account for special case where I type OP code is the same as R type function 
    if IR31to26 = x"02" then 
        Opselect <= x"08"; --use same op for jump and jump register
    elsif IR31to26 = x"10" then
        Opselect <= x"F1";
    else
        Opselect <= "00" & IR31to26;
    end if;
-- R-Type Instruction 
elsif ALUOp = "11" then 
    Opselect <= "00" & IR5to0;

    if "00" & IR5to0 = MOVE_FROM_LOW_OP then 
        ALU_LO_HI <= "01";
    elsif "00" & IR5to0 = MOVE_FROM_HI_OP then 
        ALU_LO_HI <= "10";
    end if;

    if ("00" & IR5to0 = MULT_SIGNED_OP or "00" & IR5to0 = MULT_UNSIGNED_OP)  then 
        HI_EN <= '1';
        LO_EN <= '1';
    end if;



elsif ALUOp = "00" then 
    ALU_LO_HI <= "00";
    Opselect <= ADD_UNSIGNED_OP;
end if;





end process;
end architecture;