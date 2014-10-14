library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MUX is 
	port (
	   SHOWA1A0 : in std_logic;
		SHOWA3A2 : in std_logic;    
		OUTPUT   : in std_logic_vector (15 downto 0);
		SHOW1OUT : in std_logic_vector (15 downto 0);
		SHOW2OUT : in std_logic_vector (15 downto 0);
		DATAOUT  : out std_logic_vector (15 downto 0)
	);
end MUX;

architecture MUX_BODY of MUX is
begin

PRIDEL : process (SHOWA1A0, SHOWA3A2, SHOW1OUT, SHOW2OUT, OUTPUT) 
	begin
	   if SHOWA1A0 = '1' then DATAOUT <= SHOW1OUT;
		elsif SHOWA3A2 = '1' then DATAOUT <= SHOW2OUT;
		else DATAOUT <= OUTPUT;
		end if;
end process;

end architecture;