library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity WRControl is
	port(
		-- 取指
		IRreq: in std_logic;
		PCout: in std_logic_vector(15 downto 0);
		IRin:  out std_logic_vector(15 downto 0); -- 取回的指令
		
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
end WRControl;

architecture Behavioral of WRControl is
begin
	-- 主存控制
	BLE <= '0' when (IRreq='1' or ((MR='0' or MW='0') and Addr(0)='0')) else '1';
	BHE <= '0' when (IRreq='1' or ((MR='0' or MW='0') and Addr(0)='1')) else '1';
	MREQ <= not(IRreq or (not MR) or (not MW));
	RM <= not(IRreq or (not MR));
	WM <= MW;
	
	-- 外设控制
	PREQ <= not((not IOR) or (not IOW));
	RIO <= IOR;
	WIO <= IOW;

	-- 地址
	ABus <= PCout when IRreq='1' else Addr;
	IOABus <= Addr(1 downto 0);

	-- 主存和外设读
	process(DBus, Addr, R0, R1, R2, R3, IRreq, MR, IOR)
		variable Orders: std_logic_vector(2 downto 0);
	begin
		Orders := (IRreq, MR, IOR);
		case Orders is
			when "111"=> -- 取指
				Data <= (others=>'Z');
				IRin <= DBus;
			when "001"=> -- MR
				if(Addr(0)='0')then
					Data <= DBus(7 downto 0);
				else
					Data <= DBus(15 downto 8);
				end if;
				IRin <= (others=>'Z');
			when "010"=> -- IOR
				case Addr(1 downto 0) is
					when "00"=> Data <= R0;
					when "01"=> Data <= R1;
					when "10"=> Data <= R2;
					when others=> Data <= R3;
				end case;
				IRin <= (others=>'Z');
			when others=>
				Data <= (others=>'Z');
				IRin <= (others=>'Z');
		end case;
	end process;

	-- 主存和外设写
	process(DBus, Data, Addr, IRreq, MW, IOW)
		variable Orders: std_logic_vector(2 downto 0);
	begin
		Orders := (IRreq, MW, IOW);
		case Orders is
			when "001"=> -- MW
				if(Addr(0)='0')then
					DBus <= "00000000"&Data;
				else
					DBus <= Data&"00000000";
				end if;
				W0 <= (others=>'Z'); W1 <= (others=>'Z'); W2 <= (others=>'Z'); W3 <= (others=>'Z');
			when "010"=> -- IOW
				DBus <= (others=>'Z');
				case Addr(1 downto 0) is
					when "00"=> 
						W0 <= Data; W1 <= (others=>'Z'); W2 <= (others=>'Z'); W3 <= (others=>'Z');
					when "01"=> 
						W1 <= Data; W0 <= (others=>'Z'); W2 <= (others=>'Z'); W3 <= (others=>'Z');
					when "10"=>  
						W2 <= Data; W0 <= (others=>'Z'); W1 <= (others=>'Z'); W3 <= (others=>'Z');
					when others=>
						W3 <= Data; W0 <= (others=>'Z'); W1 <= (others=>'Z'); W2 <= (others=>'Z');
				end case;
			when others=>
				DBus <= (others=>'Z');
				W0 <= (others=>'Z'); W1 <= (others=>'Z'); W2 <= (others=>'Z'); W3 <= (others=>'Z');
		end case;
	end process;
end Behavioral;