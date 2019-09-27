library IEEE;
use IEEE.std_logic_1164.all;
use	IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga640480 is
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
		if(hcnt < 800) then				 
			hcnt <= hcnt + 1;
		else
			hcnt <= (others => '0');
		end if;
	end if;	
end process;

--this is Vertical counter 
process(clk) begin
	if (rising_edge(clk)) then
		if (hcnt = 640+8 ) then
			if(vcnt < 525) then	   		    
				vcnt <= vcnt + 1;
			else
				vcnt <= (others => '0');			
			end if;
		end if;	
	end if;	
end process;

--this is hs  pulse
process(clk) begin
	if (rising_edge(clk)) then
		if((hcnt>= 640+8+8) and (hcnt<640+8+8+96 )) then	
			hs <= '0';
		else
			hs <= '1';
		end if;
	end if;
end process;

--this is vs  pulse
process(vcnt) begin
	if ((vcnt >= 480+8+2) and (vcnt < 480+8+2+2)) then	
			vs <= '0';
		else
			vs <= '1';
	end if;
end process;

process(clk) begin
	if (rising_edge(clk)) then
		if(hcnt > 0 and hcnt < 640 and vcnt > 0 and vcnt < 480) then
			r<=rgbin(2);
			g<=rgbin(1);
			b<=rgbin(0);
		else
			r<='0';
			g<='0';
			b<='0';
		end if;
	end if;
end process;


end ONE;