library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CPU is
	port(
		RESET: in std_logic;
		CLK: in std_logic;
		Choice: in std_logic_vector(1 downto 0);

		-- 主存
		DBus: inout std_logic_vector(15 downto 0);
		ABus: out std_logic_vector(15 downto 0);
		MREQ: out std_logic;
		RM: out std_logic;
		WM: out std_logic;
		BHE: out std_logic;
		BLE: out std_logic;
		
		-- 外设
		PAddr: out std_logic_vector(1 downto 0); -- A[7..6]
		R0: in std_logic_vector(7 downto 0);	-- K0
		R1: in std_logic_vector(7 downto 0);	-- K1
		R2: in std_logic_vector(7 downto 0);	-- K2
		R3: in std_logic_vector(7 downto 0);	-- K3
		
		-- 数码管
		IR_test: out std_logic_vector(15 downto 0);
		Output: out std_logic_vector(31 downto 0);

		-- B[7..1]
		T_test: out std_logic_vector(3 downto 0);		
		PREQ: out std_logic;
		RIO: out std_logic;
		WIO: out std_logic;
		Rupdate_test: out std_logic
		);
end CPU;

architecture Behavioral of CPU is
	component Clock is
	port(
		CLK: in std_logic;
		RESET: in std_logic;
		T: OUT std_logic_vector(3 downto 0)
		);
	end component;
	
	component GetAddress is
	port(
		T: in std_logic_vector(3 downto 0);
		CLK: in std_logic;
		RESET: in std_logic;
		
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
	end component;

	component Compute is
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
	end component;
	
	component WRManage is
	port(
		RESET: in std_logic;
		CLK: in std_logic;
		T: in std_logic_vector(3 downto 0);
		IR: in std_logic_vector(15 downto 0);
		
		Addr: in std_logic_vector(15 downto 0);   -- 有效地址
		ALUout: in std_logic_vector(7 downto 0);  -- 运算结果
		Data: inout std_logic_vector(7 downto 0); -- 读写数据
		Rtemp: out std_logic_vector(15 downto 0); -- Ri回写数据
		
		-- 读写命令
		MR: out std_logic;
		MW: out std_logic;
		IOR: out std_logic;
		IOW: out std_logic
		);
	end component;
	
	component ReWrite is
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
	end component;
	
	component WRControl is
		port(
		-- 取指
		IRreq: in std_logic;
		PCout: in std_logic_vector(15 downto 0);
		IRin:  out std_logic_vector(15 downto 0);
		
		-- 读写命令
		MR: in std_logic;
		MW: in std_logic;
		IOR: in std_logic;
		IOW: in std_logic;
		
		-- 读写地址、数据
		Addr: in std_logic_vector(15 downto 0);
		Data: inout std_logic_vector(7 downto 0);
		
		-- 主存
		ABus: out std_logic_vector(15 downto 0);
		DBus: inout std_logic_vector(15 downto 0);
		MREQ: out std_logic;
		WM: out std_logic;
		RM: out std_logic;
		BHE: out std_logic;
		BLE: out std_logic;
		
		-- 外设
		IOABus: out std_logic_vector(1 downto 0);
		R0: in std_logic_vector(7 downto 0);
		R1: in std_logic_vector(7 downto 0);
		R2: in std_logic_vector(7 downto 0);
		R3: in std_logic_vector(7 downto 0);
		W0: out std_logic_vector(7 downto 0);
		W1: out std_logic_vector(7 downto 0);
		W2: out std_logic_vector(7 downto 0);
		W3: out std_logic_vector(7 downto 0);
		PREQ: out std_logic;
		RIO: out std_logic;
		WIO: out std_logic
		);
	end component;
	
	signal T: std_logic_vector(3 downto 0);

	signal PCupdate: std_logic;
	signal PCnew: std_logic_vector(15 downto 0);
	signal Rupdate: std_logic;
	signal Rnew: std_logic_vector(7 downto 0);
	signal Raddr: std_logic_vector(2 downto 0);
	
	signal IRin: std_logic_vector(15 downto 0); 
	signal IR: std_logic_vector(15 downto 0); 
	signal PCout: std_logic_vector(15 downto 0); 
	signal IRreq: std_logic;
	
	signal RW: std_logic;
	signal Addr: std_logic_vector(15 downto 0);
	signal ALUout: std_logic_vector(7 downto 0);
	signal Data: std_logic_vector(7 downto 0);
	signal Rtemp: std_logic_vector(15 downto 0);
	
	signal MR: std_logic;
	signal MW: std_logic;
	signal IOR: std_logic;
	signal IOW: std_logic;
	
	signal IOWrite: std_logic_vector(31 downto 0);
	signal Regs_data: std_logic_vector(63 downto 0);
begin
	u1: Clock port map(
		T => T,
		RESET => RESET,
		CLK => CLK);
	
    u2: GetAddress PORT MAP (
		T => T,
		CLK => CLK,
		RESET => RESET,
		PCupdate => PCupdate,
		PCnew => PCnew,
		IRin => IRin,
		IRout => IR,
		PCout => PCout,
		IRreq => IRreq);
		
    u3: Compute PORT MAP (
		RESET => RESET,
		enable => T(1),
		IR => IR,
		Rupdate => Rupdate,
		Rnew => Rnew,
		Raddr => Raddr,
		RW => RW,
		Addr => Addr,
		ALUout => ALUout,
		Regs_out => Regs_data
		);
		
    u4: WRManage PORT MAP (
		RESET => RESET,
		CLK => CLK,
		T => T,
		IR => IR,
		Addr => Addr,
		ALUout => ALUout,
		Data => Data,
		Rtemp => Rtemp,
		MR => MR,
		MW => MW,
		IOR => IOR,
		IOW => IOW);

	u5: ReWrite PORT MAP (
		T => T,
		IR => IR,
		Rtemp => Rtemp,
		RW => RW,
		PCupdate => PCupdate,
		PCnew => PCnew,
		Rupdate => Rupdate,
		Rnew => Rnew,
		Raddr => Raddr);
		
	u6: WRControl PORT MAP (
		IRreq => IRreq,
		PCout => PCout,
		IRin => IRin,
		MR => MR,
		MW => MW,
		IOR => IOR,
		IOW => IOW,
		Addr => Addr,
		Data => Data,
		ABus => ABus,
		DBus => DBus,
		MREQ => MREQ,
		WM => WM,
		RM => RM,
		BHE => BHE,
		BLE => BLE,
		IOABus => Paddr,
		R0 => R0,
		R1 => R1,
		R2 => R2,
		R3 => R3,
		W0 => IOWrite(31 downto 24),
		W1 => IOWrite(23 downto 16),
		W2 => IOWrite(15 downto 8),
		W3 => IOWrite(7 downto 0),
		PREQ => PREQ,
		RIO => RIO,
		WIO => WIO);

	with Choice select
	Output <=
		IOWrite 							when "00",
		ALUout&Data&Rtemp(7 downto 0)&Rnew	when "01",
		Regs_data(63 downto 32) 			when "10",
		Regs_data(31 downto 0) 				when "11",
		(others=>'0') 						when others;

	T_test <= T;
	IR_test <= IR;
	Rupdate_test <= Rupdate;
end Behavioral;