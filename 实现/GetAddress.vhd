library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity GetAddress is
	port(
		CLK: in std_logic;
		RESET: in std_logic;
		T: in std_logic_vector(3 downto 0);
		
		-- PC��д
		PCupdate: in std_logic;
		PCnew: in std_logic_vector(15 downto 0);
		
		-- ��ȡ��ָ������
		IRin: in std_logic_vector(15 downto 0); 	
		IRout: out std_logic_vector(15 downto 0);
		
		-- ȡָ
		PCout: out std_logic_vector(15 downto 0);
		IRreq: out std_logic
		);
end GetAddress;

architecture Behavioral of GetAddress is
	signal PC: std_logic_vector(15 downto 0);
begin
	-- ȡָ����
	IRreq <= T(0);

	-- ȡָ��ַ
	process(T(0))
	begin	-- ��ֱ��д��תʱ����4���仯.
		if(T(0)'event and T(0)='1')then
			PCout <= PC; 
		end if;
	end process;

	-- ȡ�ص�ָ���͵�����ģ��
	process(CLK, T, IRin)
	begin  -- ����1ʱ���½��ش���.
		if(CLK'event and CLK='0' and T="0001")then
			IRout <= IRin;
		end if;
	end process;

	-- PC����
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