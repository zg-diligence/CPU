library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Clock is
	port(
		CLK: in std_logic;
		RESET: in std_logic;
		T: OUT std_logic_vector(3 downto 0)
		);
end Clock;

architecture Behavioral of Clock is
begin
	process(CLK, RESET)
		variable nT: std_logic_vector(3 downto 0);
	begin
		if(RESET='1') then
			T <= "0000";
			nT := "0001";
		elsif(CLK'event and CLK='1') then
			case nT is
				when "0001"=> T <= "0001"; nT := "0010";
				when "0010"=> T <= "0010"; nT := "0100";
				when "0100"=> T <= "0100"; nT := "1000";
				when "1000"=> T <= "1000"; nT := "0001";
				when others=>NULL;
			end case;
		end if;
	end process;
end Behavioral;

