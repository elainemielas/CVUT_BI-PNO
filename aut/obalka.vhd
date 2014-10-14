
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity obalka is
	port (
			KEY_F     : in std_logic;     -- high for one clock when key 'f' pressed
			KEY_U     : in std_logic;     -- high for one clock when key 'u' pressed
			KEY_L     : in std_logic;     -- high for one clock when key 'l' pressed
			KEY_PRESS : in std_logic;     -- high for one clock when any key pressed
			CLK       : in  std_logic;    -- standard 50MHz clock
			RESET     : in  std_logic;
			JCHYBA    : out std_logic;    -- detekovano s 1 chybou
			SHODA     : out std_logic;     -- detekovana uplna shoda
			VYSTUP    : out std_logic_vector ( 0 to 8 )
		);
end obalka;

architecture Behavioral of obalka is


	COMPONENT AUTOMAT
	PORT(
		KEY_F : IN std_logic;
		KEY_U : IN std_logic;
		KEY_L : IN std_logic;
		KEY_PRESS : IN std_logic;
		CLK : IN std_logic;
		RESET : IN std_logic;          
		JCHYBA : OUT std_logic;
		SHODA : OUT std_logic;
		VYSTUP : OUT std_logic_vector(0 to 8)
		);
	END COMPONENT;
	
	signal regd : std_logic_vector (2 downto 0);
	signal blah : std_logic;

begin



	Inst_AUTOMAT: AUTOMAT PORT MAP(
		KEY_F => KEY_F,
		KEY_U => KEY_U,
		KEY_L => KEY_L,
		KEY_PRESS => blah,
		CLK => CLK,
		RESET => RESET,
		JCHYBA => JCHYBA,
		SHODA => SHODA,
		VYSTUP => VYSTUP
	);

regd <= regd (1 downto 0) & KEY_PRESS when rising_edge(CLK);
blah <= '1' when regd(2) = '0' and regd(1) = '1' else '0';


end Behavioral;

