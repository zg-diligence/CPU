library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity WRManage is
	port(
		RESET: in std_logic;
		CLK: in std_logic;
		T: in std_logic_vector(3 downto 0);
		IR: in std_logic_vector(15 downto 0);      -- 指令
		
		ALUout: in std_logic_vector(7 downto 0);   -- 运算结果
		Addr: in std_logic_vector(15 downto 0);    -- 有效地址
		Data: inout std_logic_vector(7 downto 0);  -- 读写数据
		Rtemp: out std_logic_vector(15 downto 0);  -- Ri回写数据
		
		-- 读写命令
		MR: out std_logic;
		MW: out std_logic;
		IOR: out std_logic;
		IOW: out std_logic
		);
end WRManage;

architecture Behavioral of WRManage is
begin
	-- 向访存控制模块发送读写信号和数据
	process(RESET, T, T(2), IR)
	begin
		if(RESET='1' or T(3)='1')then
			MR <= '1';
			MW <= '1';
			IOR <= '1';
			IOW <= '1';
		elsif(T(2)'event and T(2)='1')then
			case IR(15 downto 11) is
				when "01110"=>		-- LDA
					MR <= '0';
					Data <= (others=>'Z');
				when "01100"=>		-- STA
					MW <= '0';
					Data <= ALUout;
				when "10000"=>		-- IN
					IOR <= '0';
					Data <= (others=>'Z');
				when "10010"=>		-- OUT
					IOW <= '0';
					Data <= ALUout;
				when others=>NULL;
			end case;
		end if;
	end process;
	
	-- 更新Rtmp,节拍3时钟下降沿
	process(CLK, ALUout, Data, Addr)
	begin
		if(CLK'event and CLK='0' and T="0100")then
			case IR(15 downto 11) is
				when "00100"|"00110"|"01000"|"01010"=> -- SUB、ADD、MVI、MOV
					Rtemp <= "00000000"&ALUout;
				when "01110"|"10000"=>				   -- LDA、IN
					Rtemp <= "00000000"&Data;
				when "00000"|"00010"=>				   -- JZ、JMP
					Rtemp <= Addr;
				when others=> NULL;
			end case;
		end if;
	end process;
end Behavioral;