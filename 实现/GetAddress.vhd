library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity GetAddress is
	port(
		CLK: in std_logic;
		RESET: in std_logic;
		T: in std_logic_vector(3 downto 0);
		
		-- PC回写
		PCupdate: in std_logic;
		PCnew: in std_logic_vector(15 downto 0);
		
		-- 读取的指令内容
		IRin: in std_logic_vector(15 downto 0); 	
		IRout: out std_logic_vector(15 downto 0);
		
		-- 取指
		PCout: out std_logic_vector(15 downto 0);
		IRreq: out std_logic
		);
end GetAddress;

architecture Behavioral of GetAddress is
	signal PC: std_logic_vector(15 downto 0);
begin
	-- 取指请求
	IRreq <= T(0);

	-- 取指地址
	process(T(0))
	begin	-- 若直接写跳转时节拍4即变化.
		if(T(0)'event and T(0)='1')then
			PCout <= PC; 
		end if;
	end process;

	-- 取回的指令送到其余模块
	process(CLK, T, IRin)
	begin  -- 节拍1时钟下降沿传送.
		if(CLK'event and CLK='0' and T="0001")then
			IRout <= IRin;
		end if;
	end process;

	-- PC更新
	process(T(1), RESET, PCupdate, PCnew)
	begin
		if(RESET='1')then
			PC <= "0000000000000000";
		elsif(PCupdate='1')then
			PC <= PCnew;
		elsif(T(1)'event and T(1)='1')then
			PC <= PC + 1;
		end if;
	end process;
end Behavioral;