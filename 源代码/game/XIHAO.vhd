LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY XIHAO IS
PORT(   	clk: 					IN STD_LOGIC;
			vga_h_sync, vga_v_sync: OUT STD_LOGIC;
			inDisplayArea 		:    OUT STD_LOGIC;
			CounterX	         :    OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
			CounterY			:   OUT STD_LOGIC_VECTOR(8 DOWNTO 0));
END XIHAO;
ARCHITECTURE BEHAV OF XIHAO IS
SIGNAL CounterXmaxed,inDisplayArea1 :std_logic ;
signal  vga_HS, vga_VS :	std_logic ;
--SIGNAL  inDisplayArea  :	STD_LOGIC;
SIGNAL  CounterX1	         :    STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL  CounterY1			:    STD_LOGIC_VECTOR(8 DOWNTO 0);
BEGIN
CounterXmaxed <= '1' WHEN CounterX1=767 ELSE '0';
process(clk)
begin
	IF CLK'EVENT AND CLK='1' THEN
		if CounterXmaxed='1'  THEN
			CounterX1 <= "0000000000";CounterY1 <= CounterY1 + 1;
		else
			CounterX1 <= CounterX1 + 1;
		end if;

		if(inDisplayArea1='0')  THEN
			IF (CounterXmaxed='1')  and  (CounterY1<480) and (CounterY1>30)  THEN
				inDisplayArea1 <= '1';
			ELSE 
				inDisplayArea1 <= '0';
			END IF;
		else
			IF  not(CounterX1=639) THEN

				inDisplayArea1 <= '1';
			ELSE
				inDisplayArea1 <= '0';
			END IF;
		END IF;
	END IF ;
end process;
inDisplayArea<=inDisplayArea1 when CounterX1>50 else '0';
vga_HS <= '1'  WHEN CounterX1(9 downto 4)="101101"  ELSE '0';
vga_VS <= '1'  WHEN  CounterY1=500 ELSE '0' ;
vga_h_sync <= not vga_HS;
vga_v_sync <= not vga_VS;
CounterX<=CounterX1;
CounterY<=CounterY1;
end BEHAV;