LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY WRControl_test IS
END WRControl_test;
 
ARCHITECTURE behavior OF WRControl_test IS 

    COMPONENT WRControl
    PORT(
         IRreq : IN  std_logic;
         PCout : IN  std_logic_vector(15 downto 0);
         IRin : OUT  std_logic_vector(15 downto 0);
         MR : IN  std_logic;
         MW : IN  std_logic;
         IOR : IN  std_logic;
         IOW : IN  std_logic;
         Addr : IN  std_logic_vector(15 downto 0);
         Data : INOUT  std_logic_vector(7 downto 0);
         ABus : OUT  std_logic_vector(15 downto 0);
         DBus : INOUT  std_logic_vector(15 downto 0);
         MREQ : OUT  std_logic;
         WM : OUT  std_logic;
         RM : OUT  std_logic;
         BHE : OUT  std_logic;
         BLE : OUT  std_logic;
         IOABus : OUT  std_logic_vector(1 downto 0);
         R0 : IN  std_logic_vector(7 downto 0);
         R1 : IN  std_logic_vector(7 downto 0);
         R2 : IN  std_logic_vector(7 downto 0);
         R3 : IN  std_logic_vector(7 downto 0);
         W0 : OUT  std_logic_vector(7 downto 0);
         W1 : OUT  std_logic_vector(7 downto 0);
         W2 : OUT  std_logic_vector(7 downto 0);
         W3 : OUT  std_logic_vector(7 downto 0);
         PREQ : OUT  std_logic;
         RIO : OUT  std_logic;
         WIO : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal IRreq : std_logic := '0';
   signal PCout : std_logic_vector(15 downto 0) := (others => '0');
   signal MR : std_logic := '1';
   signal MW : std_logic := '1';
   signal IOR : std_logic := '1';
   signal IOW : std_logic := '1';
   signal Addr : std_logic_vector(15 downto 0) := (others => '0');
   signal R0 : std_logic_vector(7 downto 0) := (others => '0');
   signal R1 : std_logic_vector(7 downto 0) := (others => '0');
   signal R2 : std_logic_vector(7 downto 0) := (others => '0');
   signal R3 : std_logic_vector(7 downto 0) := (others => '0');

	--BiDirs
   signal Data : std_logic_vector(7 downto 0);
   signal DBus : std_logic_vector(15 downto 0);

 	--Outputs
   signal IRin : std_logic_vector(15 downto 0);
   signal ABus : std_logic_vector(15 downto 0);
   signal MREQ : std_logic;
   signal WM : std_logic;
   signal RM : std_logic;
   signal BHE : std_logic;
   signal BLE : std_logic;
   signal IOABus : std_logic_vector(1 downto 0);
   signal W0 : std_logic_vector(7 downto 0);
   signal W1 : std_logic_vector(7 downto 0);
   signal W2 : std_logic_vector(7 downto 0);
   signal W3 : std_logic_vector(7 downto 0);
   signal PREQ : std_logic;
   signal RIO : std_logic;
   signal WIO : std_logic;

   type MEM is array(0 to 13) of std_logic_vector(15 downto 0);
   type IOM is array(0 to 3) of std_logic_vector(7 downto 0);
   signal Memory: MEM:=(
						"0000000000000010", -- JMP		0002
						"0000000000000000", -- data		0000
						"0001000000000100", -- JZ R1	1004
						"0000000000000000", -- data		0000
						"0100000100100011", -- MVI		4126
						"0101001000000001", -- MOV		5201
						"1000001100000001", -- IN       8302
						"0011001100000010", -- ADD		3301
						"0010001100000001", -- SUB		2302
						"0110010000000011", -- STA		6303
						"0111010100000011", -- LDA		7403
						"1001010100000001", -- OUT		9401
						"0001010100000000", -- JZ		1400
						"0000000000000000"); -- JMP		0000		
	signal IOData: IOM:=("00000000","01111111","00000000","00000000");
	
BEGIN
	uut: WRControl PORT MAP (
		  IRreq => IRreq,
		  PCout => PCout,
		  IRin => IRin,
		  MR => MR,
		  MW => MW,
		  IOR => IOR,
		  IOW => IOW,
		  Addr => Addr,
		  Data => Data,
		  ABus => ABus,
		  DBus => DBus,
		  MREQ => MREQ,
		  WM => WM,
		  RM => RM,
		  BHE => BHE,
		  BLE => BLE,
		  IOABus => IOABus,
		  R0 => R0,
		  R1 => R1,
		  R2 => R2,
		  R3 => R3,
		  W0 => W0,
		  W1 => W1,
		  W2 => W2,
		  W3 => W3,
		  PREQ => PREQ,
		  RIO => RIO,
		  WIO => WIO
		);
 
	process
	begin
		wait for 10 ns;
		IRreq <= '1';
		wait for 10 ns;
		IRreq <= '0';

		wait for 10 ns;
		MR <= '0';
		Addr <= "0000000000000100";
		wait for 10 ns;
		MR <= '1';

		wait for 10 ns;
		MW <= '0';
		Data <= "00001111";
		Addr <= "0000000000000001";
		wait for 10 ns;
		MW <= '1';
		
		wait for 10 ns;
		IOW <= '0';
		Data <= "10101010";
		Addr <= "0000000000000010";
		wait for 10 ns;
		IOW <= '1';

		wait for 10 ns;
		Data <= (others=>'Z');
		IOR <= '0';
		Addr <= "0000000000000001";
		wait for 10 ns;
		IOR <= '1';

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
			DBus <= (others=>'Z');
		else
			DBus <= (others=>'Z');
		end if;
	end process;

END;
