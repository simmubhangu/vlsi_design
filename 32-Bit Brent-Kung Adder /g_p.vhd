
library ieee;
use ieee.std_logic_1164.all;

entity g_p is
	port(
		x : in std_logic;
		y : in std_logic;
		g : out std_logic;
		p : out std_logic
	);
end g_p;

-- g = a.b

architecture arch of g_p is
begin
	g <= x and y;
	
	p <= x or y;
end arch;
