
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.all;

entity Adder is
	port(
		clk: in std_logic;
		a, b: in std_logic_vector((31) downto 0);
		cin: in std_logic;
		cout: out std_logic;
		s: out std_logic_vector((31) downto 0)
	);
end Adder;

--comportamento
architecture adder_arch of Adder is

		
	signal g_1: std_logic_vector(31 downto 0);
	signal p_1: std_logic_vector(31 downto 0);
	
	signal g_2: std_logic_vector(15 downto 0);
	signal p_2: std_logic_vector(15 downto 0);
	
	signal g_3: std_logic_vector(7 downto 0);
	signal p_3: std_logic_vector(7 downto 0);
	
	signal g_4: std_logic_vector(3 downto 0);
	signal p_4: std_logic_vector(3 downto 0);
	
	signal g_5: std_logic_vector(1 downto 0);
	signal p_5: std_logic_vector(1 downto 0);
	
	signal cr: std_logic_vector(32 downto 0);
	
	signal g_6: std_logic;
	signal p_6: std_logic;
	
	component g_p port (x,y:in std_logic;
	g,p:out std_logic);
	end component;
	component carry port (	
		g1 : in std_logic;
		p1 : in std_logic;
		g2 : in std_logic;
		p2 : in std_logic;
		g_up : out std_logic;
		p_up : out std_logic
	);
	end component;
	component carry_gen port(
		g_in : in std_logic;
		p_in : in std_logic;
		c_in : in std_logic;
		c_out : out std_logic
	);
	end component;

	
	
begin
stg00:
			for i in 0 to 31 generate
				pm1: g_p port map (x => a(i) , y => b(i) , g => g_1(i) , p => p_1(i));
			end generate;
			cr(0) <= cin;

stg01:
			for i in 0 to 15 generate
				pm2: carry port map (g1 => g_1(2*i) , g2 => g_1(2*i+1) , p1 => p_1(2*i) , p2 => p_1(2*i+1), g_up=>g_2(i),p_up=>p_2(i));
			end generate;
			--cr(1) <= g_2(1) or (p_2(1) or cr(0));
stg02:		
			for i in 0 to 7 generate
				pm3: carry port map (g1 => g_2(2*i) , g2 => g_2(2*i+1) , p1 => p_2(2*i) , p2 => p_2(2*i+1), g_up=>g_3(i),p_up=>p_3(i));
			end generate;
			--cr(4) <= g_3(0) or (p_3(0) or cr(0));
stg03:			
			for i in 0 to 3 generate
				pm4: carry port map (g1 => g_3(2*i) , g2 => g_3(2*i+1) , p1 => p_3(2*i) , p2 => p_3(2*i+1), g_up=>g_4(i),p_up=>p_4(i));
			end generate;
			
stg04:	
			for i in 0 to 1 generate
				pm5: carry port map (g1 => g_4(2*i) , g2 => g_4(2*i+1) , p1 => p_4(2*i) , p2 => p_4(2*i+1), g_up=>g_5(i),p_up=>p_5(i));
			end generate;
			
			
			pm6: carry port map (g1 => g_5(0) , g2 => g_5(1) , p1 => p_5(0) , p2 => p_5(1), g_up=>g_6,p_up=>p_6);
			
			cr(32) <= g_6 or (p_6 and cin);

cr(16) <= g_5(0) or (p_5(0) and cr(0));
cr(24) <= g_4(2) or (p_4(2) and cr(16));
cr(8) <= g_4(0) or (p_4(0) and cr(0));
cr(4) <= g_3(0) or (p_3(0) and cr(0));
cr(2) <= g_2(0) or (p_2(0) and cr(0));
cr(1) <= g_1(0) or (p_1(0) and cr(0));
			--cr(23) <= g_4(2) or (p_4(2) and cr(15));
 						
carry_stg:
			for i in 1 to 3 generate
				cr0: carry_gen port map (g_in => g_3(2*i)  , p_in => p_3(2*i), c_in=>cr(8*i),c_out=>cr((8*i)+4));
			end generate;
carry_stg2:
			for i in 1 to 7 generate
				cr1: carry_gen port map (g_in => g_2(2*i)  , p_in => p_2(2*i), c_in=>cr(4*i),c_out=>cr((4*i)+2));
			end generate;				

carry_stg3:
			for i in 1 to 15 generate
				cr2: carry_gen port map (g_in => g_1(2*i)  , p_in => p_1(2*i), c_in=>cr(2*i),c_out=>cr((2*i)+1));
			end generate;
cout <= cr(32);
sumstage:
		for i in 0 to 31 generate
				s(i) <= (a(i) xor b (i)) xor cr(i);
			end generate;
			
end adder_arch;
