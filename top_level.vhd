library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top_level is
    Port (
        clock : in std_logic;
        reset : in std_logic; 
        buttons : in std_logic_vector(1 downto 0); --IN PORT 0 / 1 Enable
        switches : in std_logic_vector(9 downto 0);
        outPort : out std_logic_vector(31 downto 0)
    
    );
end top_level;

architecture bhv of top_level is

        signal IR31to26 : std_logic_vector(5 downto 0);
        signal PCWriteCond :std_logic;
        signal PCWrite:  std_logic;
        signal JumpAndLink :  std_logic;
        signal IsSigned :  std_logic;
        signal IorD :  std_logic;
        signal MemRead :  std_logic;
        signal MemWrite :  std_logic;
        signal MemToReg :  std_logic;
        signal IRWrite :  std_logic;
        signal PCSource :  std_logic_vector(1 downto 0);
        signal ALUSrcA :  std_logic;
        signal ALUOp :  std_logic_vector(1 downto 0);
        signal ALUSrcB :  std_logic_vector(1 downto 0);
        signal RegWrite :  std_logic;
        signal RegDst :  std_logic;
        signal buttonsN : std_logic_vector(1 downto 0);


        signal inport0_en : std_logic;
		  signal inport1_en : std_logic;
        signal InPort0      :   std_logic_vector(31 downto 0); 
		signal  InPort1      :  std_logic_vector(31 downto 0); 
        signal PCEn   :       std_logic; 
        signal BranchAndPCWrite : std_logic;
       
    
        
     
       signal branchTaken  :  std_logic;
       signal LEDS_ext : std_logic_vector(31 downto 0);
       signal inport0_ext : std_logic_vector( 9 downto 0);
       signal inport1_ext : std_logic_vector( 9 downto 0);


begin
PCEn <= (branchTaken AND PCWriteCond) or PCWRITE;

CTRL : entity work.Controller
Port map(
      clock          => clock,
      reset          => buttonsN(1),
      IR31to26       => IR31to26,
      PCWriteCond    => PCWriteCond,
      PCWrite        => PCWrite,
      JumpAndLink    => JumpAndLink,
      IsSigned       => IsSigned,
      IorD           => IorD,
      MemRead        => MemRead,
      MemWrite       => MemWrite,
      MemToReg       => MemToReg,
      IRWrite        => IRWrite,
      PCSource       => PCSource,
      ALUSrcA        => ALUSrcA,
      ALUOp          => ALUOp,
      ALUSrcB        => ALUSrcB,
      RegWrite       => RegWrite,
      RegDst         => RegDst
);

buttonsN <= not buttons;
inport1_en <= buttonsN(0) and switches(9);
inport0_en <= buttonsN(0) and not switches(9);
inport0_ext <= '0' & switches(8 downto 0);
inport1_ext <= '0' & switches(8 downto 0);

DATA : entity work.datapath
PORT MAP(
    clock        => clock,
    reset        => buttonsN(1),
    InPort1_en   => inport1_en,
    InPort0_en   => inport0_en,
    InPort0      => inport0_ext,
    InPort1      => inport1_ext,
    PCEn         => PCEn,
    IorD         => IorD,
    MemRead      => MemRead,
    MemWrite     => MemWrite,
    MemToReg     => MemToReg,
    IRWrite      => IRWrite,
    JumpAndLink  => JumpAndLink,
    IsSigned     => IsSigned,
    PCSource     => PCSource,
    ALUSrcA      => ALUSrcA,
    ALUSrcB      => ALUSrcB,
    ALUOP        => ALUOP,
    RegWrite     => RegWrite,
    RegDst       => RegDst,
    IR31downto26 => IR31to26,
    OutPort      => OutPort,
    branchTaken  => branchTaken
);
end architecture;