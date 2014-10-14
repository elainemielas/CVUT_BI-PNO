library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity TB_DECODER is 
end entity TB_DECODER;

architecture TB_DECODER_BODY of TB_DECODER is

	component DECODER
		port (
			BIN_VALUE : in  std_logic_vector (2 downto 0);
			ONE_HOT   : out std_logic_vector (7 downto 0)
		);
	end component; 
	
	signal T_BIN_VALUE : std_logic_vector (2 downto 0);
	signal T_ONE_HOT   : std_logic_vector (7 downto 0);

begin

	UUT : DECODER port map (BIN_VALUE => T_BIN_VALUE, ONE_HOT => T_ONE_HOT);
	
	TEST : process
	begin
		for I in 0 to 7 loop
			T_BIN_VALUE <= conv_std_logic_vector (I, 3);
			wait for 30 ns;
			for J in 0 to 7 loop
				if (I = J) then
					assert T_ONE_HOT(J) = '1' report "ERROR!" severity ERROR;
				else
				   assert T_ONE_HOT(J) = '0' report "ERROR!" severity ERROR;
				end if;
			end loop;
		end loop;
	end process;
	
end architecture;