
library IEEE;
use IEEE.std_logic_1164.all;
use	IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga640480 is  --display module
	port (			  
		clk	: in STD_LOGIC;
		hs	: out STD_LOGIc;
		vs	: out STD_LOGIc;
		r 	: out STD_LOGIC;
		g 	: out STD_LOGIC;
		b 	: out STD_LOGIC;
		rgbin	: in std_logic_vector(2 downto 0);
		hcntout	: out std_logic_vector(9 downto 0);
		vcntout	: out std_logic_vector(9 downto 0)
	);
end vga640480;

architecture ONE of vga640480 is

signal hcnt	: std_logic_vector(9 downto 0);	
signal vcnt	: std_logic_vector(9 downto 0);	

begin

-- Assign pin
hcntout <= hcnt;
vcntout <= vcnt;

--this is Horizonal counter	
process(clk) begin
	if (rising_edge(clk)) then
		if(hcnt < 928) then				 
			hcnt <= hcnt + 1;
		else
			hcnt <= (others => '0');
		end if;
	end if;	
end process;

--this is Vertical counter 
process(clk) begin
	if (rising_edge(clk)) then
		if (hcnt = 720+14 ) then
			if(vcnt < 448) then	   		    
				vcnt <= 	vcnt + 1;
			else
				vcnt <= (others => '0');			
			end if;
		end if;	
	end if;	
end process;

--this is hs  pulse
process(clk) begin
	if (rising_edge(clk)) then
		if((hcnt>= 720+28) and (hcnt<720+28+112 )) then	
			hs <= '0';
		else
			hs <= '1';
		end if;
	end if;
end process;

--this is vs  pulse
process(vcnt) begin
	if ((vcnt >= 400+10) and (vcnt < 400+10+3)) then	
			vs <= '0';
		else
			vs <= '1';
	end if;
end process;

process(clk) begin
	if (rising_edge(clk)) then
		if (hcnt<720 and vcnt<400) then
			r<=rgbin(2);
			g<=rgbin(1);
			b<=rgbin(0);--rgbin(0);
		end if;
	end if;
end process;


end ONE;


