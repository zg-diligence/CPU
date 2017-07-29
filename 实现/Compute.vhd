library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Compute is
	port(
		RESET: in std_logic;
		enable: in std_logic;
		IR: in std_logic_vector(15 downto 0);
		
		-- Ri回写
		Rupdate: in std_logic;
		Rnew: in std_logic_vector(7 downto 0);
		Raddr: in std_logic_vector(2 downto 0);
		
		RW: out std_logic;							-- 跳转信号
		Addr: out std_logic_vector(15 downto 0);	-- 有效地址
		ALUout: out std_logic_vector(7 downto 0);	-- 运算结果
		Regs_out: out std_logic_vector(63 downto 0) -- 寄存器组
		);
end Compute;

architecture Behavioral of Compute is
	type Matrix is array(0 to 7) of std_logic_vector(7 downto 0);
	signal Regs: Matrix;
	signal A, B: std_logic_vector(7 downto 0);
begin
	Regs_out <= Regs(0)&Regs(1)&Regs(2)&Regs(3)&Regs(4)&Regs(5)&Regs(6)&Regs(7);
	
	-- 地址和数据准备,节拍1的下降沿即更新
	Addr <= Regs(7) & IR(7 downto 0);				
	A <= Regs(conv_integer(IR(10 downto 8)));		
	B <= Regs(conv_integer(IR(2 downto 0)));

	-- 实际运算
	process(enable, IR, regs)
	begin
		if(enable'event and enable='1') then
			case IR(15 downto 11) is
				when "00000"=>  -- JMP
					RW <= '1';
				when "00010"=>	-- JZ
					if(A="00000000")then
						RW <= '1'; 
					else
						RW <= '0';
					end if;
				when "00100"=> 	-- SUB
					ALUout <= A - B;						
				when "00110"=>  -- ADD
					ALUout <= A + B;						
				when "01000"=>  -- MVI
					ALUout <= IR(7 downto 0);				
				when "01010"=>  -- MOV
					ALUout <= B;							
				when "01100"|"10010"=> -- STA|OUT
					ALUout <= A;							
				when others=> NULL;
			end case;
		end if;
	end process;

	-- 寄存器更新
	process(RESET, Rupdate, Rnew)
	begin
		if(RESET='1')then
			Regs <= (others=>"00000000");
		elsif(Rupdate'event and Rupdate='1') then
			Regs(conv_integer(Raddr)) <= Rnew;
		end if;
	end process;
end Behavioral;