library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity AUTOMAT is
	port(
		CLK, BTN0, BTN1, ZERO : in std_logic;
		POSUN, SCIT : out std_logic
	);
end AUTOMAT;

architecture AUTOMAT_BODY of AUTOMAT is
	type TYP_STAV is (START, POS, CEKANI, SUM, SHOW);
	signal STAV, DALSI_STAV : TYP_STAV;

begin
	PRECHODY : process (BTN1, STAV, ZERO)
	begin
		DALSI_STAV <= STAV;
		case STAV is
			when START => if BTN1 = '1' then 
									DALSI_STAV <= POS;
							  end if;
			when POS => DALSI_STAV <= CEKANI;
			
			when CEKANI => if BTN1 = '0' then DALSI_STAV <= SUM;
								end if;
         when SUM => if ZERO = '1' then DALSI_STAV <= SHOW;
							end if;
			when SHOW => if BTN1 = '1' then DALSI_STAV <= POS;
							end if;
			when others => NULL;
		end case;
	end process;
	
	VYSTUP : process (STAV)
	begin 
	   POSUN <= '0'; SCIT <= '0';
		
		case STAV is
			when POS => POSUN <= '1';
			when SUM => SCIT <= '1'; 
			when others => NULL;
		end case;
	end process;
	
	REG : process (CLK)
	begin
		if CLK'event and CLK = '1' then
			if BTN0 = '1' then STAV <= START;
			else STAV <= DALSI_STAV;
			end if;
		end if;
	end process;
		
end architecture;

