library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 

entity mid is 
port (
clk : in std_logic;--!
qin : in std_logic_vector(2 downto 0); 
xx: in std_logic_vector(9 downto 0);--!
yy: in std_logic_vector(9 downto 0);--!
hcntin : in std_logic_vector(9 downto 0);--!
vcntin : in std_logic_vector(9 downto 0);--!
borderX : in std_logic_vector(9 downto 0);
borderY : in std_logic_vector(9 downto 0);
qout : out std_logic_vector(2 downto 0);--!
over : out std_logic;
romaddr_control : out std_logic_vector(13 downto 0)--!
); 
end mid;

architecture one of mid is 

signal hcnt : std_logic_vector(9 downto 0);-- 
signal vcnt : std_logic_vector(9 downto 0);-- 
signal qout_temp : std_logic_vector(2 downto 0);--
signal count_temph : std_logic_vector(9 downto 0);
signal count_tempv : std_logic_vector(9 downto 0);

begin
--Assign pin
hcnt <= hcntin;
vcnt <= vcntin;
qout <= qout_temp;

romaddr_control <= (vcnt(6 downto 0)-count_tempv(6 downto 0))&(hcnt(6 downto 0)-count_temph(6 downto 0)); 

process(xx,yy) 
begin 
	if((vcnt = yy) and( hcnt=xx) )then 
		count_temph<=xx;
		count_tempv<=yy;
	end if;
	if((vcnt < yy) or (vcnt > yy+128)) then 
		qout_temp<="000";
	elsif((hcnt>xx)and(hcnt<xx + 128)) then
		qout_temp<=qin;
	else
		qout_temp<="000";
	end if;
	if(vcnt > borderY and vcnt < borderY + 64 and hcnt > 640 - borderX and hcnt < 640 - borderX + 16) then
		qout_temp<="111";
	end if;
	if(640 - borderX > 0 and 640 - borderX < 128) then
		if(yy + 128 > borderY) then
			over <= '1';
		else 
			over <= '0';
		end if;
	else
		over <= '0';
	end if;
end process;

end one;