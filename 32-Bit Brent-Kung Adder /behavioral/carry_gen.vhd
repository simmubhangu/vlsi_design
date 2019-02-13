
library ieee;
use ieee.std_logic_1164.all;

entity carry_gen is
	port(
		g_in : in std_logic;
		p_in : in std_logic;
		c_in : in std_logic;
		c_out : out std_logic
	);
end carry_gen;

architecture arch OF carry_gen is
begin
	c_out <= g_in or (p_in and c_in);
end arch;	
