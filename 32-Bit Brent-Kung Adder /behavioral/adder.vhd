
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
process(a,b,g_1,g_2,g_3,g_4,g_5,g_6,cr)
begin
			for i in 0 to 31 loop
--				pm1: g_p port map (x => a(i) , y => b(i) , g => g_1(i) , p => p_1(i));
					g_1(i) <= a(i) and b(i) after 154 ps;
					p_1(i) <= a(i) or b(i)after 154 ps;
			end loop;

			--wait for 200 ps;

--stg01:
			for i in 0 to 15 loop
				--pm2: carry port map (g1 => g_1(2*i) , g2 => g_1(2*i+1) , p1 => p_1(2*i) , p2 => p_1(2*i+1), g_up=>g_2(i),p_up=>p_2(i));
				g_2(i) <= g_1(2*i+1) or (g_1(2*i) and p_1(2*i+1)) after 168 ps;
				p_2(i) <= p_1(2*i+1) and p_1(2*i) after 168 ps;
			end loop;
			--cr(1) <= g_2(1) or (p_2(1) or cr(0));
--stg02:		
			for i in 0 to 7 loop
				--pm3: carry port map (g1 => g_2(2*i) , g2 => g_2(2*i+1) , p1 => p_2(2*i) , p2 => p_2(2*i+1), g_up=>g_3(i),p_up=>p_3(i));
				
				g_3(i) <= g_2(2*i+1) or (g_2(2*i) and p_2(2*i+1)) after 168 ps;
				p_3(i) <= p_2(2*i+1) and p_2(2*i) after 168 ps;				
			
			end loop;
			--cr(4) <= g_3(0) or (p_3(0) or cr(0));
--stg03:			
			for i in 0 to 3 loop
				--pm4: carry port map (g1 => g_3(2*i) , g2 => g_3(2*i+1) , p1 => p_3(2*i) , p2 => p_3(2*i+1), g_up=>g_4(i),p_up=>p_4(i));
				
				g_4(i) <= g_3(2*i+1) or (g_3(2*i) and p_3(2*i+1)) after 168 ps;
				p_4(i) <= p_3(2*i+1) and p_3(2*i) after 168 ps;
			
			end loop;
			
--stg04:	
			for i in 0 to 1 loop
				--pm5: carry port map (g1 => g_4(2*i) , g2 => g_4(2*i+1) , p1 => p_4(2*i) , p2 => p_4(2*i+1), g_up=>g_5(i),p_up=>p_5(i));
				
				g_5(i) <= g_4(2*i+1) or (g_4(2*i) and p_4(2*i+1)) after 168 ps;
				p_5(i) <= p_4(2*i+1) and p_4(2*i) after 168 ps;
			
			end loop;
			
			
	--		pm6: carry port map (g1 => g_5(0) , g2 => g_5(1) , p1 => p_5(0) , p2 => p_5(1), g_up=>g_6,p_up=>p_6);
			
				g_6 <= g_5(1) or (g_5(0) and p_5(1)) after 168 ps;
				p_6 <= p_5(0) and p_5(1) after 168 ps;			


if g_6 ='0' or g_6='1' then		
cr(32) <= g_6 or (p_6 and cin) after 168 ps;
end if;

if cr(32) ='0' or cr(32)='1' then			
cout <= cr(32);
cr(0) <= cin;
cr(16) <= g_5(0) or (p_5(0) and cr(0))after 168 ps;
end if;

if cr(16) ='0' or cr(16)='1' then
cr(24) <= g_4(2) or (p_4(2) and cr(16)) after 168 ps;
cr(8) <= g_4(0) or (p_4(0) and cr(0)) after 168 ps;
end if;

if cr(8) ='0' or cr(8)='1' then

--cr(2) <= g_2(0) or (p_2(0) and cr(0));

			--cr(23) <= g_4(2) or (p_4(2) and cr(15));
 						
--carry_stg:
			for i in 1 to 3 loop
				--cr0: carry_gen port map (g_in => g_3(2*i)  , p_in => p_3(2*i), c_in=>cr(8*i),c_out=>cr((8*i)+4));
				
				cr((8*i)+4) <= g_3(2*i) or (p_3(2*i) and cr(8*i)) after 168 ps;				
				cr(4) <= g_3(0) or (p_3(0) and cr(0));
			end loop;
--carry_stg2:
			for i in 1 to 7 loop
				--cr1: carry_gen port map (g_in => g_2(2*i)  , p_in => p_2(2*i), c_in=>cr(4*i),c_out=>cr((4*i)+2));
			
			cr((4*i)+2) <= g_2(2*i) or (p_2(2*i) and cr(4*i)) after 168 ps;				
			cr(2) <= g_2(0) or (p_2(0) and cr(0));
			end loop;				

--carry_stg3:
			for i in 1 to 15 loop
				--cr2: carry_gen port map (g_in => g_1(2*i)  , p_in => p_1(2*i), c_in=>cr(2*i),c_out=>cr((2*i)+1));
				
				cr((2*i)+1) <= g_1(2*i) or (p_1(2*i) and cr(2*i)) after 168 ps;				
				cr(1) <= g_1(0) or (p_1(0) and cr(0));
			end loop;
			
--cout <= cr(32);
end if;
--sumstage:
if cr(31)='0' or cr(31)='1' then
		for i in 0 to 31 loop
				s(i) <= (a(i) xor b (i)) xor cr(i) after 168 ps;
			end loop;
end if;
end process;	
end adder_arch;
