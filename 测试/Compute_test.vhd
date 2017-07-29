LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Compute_test IS
END Compute_test;
 
ARCHITECTURE behavior OF Compute_test IS 

    COMPONENT Compute
    PORT(
         RESET : IN  std_logic;
         enable : IN  std_logic;
         IR : IN  std_logic_vector(15 downto 0);
         Rupdate : IN  std_logic;
         Rnew : IN  std_logic_vector(7 downto 0);
         Raddr : IN  std_logic_vector(2 downto 0);
         RW : OUT  std_logic;
         Addr : OUT  std_logic_vector(15 downto 0);
         ALUout : OUT  std_logic_vector(7 downto 0);
         Regs_out : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal RESET : std_logic := '0';
   signal enable : std_logic := '0';
   signal IR : std_logic_vector(15 downto 0);
   signal Rupdate : std_logic := '0';
   signal Rnew : std_logic_vector(7 downto 0);
   signal Raddr : std_logic_vector(2 downto 0);

 	--Outputs
   signal RW : std_logic;
   signal Addr : std_logic_vector(15 downto 0);
   signal ALUout : std_logic_vector(7 downto 0);
   signal Regs_out : std_logic_vector(63 downto 0);
 
BEGIN
	uut: Compute PORT MAP (
		  RESET => RESET,
		  enable => enable,
		  IR => IR,
		  Rupdate => Rupdate,
		  Rnew => Rnew,
		  Raddr => Raddr,
		  RW => RW,
		  Addr => Addr,
		  ALUout => ALUout,
		  Regs_out => Regs_out
		);

	process
	begin
		wait for 10 ns;
		RESET <= '1';
		
		wait for 10 ns;
		RESET <= '0';
		Rupdate <= '1';
		Raddr <= "001";
		Rnew <= "00001111";
		wait for 10ns;
		Rupdate <= '0';
		
		wait for 10 ns;
		Rupdate <= '1';
		Raddr <= "010";
		Rnew <= "11110000";
		wait for 10 ns;
		Rupdate <= '0';
		
		wait for 10 ns;
		enable <= '1';
		IR <= "0000000010101010";  -- JMP
		wait for 10 ns;
		enable <= '0';

		wait for 9 ns;
		IR <= "0001000101010101";  -- JZ²»Ìø×ª
		wait for 1 ns;
		enable <= '1';
		wait for 10 ns;
		enable <= '0';
		
		wait for 9 ns;
		IR <= "0001000001010101";  -- JZÌø×ª
		wait for 1 ns;
		enable <= '1';
		wait for 10 ns;
		enable <= '0';
		
		wait for 9 ns;
		IR <= "0011001000000001";  -- ADD
		wait for 1 ns;
		enable <= '1';
		wait for 10 ns;
		enable <= '0';
		
		wait for 10 ns;
		IR <= "0010001000000001";  -- SUB
		wait for 1 ns;
		enable <= '1';
		wait for 10 ns;
		enable <= '0';
		
		wait for 10 ns;
		IR <= "0100001101010101";  -- MVI
		wait for 1 ns;
		enable <= '1';
		wait for 10 ns;
		enable <= '0';
		
		wait for 10 ns;
		IR <= "0101000000000010";  -- MOV
		wait for 1 ns;
		enable <= '1';
		wait for 10 ns;
		enable <= '0';
		
		wait for 10 ns;
		IR <= "0110000000000001";  -- STA
		wait for 1 ns;
		enable <= '1';
		wait for 10 ns;
		enable <= '0';
		
		wait for 10 ns;
		IR <= "1001001000000001";  -- OUT
		wait for 1 ns;
		enable <= '1';
		wait for 10 ns;
		enable <= '0';

		wait;
	end process;
END;
