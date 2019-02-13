
library ieee;
use ieee.std_logic_1164.all;

entity carry is
	port(
		g1 : in std_logic;
		p1 : in std_logic;
		g2 : in std_logic;
		p2 : in std_logic;
		g_up : out std_logic;
		p_up : out std_logic
	);
end carry;

architecture arch OF carry is
begin
	g_up <= g2 or (g1 and p2);
	p_up <= p2 and p1;
end arch;	
