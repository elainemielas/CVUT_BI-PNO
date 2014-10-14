library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.std_logic_arith.all;

entity DATAPATH is
	port(
		INPUT             : in std_logic_vector (7 downto 0);
		CLK, RESET, POSUN, SCIT : in std_logic;
		OUTPUT            : out std_logic_vector (15 downto 0);
		SHOW1OUT          : out std_logic_vector (15 downto 0);
		SHOW2OUT          : out std_logic_vector (15 downto 0);
		ZERO              : out std_logic
		);
end DATAPATH;

architecture DATAPATH_BODY of DATAPATH is

	signal A0, A1, A2, A3 : std_logic_vector (7 downto 0); -- hodnoty
	signal extA0, extA1, extA2, extA3, SUM, AIN : std_logic_vector (9 downto 0);
	signal COUNT_VAL : std_logic_vector (2 downto 0); -- counter pro scitani

begin

	LOAD : process (CLK)
		begin
			if CLK = '1' and CLK'event then
				if POSUN = '1' then 
					A3 <= A2;
					A2 <= A1;
					A1 <= A0;
					A0 <= INPUT;
				elsif RESET = '1' then
					A3 <= (others => '0');
					A2 <= (others => '0');
					A1 <= (others => '0');
					A0 <= (others => '0');
				end if;
			end if;
	end process;
	
	-- rozsirime hodnoty, abysme neztratili znaminko
	extA0 <= A0(7) & A0(7) & A0;
	extA1 <= A1(7) & A1(7) & A1;
	extA2 <= A2(7) & A2(7) & A2;
	extA3 <= A3(7) & A3(7) & A3;
	
	-- v registru AIN je hodnota, kterou budeme tedka pricitat k sume, 
	-- do ni budeme davat postupne vsichni hodnoty od extA0 do extA3 a bude se to ridit countrem
	process(RESET, COUNT_VAL, extA0, extA1, extA2, extA3, SCIT)
	begin
		if RESET = '1' then
				AIN <= (others => '0'); 
		elsif SCIT = '1' then
				case COUNT_VAL is
					when "100" => AIN <= extA3;
					when "011" => AIN <= extA2;
					when "010" => AIN <= extA1;
					when others => AIN <= extA0;
				end case;
		else
				AIN <= (others => '0');
		end if;
	end process;
	
	-- pocitani sumy
	REG_SUM : process (CLK)
		begin
			if CLK = '1' and CLK'event then
				if POSUN = '1' or RESET = '1' then 
					SUM <= (others => '0'); -- posun nam vysledek zresetuje
					COUNT_VAL <= "100"; -- a nastavi counter na 4
				elsif SCIT = '1' then
					SUM <= SUM + AIN; -- scitame
					COUNT_VAL <= COUNT_VAL - 1; -- zmensujeme counter
				end if;
			end if;
	end process;
	
	-- signal, ktery rekne, ze scitani je dodelano
	ZERO <= '1' when COUNT_VAL = "001" else '0';
	
	-- deleni 4 (vememe sumu bez 2 dolnich bitu a rozsirime ji pro snadne zobrazeni)
	OUTPUT <= SUM(9) & SUM(9) &SUM(9) &SUM(9) &SUM(9) &SUM(9) &SUM(9) &SUM(9) & SUM(9 downto 2);
	
	-- udelame vystup pro ukazani obsahu jednotlivych registru
	SHOW1OUT <= A1 & A0;
	SHOW2OUT <= A3 & A2;
	
end architecture;
	

