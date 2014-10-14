library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity TB_SCIT4 is
end entity TB_SCIT4;

architecture TB_SCIT4_BODY of TB_SCIT4 is
	signal T_A, T_B : std_logic_vector ( 3 downto 0 );
	signal T_S : std_logic_vector ( 4 downto 0 );
	signal T_Cin : std_logic;
	
	component SCIT4
		port (
			A, B : in  std_logic_vector ( 3 downto 0 );
			Cin  : in  std_logic;
			S    : out std_logic_vector ( 4 downto 0 ) 
		);
	end component;
begin
	UUT : SCIT4 port map ( A => T_A, B => T_B, S => T_S, Cin => T_Cin );
	
	TESTA : process
	begin
		for I in 0 to 15 loop
			T_A <= conv_std_logic_vector ( I, 4 );
			for J in 0 to 15 loop
				T_B <= conv_std_logic_vector ( J, 4 );
				T_Cin <= '0';
				wait for 30 ns;
				assert T_S = conv_std_logic_vector (I + J + 0, 5) 
					report "chyba!"
						severity ERROR;
				T_Cin <= '1';
				wait for 30 ns;
				assert T_S = conv_std_logic_vector (I + J + 1, 5) 
					report "chyba!"
						severity ERROR;
			end loop;
		end loop;
		assert FALSE report "konec" severity FAILURE;
	end process;
	
end architecture TB_SCIT4_BODY;