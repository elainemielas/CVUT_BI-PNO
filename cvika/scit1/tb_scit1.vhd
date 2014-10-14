library IEEE;
use IEEE.std_logic_1164.all;

entity TB_SCIT1 is
end entity TB_SCIT1;

architecture TB_SCIT1_BODY of TB_SCIT1 is
	signal T_A, T_B, T_CIN, T_S, T_COUT : std_logic;
	 
	component SCIT1 is
		port (A, B, CIN : in std_logic;
				COUT, S   : out std_logic
				);
	end component SCIT1;

begin
	UUT : SCIT1 port map ( A => T_A, B => T_B, CIN => T_CIN, COUT => T_COUT, S => T_S );
	
	SIGNAL_A : process
	begin
		wait for 400 ns;	
		T_A <= '1';
		wait for 400 ns;
		T_A <= '0';
	end process SIGNAL_A;
	
	SIGNAL_B : process
	begin 
		wait for 200 ns;
		T_B <= '1';
		wait for 200 ns;
		T_B <= '0';
	end process SIGNAL_B;
	
	SIGNAL_CIN : process
	begin
		wait for 100 ns;
		T_CIN <= '1';
		wait for 100 ns;
		T_CIN <= '0';
	end process SIGNAL_CIN;
	
end architecture TB_SCIT1_BODY;