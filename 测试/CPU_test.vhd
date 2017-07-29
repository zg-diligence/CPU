LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY CPU_test IS
END CPU_test;
 
ARCHITECTURE behavior OF CPU_test IS 

    COMPONENT CPU
    PORT(
         RESET : IN  std_logic;
         CLK : IN  std_logic;
         Choice : IN  std_logic_vector(1 downto 0);
         DBus : INOUT  std_logic_vector(15 downto 0);
         ABus : OUT  std_logic_vector(15 downto 0);
         MREQ : OUT  std_logic;
         RM : OUT  std_logic;
         WM : OUT  std_logic;
         BHE : OUT  std_logic;
         BLE : OUT  std_logic;
         PAddr : OUT  std_logic_vector(1 downto 0);
         R0 : IN  std_logic_vector(7 downto 0);
         R1 : IN  std_logic_vector(7 downto 0);
         R2 : IN  std_logic_vector(7 downto 0);
         R3 : IN  std_logic_vector(7 downto 0);
         IR_test : OUT  std_logic_vector(15 downto 0);
         Output : OUT  std_logic_vector(31 downto 0);
         T_test : OUT  std_logic_vector(3 downto 0);
         PREQ : OUT  std_logic;
         RIO : OUT  std_logic;
         WIO : OUT  std_logic;
         Rupdate_test : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal RESET : std_logic := '0';
   signal CLK : std_logic := '0';
   signal Choice : std_logic_vector(1 downto 0) := "10";
   signal R0 : std_logic_vector(7 downto 0) := (others => '0');
   signal R1 : std_logic_vector(7 downto 0) := (others => '0');
   signal R2 : std_logic_vector(7 downto 0) := (others => '0');
   signal R3 : std_logic_vector(7 downto 0) := (others => '0');

	--BiDirs
   signal DBus : std_logic_vector(15 downto 0);

 	--Outputs
   signal ABus : std_logic_vector(15 downto 0);
   signal MREQ : std_logic;
   signal RM : std_logic;
   signal WM : std_logic;
   signal BHE : std_logic;
   signal BLE : std_logic;
   signal PAddr : std_logic_vector(1 downto 0);
   signal IR_test : std_logic_vector(15 downto 0);
   signal Output : std_logic_vector(31 downto 0);
   signal T_test : std_logic_vector(3 downto 0);
   signal PREQ : std_logic;
   signal RIO : std_logic;
   signal WIO : std_logic;
   signal Rupdate_test : std_logic;

   constant CLK_period : time := 10 ns;
 
   type MEM is array(0 to 13) of std_logic_vector(15 downto 0);
   type IOM is array(0 to 3) of std_logic_vector(7 downto 0);
   signal Memory: MEM:=(
						"0000000000000010", -- JMP 02h		0002(1)
						"0000000000000000", -- data			0000
						"0001000000000100", -- JZ R0,04h	1004(2)
						"0000000000000000", -- data			0000
						"0100000100100011", -- MVI R1,23h	4123(3)
						"0101001000000001", -- MOV R2,R1	5201(4)
						"1000001100000001", -- IN R3,[01]   8301(5)
						"0011001100000001", -- ADD R3,R2	3301(6)
						"0010001100000010", -- SUB R3,R2	2302(7)
						"0110001100000011", -- STA R3,03h	6303(8)
						"0111010000000011", -- LDA R4,03h	7403(9)
						"1001010000000001", -- OUT R4,[01]	9401(10)
						"0001010000000000", -- JZ R4,00h	1400(11)
						"0000000000000000"); -- JMP 00h		0000(12)		
	signal IOData: IOM:=("00000000","11001100","00000000","00000000");

BEGIN
	uut: CPU PORT MAP (
		  RESET => RESET,
		  CLK => CLK,
		  Choice => Choice,
		  DBus => DBus,
		  ABus => ABus,
		  MREQ => MREQ,
		  RM => RM,
		  WM => WM,
		  BHE => BHE,
		  BLE => BLE,
		  PAddr => PAddr,
		  R0 => R0,
		  R1 => R1,
		  R2 => R2,
		  R3 => R3,
		  IR_test => IR_test,
		  Output => Output,
		  T_test => T_test,
		  PREQ => PREQ,
		  RIO => RIO,
		  WIO => WIO,
		  Rupdate_test => Rupdate_test
		);

	CLK_process :process
	begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
	end process;

  	process
	begin
		wait for 5 ns;
		RESET <= '1';
		wait for 10 ns;
		RESET <= '0'; 
		wait;
	end process;

	R0 <= IOdata(0);
	R1 <= IOdata(1);
	R2 <= IOdata(2);
	R3 <= IOdata(3);

	process(MREQ, PREQ, DBus, RM, WM)
	begin
		if(MREQ='0' and RM='0')then
			DBus <= Memory(conv_integer(ABus));
		elsif(MREQ='0' and WM='0')then
			Memory(conv_integer(ABus)) <= DBus;
		else
			DBus <= (others=>'Z');
		end if;
	end process;

END;
