library ieee;
use ieee.std_logic_1164.all;


entity xzq is
port(a,b,c,d :in std_logic_vector(7 downto 0);
	sel:in std_logic_vector(1 downto 0);
	yout:out std_logic_vector(7 downto 0));
end xzq;
architecture bhv of xzq is
begin
yout<=a when sel="00" else
      b when sel="01" else
      c when sel="10" else
      d when sel="11";
end bhv;