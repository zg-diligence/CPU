library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ReWrite is
	port(
		T: in std_logic_vector(3 downto 0);
		IR: in std_logic_vector(15 downto 0);

		Rtemp: in std_logic_vector(15 downto 0);-- Ri回写数据
		RW: in std_logic;						-- 跳转信号
		
		-- PC回写
		PCupdate: out std_logic;
		PCnew: out std_logic_vector(15 downto 0);
		
		-- Ri回写
		Rupdate: out std_logic;
		Rnew: out std_logic_vector(7 downto 0);
		Raddr: out std_logic_vector(2 downto 0)
		);
end ReWrite;

architecture Behavioral of ReWrite is
begin
	-- 回写数据
	PCnew <= Rtemp;
	Rnew <= Rtemp(7 downto 0);
	Raddr <= IR(10 downto 8);

	-- 回写命令
	process(T, T(3), IR, Rtemp)
	begin
		if(T(0)='1')then
			Rupdate <= '0';
			PCupdate <= '0';
		elsif(T(3)'event and T(3)='1')then
			case IR(15 downto 11) is
				when "00000"|"00010"=> -- JZ、JMP
					if(RW='1')then
						PCupdate <= '1';
					else
						PCupdate <= '0';
					end if;
				when "00110"|"00100"|"01010"|"01000"|"10000"|"01110"=>	
					Rupdate <= '1'; -- ADD|SUB|MOV|MVI|IN|LDA
				when others=>NULL;
			end case;
		end if;
	end process;
end Behavioral;