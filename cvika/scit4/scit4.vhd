library IEEE;
use IEEE.std_logic_1164.all;

entity SCIT4 is
	port ( 
		A, B : in  std_logic_vector ( 3 downto 0 );
		Cin  : in  std_logic;
		S    : out std_logic_vector ( 4 downto 0 ) 
	);
end entity SCIT4;

architecture SCIT4_BODY of SCIT4 is
	signal C : std_logic_vector ( 4 downto 0 );
begin

--	VSTUP : process (Cin)
--	begin
--		C(0) <= Cin;
--	end process VSTUP;
	
	SCITANI : process ( C, A, B, Cin )
	begin
		C(0) <= Cin;
		for I in 0 to 3 loop
			S(I)   <= A(I) xor B(I) xor C(I) after 2 ns;
			C(I+1) <= ( A(I) and B(I) ) or ( A(I) and C(I) ) or ( B(I) and C(I) ) after 2 ns;
		end loop;
		S(4) <= C(4);
	end process SCITANI;
	
--	VYSTUP : process (C(4))
--	begin
--		S(4) <= C(4);
--	end process VYSTUP;
	
end architecture SCIT4_BODY;
