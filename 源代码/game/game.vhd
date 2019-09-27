library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity game is port(
	clk50MHz : in std_logic;
	MS : in std_logic;
	r,g,b,hs,vs : out std_logic;
	key_clk : in std_logic;
    key_data : in std_logic);
end entity;

architecture one of game is

component XIHAO IS
PORT(   	clk: 					IN STD_LOGIC;
			vga_h_sync, vga_v_sync: OUT STD_LOGIC;
			inDisplayArea 		:    OUT STD_LOGIC;
			CounterX	         :    OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
			CounterY			:   OUT STD_LOGIC_VECTOR(8 DOWNTO 0));
END component;

component VGA IS
PORT ( CLK,quadA, quadB		:	IN  STD_LOGIC;
       inDisplayArea		:   IN  STD_LOGIC;
       CounterX				:  	in  std_logic_vector(9 downto 0);
       CounterY 			:   in  std_logic_vector( 8 downto 0);
       vga_R, vga_G, vga_B  :   out std_logic );
END component;

component vga640480 is
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
end component;

component mid is 
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
end component;

component timg IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
	);
END component;

component over IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
	);
END component;

----------------------PS/2----------------------------
component receiver is
	port (clock0: in std_logic;
			key_clk :in std_logic;--键盘数据时钟
			key_data : in std_logic;--键盘数据信号
			key_code : out std_logic_vector(7 downto 0)--接收键盘数据的标志码
			);
end component;
----------------------PS/2----------------------------

-------------signal---------

signal inDisplayArea1 : std_logic;
signal CounterX1 : std_logic_vector(9 downto 0);
signal CounterY1 : std_logic_vector(8 downto 0);

signal key_code : std_logic_vector(7 downto 0);
signal clk25MHz : std_logic;

signal vs0, hs0 : std_logic;
signal qa0, qb0 : std_logic;
signal r0, g0, b0 : std_logic;

-------------game2-----------------
signal r1, g1, b1, hs1, vs1 : std_logic;
signal hpos1, vpos1 : std_logic_vector(9 downto 0);
signal romrgb : std_logic_vector(2 downto 0);
signal rgb : std_logic_vector(2 downto 0);
signal conterY : std_logic_vector(9 downto 0);
signal borderX : std_logic_vector(9 downto 0);
signal gameover : std_logic;
signal romaddr : std_logic_vector(13 downto 0);

signal overaddr : std_logic_vector(15 downto 0);
signal rgbover : std_logic_vector(2 downto 0);
-----------end--------------

begin
	
process(clk50MHz) begin
	if clk50MHz'event and clk50MHz = '1' then
		clk25MHz <= not clk25MHz;
	end if;
end process;	
	
process(vs0)
begin	
	if(vs0 = '0') then
		case key_code is
			when "01000100" =>	--D
				qa0<='1';
				qb0<='0';
			when "01000001" =>  --A
				qa0<='0';
				qb0<='1';
			when others =>null;
		end case;
	end if;
end process;

process(vs1)
begin	
	if(vs1 = '0') then
		if(borderX=640) then
			borderX<=(others => '0');
		else
			borderX<=borderX + 10;
		end if;
		case key_code is
			when "01010011" => --W
				if(conterY >= 0 and conterY <= 128) then
					conterY <= conterY + 4;
				elsif(conterY < 0) then
					conterY <= (others => '0');
				else
					conterY <= "0010000000";
				end if;
			when "01010111" => --S
				if(conterY <= 0) then
					conterY <= (others => '0');
				elsif(conterY > 0 and conterY <= 128) then
					conterY <= conterY - 4;
				end if;
			when others => null;
		end case;
	end if;
end process;

process(MS)
begin
	if(MS = '1') then
		r <= r0;
		g <= g0;
		b <= b0;
		hs <= hs0;
		vs <= vs0;
	else
		if(gameover = '0') then
			r <= r1;
			g <= g1;
			b <= b1;
		else
			r <= rgbover(2);
			g <= rgbover(1);
			b <= rgbover(0);
		end if;
		hs <= hs1;
		vs <= vs1;
	end if;
end process;

xihao1 : XIHAO
port map (
	clk => clk25MHz,
	vga_h_sync => hs0,
	vga_v_sync => vs0,
	inDisplayArea => inDisplayArea1,
	CounterX => CounterX1,
	CounterY => CounterY1
);

vga1 : VGA port map(
	CLK => clk25MHz,
	quadA => qa0,
	quadB => qb0,
	inDisplayArea => inDisplayArea1,
	CounterX => CounterX1,
	CounterY => CounterY1,
	vga_R => r0,
	vga_G => g0,
	vga_B => b0
);

i_mid : mid port map(
	clk => clk25MHz,
	qin => romrgb,
	xx => "0000000000",
	yy => conterY,
	hcntin => hpos1,
	vcntin => vpos1,
	borderX => borderX,
	borderY => "0000000000",
	qout => rgb,
	over => gameover,
	romaddr_control => romaddr
);

i_vga640480 : vga640480 port map(
	clk	=> clk25MHz,
	hs => hs1,
	vs => vs1,
	r => r1,
	g => g1,
	b => b1,
	rgbin => rgb,
	hcntout	=> hpos1,
	vcntout	=> vpos1
);

i_timg : timg port map(
	address	=> romaddr,
	clock => clk25MHz,
	q => romrgb
);

overaddr <= vpos1(7 downto 0)&hpos1(7 downto 0);
i_over : over port map(
	address	=> overaddr,
	clock => clk25MHz,
	q => rgbover
);

i_receiver : receiver
PORT MAP (clock0 => clk50MHz,
		key_clk => key_clk,
		key_data => key_data,
		key_code => key_code
		);

end one;