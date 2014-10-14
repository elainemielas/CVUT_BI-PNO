library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALLINALL is
	port (
			PS2_DATA  : in  std_logic;     -- serial PS2 input
			PS2_CLK   : in  std_logic;     -- serial PS2 clock
			CLK       : in  std_logic;     -- standard 50MHz clock
			RESET     : in  std_logic;
			JCHYBA    : out std_logic;    -- detekovano s 1 chybou
			SHODA     : out std_logic     -- detekovana uplna shoda
		);
end ALLINALL;

architecture ALLINALL_BODY of ALLINALL is
	
	signal KEY_F, KEY_U, KEY_L, KEY_PRESS : std_logic;
	
	component KEYBOARD is 
		port (
				PS2_DATA  : in  std_logic;     -- serial PS2 input
				PS2_CLK   : in  std_logic;     -- serial PS2 clock
				KEY_F     : out std_logic;     -- high for one clock when key 'f' pressed
				KEY_U     : out std_logic;     -- high for one clock when key 'u' pressed
				KEY_L     : out std_logic;     -- high for one clock when key 'l' pressed
				KEY_PRESS : out std_logic;     -- high for one clock when any key pressed
				CLK       : in  std_logic;     -- standard 50MHz clock
				RESET     : in  std_logic
			);
	end component;

	component AUTOMAT is
		port (
				KEY_F     : in std_logic;     -- high for one clock when key 'f' pressed
				KEY_U     : in std_logic;     -- high for one clock when key 'u' pressed
				KEY_L     : in std_logic;     -- high for one clock when key 'l' pressed
				KEY_PRESS : in std_logic;     -- high for one clock when any key pressed
				CLK       : in  std_logic;    -- standard 50MHz clock
				RESET     : in  std_logic;
				JCHYBA    : out std_logic;    -- detekovano s 1 chybou
				SHODA     : out std_logic     -- detekovana uplna shoda
			);
	end component;

begin

	AUT : AUTOMAT port map (CLK => CLK, RESET => RESET, KEY_F => KEY_F, KEY_U => KEY_U, KEY_L => KEY_L,
									KEY_PRESS => KEY_PRESS, JCHYBA => JCHYBA, SHODA => SHODA);
	
	KB : KEYBOARD port map (CLK => CLK, RESET => RESET, KEY_F => KEY_F, KEY_U => KEY_U, KEY_L => KEY_L,
									KEY_PRESS => KEY_PRESS, PS2_DATA => PS2_DATA, PS2_CLK => PS2_CLK);
											

end architecture;
