library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.CONSCTANS.ALL;

entity KITT is
	port (
		CLK   : in std_logic;
		RESET : in std_logic;
		LEDS  : out std_logic_vector (7 downto 0)
	);
end KITT;

architecture KITT_BODY of KITT is
	signal CNT_OUT : std_logic_vector (OUTPUT_WIDTH - 1 downto 0);
	signal UP, TOP, BOTTOM : std_logic;
	
	component CONTROLLER is
		port(
			CLK     : in std_logic;
			RESET   : in std_logic;
			TOP     : in std_logic;
			BOTTOM  : in std_logic;
			UP      : out std_logic
		);
	end component;

	component COUNTER is
		port (
			CLK     : in std_logic;
			RESET   : in std_logic;
			UP      : in std_logic;
			CNT_OUT : out std_logic_vector (OUTPUT_WIDTH - 1 downto 0);
			TOP     : out std_logic;
			BOTTOM  : out std_logic
		);
	end component;

	component DECODER is 
		port (
			BIN_VALUE : in  std_logic_vector (2 downto 0);
			ONE_HOT   : out std_logic_vector (7 downto 0)
		);
	end component;

begin

	RADIC : CONTROLLER port map ( CLK => CLK, RESET => RESET, UP => UP, TOP => TOP, BOTTOM => BOTTOM );
	CITAC : COUNTER port map ( CLK => CLK, RESET => RESET, UP => UP, CNT_OUT => CNT_OUT, TOP => TOP, BOTTOM => BOTTOM );
	DEKODER : DECODER port map ( BIN_VALUE => CNT_OUT, ONE_HOT => LEDS);

end architecture;

