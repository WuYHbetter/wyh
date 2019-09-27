LIBRARY IEEE;   -- 显示器 彩条 发生器
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY COLOR IS
    PORT (  
         CLK, MD : IN STD_LOGIC;
        HS, VS, R, G, B : OUT STD_LOGIC  ); -- 行场同步/红，绿，兰
END COLOR;
ARCHITECTURE behav OF COLOR IS
    SIGNAL HS1,VS1,FCLK,CCLK      : STD_LOGIC;
    SIGNAL MMD : STD_LOGIC_VECTOR(1 DOWNTO 0);-- 方式选择
    SIGNAL FS : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL CC : STD_LOGIC_VECTOR(4 DOWNTO 0); --行同步/横彩条生成
    SIGNAL LL : STD_LOGIC_VECTOR(8 DOWNTO 0); --场同步/竖彩条生成
    SIGNAL GRBX : STD_LOGIC_VECTOR(3 DOWNTO 1);-- X横彩条
    SIGNAL GRBY : STD_LOGIC_VECTOR(3 DOWNTO 1);-- Y竖彩条    
    SIGNAL GRBZ : STD_LOGIC_VECTOR(3 DOWNTO 1);-- Z竖彩条
    SIGNAL GRBP : STD_LOGIC_VECTOR(3 DOWNTO 1);
    SIGNAL GRB  : STD_LOGIC_VECTOR(3 DOWNTO 1);
BEGIN
GRB(2) <= (GRBP(2) XOR MD) AND HS1 AND VS1;
GRB(3) <= (GRBP(3) XOR MD) AND HS1 AND VS1;
GRB(1) <= (GRBP(1) XOR MD) AND HS1 AND VS1;
PROCESS( MD )
BEGIN
	IF MD'EVENT AND MD = '0' THEN
	   IF MMD = "11" THEN  MMD <= "00";
		ELSE   MMD <= MMD + 1;               --三种模式
		END IF;
	END IF;    
END PROCESS;
PROCESS( MMD )
BEGIN
	IF MMD = "00" THEN     GRBP <= GRBX;     -- 选择横彩条
	ELSIF MMD = "01" THEN  GRBP <= GRBY;     -- 选择竖彩条
	ELSIF MMD = "10" THEN  GRBP <= GRBX XOR GRBY; --产生棋盘格
	ELSIF MMD = "11" THEN  GRBP <= GRBZ;
	 ELSE
		GRBP <= "000";
	END IF;
END PROCESS;
PROCESS( CLK )
BEGIN
	IF CLK'EVENT AND CLK = '1' THEN -- 12MHz 13分频
		IF FS = 12 THEN FS <= "0000";
		ELSE
			FS <= (FS + 1);
		END IF;
	END IF;
END PROCESS;
FCLK <= FS(3);
PROCESS( FCLK )
BEGIN
	IF FCLK'EVENT AND FCLK = '1' THEN
		IF CC = 29 THEN  CC <= "00000";
		ELSE
			CC <= CC + 1;
		END IF;
	END IF;
END PROCESS;
CCLK <= CC(4);
PROCESS( CCLK )
BEGIN
	IF CCLK'EVENT AND CCLK = '0' THEN
		IF LL = 481 THEN  LL <= "000000000";
		ELSE
			LL <= LL + 1;
		END IF;
	END IF;
END PROCESS;
PROCESS( CC,LL )
BEGIN
	IF CC > 23 THEN  HS1 <= '0';  --行同步
	ELSE
		HS1 <= '1';
	END IF;
	IF LL > 479 THEN  VS1 <= '0'; --场同步
	ELSE
		VS1 <= '1';
	END IF;
END PROCESS;
PROCESS(CC, LL)  
BEGIN
	   IF CC < 3  THEN GRBX <= "111";  -- 横彩条
	ELSIF CC < 6  THEN GRBX <= "110";
	ELSIF CC < 9  THEN GRBX <= "101";
	ELSIF CC < 12 THEN GRBX <= "100";
	ELSIF CC < 15 THEN GRBX <= "011";
	ELSIF CC < 18 THEN GRBX <= "010";
	ELSIF CC < 21 THEN GRBX <= "001";
	 ELSE GRBX <= "000";
	   END IF;
	   IF LL <  60 THEN GRBY <= "111";  -- 竖彩条
	ELSIF LL < 120 THEN GRBY <= "110";
	ELSIF LL < 180 THEN GRBY <= "101";
	ELSIF LL < 240 THEN GRBY <= "100";
	ELSIF LL < 300 THEN GRBY <= "011";
	ELSIF LL < 360 THEN GRBY <= "010";
	ELSIF LL < 420 THEN GRBY <= "001";
	ELSE GRBY <= "000";
	   END IF;
	   ----2
	   if (cc>-1+3 and cc<3+3 and ll>30 and ll<50) then grbz<="001";
		elsif (cc>-1+3 and cc<3+3 and ll>85 and ll<105) then grbz<="001";
		elsif (cc>-1+3 and cc<3+3 and ll>140 and ll<160) then grbz<="001";
		elsif (cc>1+3 and cc<3+3 and ll>30 and ll<105) then grbz<="001";
		elsif (cc>-1+3 and cc<1+3 and ll>85 and ll<160) then grbz<="001";
---0
		elsif (cc>4+3 and cc<8+3 and ll>30 and ll<50) then grbz<="010";
		elsif (cc>4+3 and cc<8+3 and ll>140 and ll<160) then grbz<="010";
		elsif (cc>4+3 and cc<6+3 and ll>30 and ll<160) then grbz<="010";
		elsif (cc>6+3 and cc<8+3 and ll>30 and ll<160) then grbz<="010";
--1-
		elsif (cc>9+3 and cc<11+3 and ll>30 and ll<160) then grbz<="011";
---7
		elsif (cc>12+3 and cc<16+3 and ll>30 and ll<50) then grbz<="100";
		elsif (cc>14+3 and cc<16+3 and ll>30 and ll<160) then grbz<="100";
--2	
		elsif (cc>17+3 and cc<21+3 and ll>30 and ll<50) then grbz<="101";
		elsif (cc>17+3 and cc<21+3 and ll>85 and ll<105) then grbz<="101";
		elsif (cc>17+3 and cc<21+3 and ll>140 and ll<160) then grbz<="101";
		elsif (cc>19+3 and cc<21+3 and ll>30 and ll<105) then grbz<="101";
		elsif (cc>17+3 and cc<19+3 and ll>85 and ll<160) then grbz<="101";
--1
		elsif (cc>1+3 and cc<3+3 and ll>170 and ll<300) then grbz<="110";
--2
		elsif (cc>4+3 and cc<8 +3 and ll>170 and ll<190) then grbz<="111";
		elsif (cc>4+3 and cc<8+3 and ll>225 and ll<245) then grbz<="111";
		elsif (cc>4+3 and cc<8+3 and ll>280 and ll<300) then grbz<="111";
		elsif (cc>6+3 and cc<8+3 and ll>170 and ll<245) then grbz<="111";
		elsif (cc>4+3 and cc<6+3 and ll>225 and ll<300) then grbz<="111";
--1
		elsif (cc>9+3 and cc<11+3 and ll>170 and ll<300) then grbz<="001";
--4
		elsif (cc>12+3 and cc<14+3 and ll>170 and ll<245) then grbz<="010";
		elsif (cc>12+3 and cc<16+3 and ll>225 and ll<245) then grbz<="010";
		elsif (cc>14+3 and cc<16+3 and ll>170 and ll<300) then grbz<="010";

--4
		elsif (cc>17+3 and cc<19+3 and ll>170 and ll<245) then grbz<="010";
		elsif (cc>17+3 and cc<21+3 and ll>225 and ll<245) then grbz<="010";
		elsif (cc>19+3 and cc<21+3 and ll>170 and ll<300) then grbz<="010";


		else grbz<="000";
	end if;
END PROCESS;
    HS <= HS1 ; VS <= VS1 ;R <= GRB(2) ;G <= GRB(3) ; B <= GRB(1);


END behav;

