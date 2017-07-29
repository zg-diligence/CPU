LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY GetAddress_test IS
END GetAddress_test;
 
ARCHITECTURE behavior OF GetAddress_test IS 

    COMPONENT GetAddress
    PORT(
         CLK : IN  std_logic;
         RESET : IN  std_logic;
         T : IN  std_logic_vector(3 downto 0);
         PCupdate : IN  std_logic;
         PCnew : IN  std_logic_vector(15 downto 0);
         IRin : IN  std_logic_vector(15 downto 0);
         IRout : OUT  std_logic_vector(15 downto 0);
         PCout : OUT  std_logic_vector(15 downto 0);
         IRreq : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal T : std_logic_vector(3 downto 0);
   signal PCupdate : std_logic := '0';
   signal PCnew : std_logic_vector(15 downto 0);
   signal IRin : std_logic_vector(15 downto 0);

 	--Outputs
   signal IRout : std_logic_vector(15 downto 0);
   signal PCout : std_logic_vector(15 downto 0);
   signal IRreq : std_logic;

   constant CLK_period : time := 10 ns;
 
BEGIN
	uut: GetAddress PORT MAP (
		  CLK => CLK,
		  RESET => RESET,
		  T => T,
		  PCupdate => PCupdate,
		  PCnew => PCnew,
		  IRin => IRin,
		  IRout => IRout,
		  PCout => PCout,
		  IRreq => IRreq
		);

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
		T <= "0001";
		IRin <= "0000111100001111";

		wait for 10 ns;
		T <= "0010";
		
		wait for 10 ns;
		T <= "0100";

		wait for 10 ns;
		T <= "1000";
		PCupdate <= '1';
		PCnew <= "1111000011110000";
		
		wait for 10 ns;
		T <= "0001";
		PCupdate <= '0';
		
		wait;
	end process;


END;
