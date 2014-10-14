library IEEE;
use IEEE.std_logic_1164.all;

entity SCIT1 is
   port (A, B, CIN : in std_logic;
			COUT, S   : out std_logic
			);
end entity SCIT1;

architecture SCIT1_BODY of SCIT1 is
begin
	VYSTUP : process (A, B, CIN)
	begin
		S <= A xor B xor CIN after 2 ns;
	end process;
	
	PRENOS : process (A, B, CIN)
	begin
		COUT <= (CIN and A) or (CIN and B) or (A and B) after 3 ns;
		--wait on A, B, CIN;
	end process;
end architecture SCIT1_BODY;


