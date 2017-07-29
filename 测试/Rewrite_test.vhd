LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Rewrite_test IS
END Rewrite_test;
 
ARCHITECTURE behavior OF Rewrite_test IS 

    COMPONENT ReWrite
    PORT(
         T : IN  std_logic_vector(3 downto 0);
         IR : IN  std_logic_vector(15 downto 0);
         Rtemp : IN  std_logic_vector(15 downto 0);
         RW : IN  std_logic;
         PCupdate : OUT  std_logic;
         PCnew : OUT  std_logic_vector(15 downto 0);
         Rupdate : OUT  std_logic;
         Rnew : OUT  std_logic_vector(7 downto 0);
         Raddr : OUT  std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal T : std_logic_vector(3 downto 0) := (others => '0');
   signal IR : std_logic_vector(15 downto 0) := (others => '0');
   signal Rtemp : std_logic_vector(15 downto 0) := (others => '0');
   signal RW : std_logic := '0';

 	--Outputs
   signal PCupdate : std_logic;
   signal PCnew : std_logic_vector(15 downto 0);
   signal Rupdate : std_logic;
   signal Rnew : std_logic_vector(7 downto 0);
   signal Raddr : std_logic_vector(2 downto 0);

BEGIN

   uut: ReWrite PORT MAP (
          T => T,
          IR => IR,
          Rtemp => Rtemp,
          RW => RW,
          PCupdate => PCupdate,
          PCnew => PCnew,
          Rupdate => Rupdate,
          Rnew => Rnew,
          Raddr => Raddr
        );
	process
	begin
		wait for 10 ns;
		T <= "0100";
		IR <= "0001000011110000"; -- JZ
		Rtemp <= "0000000011110000";
		RW <= '0';
		wait for 10 ns;
		T <= "1000";
		wait for 10 ns;
		T <= "0001";
		
		wait for 10 ns;
		T <= "0100";
		IR <= "0000000011110000"; -- JMP
		Rtemp <= "0000000011110000";
		RW <= '1';
		wait for 10 ns;
		T <= "1000";
		wait for 10 ns;
		T <= "0001";

		wait for 10 ns;
		T <= "0100";
		IR <= "0011000111110000"; -- ADD
		Rtemp <= "0000000011110000";
		RW <= '0';
		wait for 10 ns;
		T <= "1000";
		wait for 10 ns;
		T <= "0001";
		
		wait;
	end process;
END;
