library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KITT is
	port (
		CLK   : in std_logic;
		INPUT : in std_logic_vector (7 downto 0);
		BTN0  : in std_logic; 
		BTN1  : in std_logic; 
		BTN2  : in std_logic; 
		BTN3  : in std_logic;
		SEG   : out  STD_LOGIC_VECTOR (6 downto 0);    -- 7 segmentu displeje
		DP_K  : out  STD_LOGIC;                        -- desetinna tecka
		DIG   : out  STD_LOGIC_VECTOR (3 downto 0)     -- 4 cifry displeje
	);
end KITT;

architecture KITT_BODY of KITT is
	
	signal DATAOUT, SHOW1OUT, SHOW2OUT, OUTPUT : std_logic_vector (15 downto 0);
	signal POSUN, SCIT, ZERO : std_logic;
	
	component AUTOMAT is
		port(
			CLK, BTN0, BTN1, ZERO : in std_logic;
			POSUN, SCIT : out std_logic
		);
	end component;

	component DATAPATH is
		port(
			INPUT             : in std_logic_vector (7 downto 0);
			CLK, RESET, POSUN, SCIT : in std_logic;
			OUTPUT            : out std_logic_vector (15 downto 0);
			SHOW1OUT          : out std_logic_vector (15 downto 0);
			SHOW2OUT          : out std_logic_vector (15 downto 0);
			ZERO              : out std_logic
		);
	end component;

	component HEX2SEG is 
		port (
			DATA     : in   STD_LOGIC_VECTOR (15 downto 0);   -- vstupni data k zobrazeni (4 sestnactkove cislice)
			CLK      : in   STD_LOGIC;
			SEGMENT  : out  STD_LOGIC_VECTOR (6 downto 0);    -- 7 segmentu displeje
			DP       : out  STD_LOGIC;                        -- desetinna tecka
			DIGIT    : out  STD_LOGIC_VECTOR (3 downto 0)     -- 4 cifry displeje
		);
	end component;
	
	component MUX is 
		port (
		   SHOWA1A0 : in std_logic;
			SHOWA3A2 : in std_logic;    
			OUTPUT   : in std_logic_vector (15 downto 0);
			SHOW1OUT : in std_logic_vector (15 downto 0);
			SHOW2OUT : in std_logic_vector (15 downto 0);
			DATAOUT  : out std_logic_vector (15 downto 0)
		);
	end component;

begin

	RADIC : AUTOMAT port map (CLK => CLK, POSUN => POSUN, SCIT => SCIT, BTN0 => BTN0, BTN1 => BTN1, ZERO => ZERO);
	
	SCITANI : DATAPATH port map (CLK => CLK, RESET => BTN0, POSUN => POSUN, SCIT => SCIT, INPUT => INPUT, OUTPUT => OUTPUT, SHOW1OUT => SHOW1OUT, SHOW2OUT => SHOW2OUT, ZERO => ZERO);
											
	MULTIPLEXER : MUX port map (SHOWA1A0 => BTN3, SHOWA3A2 => BTN2, OUTPUT => OUTPUT, SHOW1OUT => SHOW1OUT, SHOW2OUT => SHOW2OUT, DATAOUT => DATAOUT);
	
	DEKODER : HEX2SEG port map (DATA => DATAOUT, CLK => CLK, SEGMENT => SEG, DP => DP_K, DIGIT => DIG);

end architecture;

