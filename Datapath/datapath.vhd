library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity datapath is
    port(
        clock        : in  std_logic; 
        reset        : in  std_logic; 
        InPort1_en   : in  std_logic;
        InPort0_en   : in  std_logic;
        InPort0      : in  std_logic_vector(9 downto 0) := (others => '0'); 
		InPort1      : in  std_logic_vector(9 downto 0) := (others => '0'); 
        PCEn         : in  std_logic; 
        IorD         : in  std_logic; 
        MemRead      : in  std_logic; 
        MemWrite     : in  std_logic; 
        MemToReg     : in  std_logic; 
        IRWrite      : in  std_logic; 
        JumpAndLink  : in  std_logic; 
        IsSigned     : in  std_logic; 
        PCSource     : in  std_logic_vector(1 downto 0); 
        ALUSrcA      : in  std_logic; 
        ALUSrcB      : in  std_logic_vector(1 downto 0); 
		ALUOP 		 : in std_logic_vector(1 downto 0);
        RegWrite     : in  std_logic; 
        RegDst       : in  std_logic; 
        IR31downto26 : out std_logic_vector(5 downto 0); 
        OutPort      : out std_logic_vector(31 downto 0);
        branchTaken  : out std_logic
      
    );
end datapath;

architecture rtl of datapath is
	signal PC_4 : std_logic_vector(31 downto 0);
    signal MUXTOPC : std_logic_vector(31 downto 0);
    signal PCTOMUX : std_logic_vector(31 downto 0);
    signal ALUOUT : std_logic_vector(31 downto 0);
    signal MUXTOMEM : std_logic_vector(31 downto 0);
    
    signal MEMOUT, MEMORYDATA : std_logic_vector(31 downto 0);
    signal IROUT : std_logic_vector(31 downto 0);
    signal MUX_TO_WRITE_REGISTER : std_logic_vector(4 downto 0);
    signal MUX_TO_WRITE_DATA : std_logic_vector(31 downto 0);
    signal READDATA1_TO_REGA, READDATA2_TO_REGB : std_logic_vector(31 downto 0);
    signal REGA_TO_MUX, REGB_TO_MUX : std_logic_vector(31 downto 0);
    signal MUX0_TO_ALU, MUX1_TO_ALU : std_logic_vector(31 downto 0);
	signal SIGN_EXTEND_OUT, SHIFT_LEFT_TO_MUX : std_logic_vector(31 downto 0);
	  
    signal ALU_OUTPUT_RESULT, ALU_OUTPUT_RESULT_HI : std_logic_vector(31 downto 0);
    signal LO_OUT, HI_OUT, ALU_OUT: std_logic_vector(31 downto 0);
	signal DESTINATION_MUX_OUT : std_logic_vector(31 downto 0);

    signal SHIFT_LEFT_TO_CONCAT, CONCAT_OUT : std_logic_vector(31 downto 0);

    signal INPort0_ext, InPort1_ext : std_logic_vector(31 downto 0); 

    --alu signals for controller
    signal OPSelect : std_logic_vector(7 downto 0);
    signal HI_en, LO_en : std_logic;
	signal ALU_LO_HI : std_logic_Vector(1 downto 0);
    signal IR25TO0_ext : std_logic_vector(31 downto 0);
	 

begin

PROGRAM_COUNTER : entity work.reg32
PORT MAP(
    clock => clock,
    reset => reset,
    en => PCEn,
    input => MUXTOPC,
    output=> PCTOMUX
);

MUX_TO_MEMORY : entity work.mux2to1
GENERIC MAP(
    WIDTH => 32
)
PORT MAP(
    sel => IorD,
    A => PCTOMUX,
    B=> ALU_OUT,
    output => MUXTOMEM
);

inPort0_ext <= "0000000000000000000000" & inPort0;
inPort1_ext <= "0000000000000000000000" & inPort1;
MEMORY : entity work.memory 
PORT MAP(
    clock => clock,
    reset => reset,
    baddr => MUXTOMEM,
    dataIn => REGB_TO_MUX,
    memRead => memRead,
    memWrite => memWrite,
    inPort0 => inPort0_ext,
    inPort1 => inPort1_ext,
    inPort0_en => inPort0_en,
    inPort1_en => inPort1_en,
    outPort => outPort,
    dataOut => MEMOUT
);
MEMORY_DATA_REGISTER : entity work.reg32
PORT MAP(
    clock => clock,
    reset => reset,
    en => '1',
    input => MEMOUT,
    output=> MEMORYDATA
);

INSTRUCTION_REGISTER : entity work.reg32
PORT MAP(
    clock => clock,
    reset => reset,
    en => IRWrite,
    input => MEMOUT,
    output=> IROUT
);
IR31downto26 <= IROUT(31 downto 26);
IR_MUX_TO_REGISTER_FILE : entity work.mux2to1
GENERIC MAP(
    WIDTH => 5
)
PORT MAP(
    sel => REGDst,
    A => IROUT(20 downto 16),
    B => IROUT(15 downto 11),
    output => MUX_TO_WRITE_REGISTER
);
MEMORY_DATA_MUX_TO_REGISTER_FILE : entity work.mux2to1
GENERIC MAP(
    WIDTH => 32
)
PORT MAP(
    SEL =>MemToReg,
    A => DESTINATION_MUX_OUT,
    B => MEMORYDATA,
    output => MUX_TO_WRITE_DATA
);

PC_4 <= PCTOMUX;
REGISTER_FILE : entity work.registerfile
PORT MAP(
    clk => clock,
    rst => reset,
    rd_addr0 => IROUT(25 downto 21),
    rd_addr1 => IROUT(20 downto 16),
    wr_addr => MUX_TO_WRITE_REGISTER,
    wr_en  => RegWrite,
    wr_data => MUX_TO_WRITE_DATA,
    rd_data0 => READDATA1_TO_REGA,
    rd_data1 => READDATA2_TO_REGB,
    PC_4 => PC_4,
    JumpAndLink => JumpAndLink

);
REGISTER_A : entity work.reg32
PORT MAP(
    clock => clock,
    reset => reset,
    en => '1',
    input => READDATA1_TO_REGA,
    output=> REGA_TO_MUX
);
REGISTER_B : entity work.reg32
PORT MAP(
    clock => clock,
    reset => reset,
    en => '1',
    input => READDATA2_TO_REGB,
    output=> REGB_TO_MUX
);

MUX_TO_ALU_TOP : entity work.mux2to1
GENERIC MAP(
    WIDTH => 32
)
PORT MAP(
    SEL =>ALUSrcA,
    A => PCTOMUX,
    B => REGA_TO_MUX,
    output => MUX0_TO_ALU
);

SIGN_EXTEND : entity work.SignExtend
PORT MAP(
    input_16bits => IROUT(15 downto 0),
    output_32bits => SIGN_EXTEND_OUT,
    isSigned => isSigned
);


SHIFTLEFT_TO_MUX : entity work.ShiftLeft
PORT MAP(
    input_32bits => SIGN_EXTEND_OUT,
    output_shifted => SHIFT_LEFT_TO_MUX
);

MUX_TO_ALU_BOTTOM : entity work.mux4to1
GENERIC MAP(
    WIDTH => 32
)
PORT MAP(
    sel => ALUSrcB,
    A => REGB_TO_MUX,
    B => X"00000004",
    C => SIGN_EXTEND_OUT,
    D => SHIFT_LEFT_TO_MUX,
    output => MUX1_TO_ALU
);

ALU : entity work.alu 
PORT MAP(
    input1 => MUX0_TO_ALU,
    input2 => MUX1_TO_ALU,
    shiftAmount => IROUT(10 downto 6),
    OpCode => OPSelect,
    output => ALU_OUTPUT_RESULT,
    outputHI => ALU_OUTPUT_RESULT_HI,
    branchTaken => branchTaken
);
ALU_OUT_REG : entity work.reg32
PORT MAP(
    clock => clock,
    reset => reset,
    en => '1',
    input => ALU_OUTPUT_RESULT,
    output=> ALU_OUT
);

ALU_LO : entity work.reg32
PORT MAP(
    clock => clock,
    reset => reset,
    en => LO_en,
    input => ALU_OUTPUT_RESULT,
    output=> LO_OUT
);

ALU_HI : entity work.reg32
PORT MAP(
    clock => clock,
    reset => reset,
    en => HI_en,
    input => ALU_OUTPUT_RESULT_HI,
    output=> HI_OUT
);

DESTINATION_MUX : entity work.mux4to1
GENERIC MAP(
    WIDTH => 32
)
PORT MAP(
    sel => ALU_LO_HI,
    A => ALU_OUT,
    B => LO_OUT,
    C => HI_OUT,
    D => (others=>'0'),
    output => DESTINATION_MUX_OUT
);

IR25TO0_ext <= "000000" & IROUT(25 downto 0);
IR_SHIFT_LEFT : entity work.ShiftLeft
PORT MAP(
    input_32bits => IR25TO0_ext,
    output_shifted => SHIFT_LEFT_TO_CONCAT
);
CONCAT_TO_MUX : entity work.Concat
PORT MAP(
    input_28bits => SHIFT_LEFT_TO_CONCAT(27 downto 0),
    input_4bits  => PCTOMUX(31 downto 28),
    output_concat => CONCAT_OUT
);

MUX_TO_LOGIC : entity work.mux4to1 
GENERIC MAP(
    WIDTH => 32
)
PORT MAP(
    sel => PCSource,
    A => ALU_OUTPUT_RESULT,
    B => ALU_OUT,
    C => CONCAT_OUT,
    D => (others => '0'),
    output => MUXTOPC
);


ALU_CONTROL : entity work.ALUControl
PORT MAP(
    IR5to0 => IROUT(5 downto 0),
	IR31to26 => IROUT(31 downto 26),
    ALUop => ALUop,
    OPSelect => OPSelect,
    ALU_LO_HI => ALU_LO_HI,
    HI_EN => HI_EN,
    LO_EN => LO_EN
);
end architecture;