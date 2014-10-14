
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity CONTROLLER is
	port(
		CLK     : in std_logic;
		RESET   : in std_logic;
		TOP     : in std_logic;
		BOTTOM  : in std_logic;
		UP      : out std_logic
	);
end CONTROLLER;

architecture CONTROLLER_BODY of CONTROLLER is
	type TYP_STAV is (NAHORU, DOLU);
	signal STAV, DALSI_STAV : TYP_STAV;

begin
	PRECHODY : process (TOP, BOTTOM, STAV)
	begin
		DALSI_STAV <= STAV;
		case STAV is
			when NAHORU => if TOP = '1' then DALSI_STAV <= DOLU;
												 --else DALSI_STAV <= NAHORU;
												 end if;
			when DOLU => if BOTTOM = '1' then DALSI_STAV <= NAHORU;
												  --else DALSI_STAV <= DOLU;
												  end if;
		end case;
	end process;
	
	VYSTUP : process (STAV, TOP, BOTTOM)
	begin 
		case STAV is
			when NAHORU => if TOP = '1' then UP <= '0';
							                else UP <= '1';
			               end if;
			when DOLU => if BOTTOM = '1' then UP <= '1';
							                 else UP <= '0';
			             end if;
		end case;
	end process;
	
	REG : process (CLK)
	begin
		if CLK'event and CLK = '1' then
			if RESET = '1' then STAV <= NAHORU;
							   else STAV <= DALSI_STAV;
			end if;
		end if;
	end process;
		
end architecture;

