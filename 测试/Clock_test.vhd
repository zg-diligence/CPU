LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Clock_test IS
END Clock_test;
 
ARCHITECTURE behavior OF Clock_test IS 

    COMPONENT Clock
    PORT(
         CLK : IN  std_logic;
         RESET : IN  std_logic;
         T : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';

 	--Outputs
   signal T : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
	uut: Clock PORT MAP (
		  CLK => CLK,
		  RESET => RESET,
		  T => T
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
		wait for 10 ns;
		RESET <= '1';
		wait for 10 ns;
		RESET <= '0';
		wait;
	end process;
END;
