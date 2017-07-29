LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY WRManage_test IS
END WRManage_test;
 
ARCHITECTURE behavior OF WRManage_test IS 

    COMPONENT WRManage
    PORT(
         RESET : IN  std_logic;
         CLK : IN  std_logic;
         T : IN  std_logic_vector(3 downto 0);
         IR : IN  std_logic_vector(15 downto 0);
         ALUout : IN  std_logic_vector(7 downto 0);
         Addr : IN  std_logic_vector(15 downto 0);
         Data : INOUT  std_logic_vector(7 downto 0);
         Rtemp : OUT  std_logic_vector(15 downto 0);
         MR : OUT  std_logic;
         MW : OUT  std_logic;
         IOR : OUT  std_logic;
         IOW : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal RESET : std_logic := '0';
   signal CLK : std_logic := '0';
   signal T : std_logic_vector(3 downto 0) := (others => '0');
   signal IR : std_logic_vector(15 downto 0) := (others => '0');
   signal ALUout : std_logic_vector(7 downto 0) := (others => '0');
   signal Addr : std_logic_vector(15 downto 0) := (others => '0');

	--BiDirs
   signal Data : std_logic_vector(7 downto 0);

 	--Outputs
   signal Rtemp : std_logic_vector(15 downto 0);
   signal MR : std_logic;
   signal MW : std_logic;
   signal IOR : std_logic;
   signal IOW : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
	uut: WRManage PORT MAP (
		  RESET => RESET,
		  CLK => CLK,
		  T => T,
		  IR => IR,
		  ALUout => ALUout,
		  Addr => Addr,
		  Data => Data,
		  Rtemp => Rtemp,
		  MR => MR,
		  MW => MW,
		  IOR => IOR,
		  IOW => IOW
		);

	-- Clock process definitions
	CLK_process :process
	begin
		CLK <= '1';
		wait for CLK_period/2;
		CLK <= '0';
		wait for CLK_period/2;
	end process;

	process
	begin
		wait for 10 ns;
		RESET <= '1';
		
		wait for 10 ns;
		RESET <= '0';
		T <= "0010";
		IR <= "0011000000000000"; -- ADD
		ALUout <= "00001111";
		wait for 10 ns;
		T <= "0100";
		wait for 10 ns;
		T <= "1000";

		wait for 10 ns;
		T <= "0010";
		IR <= "0110000000000000"; -- STA
		ALUout <= "00110011";
		Data <= (others=>'Z');
		wait for 10 ns;
		T <= "0100";
		wait for 10 ns;
		T <= "1000";

		wait for 10 ns;
		T <= "0010";
		IR <= "0111000000000000"; -- LDA
		ALUout <= "ZZZZZZZZ";
		Data <= (others=>'Z');
		wait for 10 ns;
		T <= "0100";
		wait for 1 ns;
		Data <= "10101010";
		wait for 9 ns;
		Data <= (others=>'Z');
		T <= "1000";

		wait for 10 ns;
		T <= "0010";
		IR <= "1000000000000000"; -- IN
		ALUout <= "ZZZZZZZZ";
		Data <= (others=>'Z');
		wait for 10 ns;
		T <= "0100";
		wait for 1 ns;
		Data <= "11101110";
		wait for 9 ns;
		Data <= (others=>'Z');
		T <= "1000";

		wait for 10 ns;
		T <= "0010";
		IR <= "1001000000000000"; -- OUT
		ALUout <= "01010101";
		wait for 10 ns;
		T <= "0100";
		wait for 10 ns;
		T <= "1000";

		wait for 10 ns;
		T <= "0010";
		IR <= "0001000000000000"; -- JZ|JMP
		ALUout <= "ZZZZZZZZ";
		Addr <= "0000111100001111";
		wait for 10 ns;
		T <= "0100";
		wait for 10 ns;
		T <= "1000";
		
		wait;
	end process;
END;
