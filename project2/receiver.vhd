library IEEE;
use IEEE.std_logic_1164.all;

entity RECEIVER is
	port (
		PS2_DATA  : in  std_logic;     -- serial PS2 input
      PS2_CLK   : in  std_logic;     -- serial PS2 clock
      CLK       : in  std_logic;     -- standard 50MHz clock
      RESET     : in  std_logic;
		SCAN_CODE : out std_logic_vector ( 7 downto 0 );
		NEW_SC    : out std_logic
		);
end RECEIVER;

architecture RECEIVER_BODY of RECEIVER is
	type T_STATE is ( W_START, R_START, W_0, R_0, W_1, R_1, W_2, R_2, W_3, R_3, W_4, R_4, W_5, R_5, W_6, R_6, W_7, R_7, W_PAR, R_PAR, W_END, R_END, VALID );
	signal STATE, NEXT_STATE : T_STATE;
	signal PAR, PS2_PAR, PS2_END : std_logic;
	signal SC : std_logic_vector ( 7 downto 0 );
	signal SC_LOAD : std_logic;
	signal SC_RESET : std_logic;
	signal PAR_LOAD : std_logic;
	signal END_LOAD : std_logic;
	signal SC_OUT : std_logic;
begin

	SCPR : process ( CLK )
	begin
		if CLK = '1' and CLK'event then
			if RESET = '1' then
				SC <= "00000000";
			elsif SC_LOAD = '1' then
				SC <= PS2_DATA & SC ( 7 downto 1 ) ;
			end if;
		end if;
	end process;
	
	PARPR : process ( CLK )
	begin
		if CLK = '1' and CLK'event then
			if RESET = '1' or SC_RESET = '1' then
				PAR <= '1';
			elsif SC_LOAD = '1' then
				if PS2_DATA = '1' then
					PAR <= not PAR;
				else
					PAR <= PAR;
				end if;
			end if;
		end if;
	end process;

	PS2_PARPR : process ( CLK )
	begin	
		if CLK = '1' and CLK'event then
			if RESET = '1' or SC_RESET = '1' then
				PS2_PAR <= '0';
			elsif PAR_LOAD = '1' then
				PS2_PAR <= PS2_DATA;
			else
				PS2_PAR <= PS2_PAR;
			end if;
		end if;
	end process;
	
	ENDPR : process ( CLK )
	begin
		if CLK = '1' and CLK'event then
			if RESET = '1' or SC_RESET = '1' then
				PS2_END <= '0';
			elsif END_LOAD = '1' then
				PS2_END <= PS2_DATA;
			else
				PS2_END <= PS2_END;
			end if;
		end if;
	end process;
	
	SC_OUT_PR : process ( CLK )
	begin
		if CLK = '1' and CLK'event then
			if RESET = '1' then
				SCAN_CODE <= "00000000";
			elsif SC_OUT = '1' then
				SCAN_CODE <= SC;
			end if;
		end if;
	end process;
	
	TRANP : process ( STATE, PS2_DATA, PS2_CLK, PAR, PS2_PAR, PS2_END )
	begin
		case STATE is
			when W_START  	=>	if PS2_CLK = '1' then
										NEXT_STATE <= W_START;
									else
										NEXT_STATE <= R_START;
									end if;
			when R_START	=>	if PS2_CLK = '0' then
										NEXT_STATE <= R_START;
									else
										NEXT_STATE <= W_0;
									end if;
			when W_0    	=>	if PS2_CLK = '1' then
										NEXT_STATE <= W_0;
									else
										NEXT_STATE <= R_0;
									end if;
			when R_0    	=>	if PS2_CLK = '0' then
										NEXT_STATE <= R_0;
									else
										NEXT_STATE <= W_1;
									end if;
			when W_1    	=>	if PS2_CLK = '1' then
										NEXT_STATE <= W_1;
									else
										NEXT_STATE <= R_1;
									end if;
			when R_1    	=>	if PS2_CLK = '0' then
										NEXT_STATE <= R_1;
									else
										NEXT_STATE <= W_2;
									end if;
			when W_2    	=>	if PS2_CLK = '1' then
										NEXT_STATE <= W_2;
									else
										NEXT_STATE <= R_2;
									end if;
			when R_2    	=>	if PS2_CLK = '0' then
										NEXT_STATE <= R_2;
									else
										NEXT_STATE <= W_3;
									end if;
			when W_3    	=>	if PS2_CLK = '1' then
										NEXT_STATE <= W_3;
									else
										NEXT_STATE <= R_3;
									end if;
			when R_3    	=>	if PS2_CLK = '0' then
										NEXT_STATE <= R_3;
									else
										NEXT_STATE <= W_4;
									end if;
			when W_4    	=>	if PS2_CLK = '1' then
										NEXT_STATE <= W_4;
									else
										NEXT_STATE <= R_4;
									end if;
			when R_4    	=>	if PS2_CLK = '0' then
										NEXT_STATE <= R_4;
									else
										NEXT_STATE <= W_5;
									end if;
			when W_5    	=>	if PS2_CLK = '1' then
										NEXT_STATE <= W_5;
									else
										NEXT_STATE <= R_5;
									end if;
			when R_5    	=>	if PS2_CLK = '0' then
										NEXT_STATE <= R_5;
									else
										NEXT_STATE <= W_6;
									end if;
			when W_6    	=>	if PS2_CLK = '1' then
										NEXT_STATE <= W_6;
									else
										NEXT_STATE <= R_6;
									end if;
			when R_6    	=>	if PS2_CLK = '0' then
										NEXT_STATE <= R_6;
									else
										NEXT_STATE <= W_7;
									end if;
			when W_7    	=>	if PS2_CLK = '1' then
										NEXT_STATE <= W_7;
									else
										NEXT_STATE <= R_7;
									end if;
			when R_7    	=>	if PS2_CLK = '0' then
										NEXT_STATE <= R_7;
									else
										NEXT_STATE <= W_PAR;
									end if;
			when W_PAR  	=>	if PS2_CLK = '1' then
										NEXT_STATE <= W_PAR;
									else
										NEXT_STATE <= R_PAR;
									end if;
			when R_PAR  	=>	if PS2_CLK = '0' then
										NEXT_STATE <= R_PAR;
									else
										NEXT_STATE <= W_END;
									end if;
			when W_END  	=>	if PS2_CLK = '1' then
										NEXT_STATE <= W_END;
									else
										NEXT_STATE <= R_END;
									end if;
			when R_END  	=>	if PS2_CLK = '0' then
										NEXT_STATE <= R_END;
									else
										if PAR = PS2_PAR and PS2_END = '1' then
											NEXT_STATE <= VALID;
										else
											NEXT_STATE <= W_START;
										end if;
									end if;
			when VALID		=> NEXT_STATE <= W_START;
		end case;
	end process;
	
	STATEP : process ( CLK )
	begin 
		if CLK = '1' and CLK'event then
			if RESET = '1' then
				STATE <= W_START;
			else
				STATE <= NEXT_STATE;
			end if;
		end if;
	end process;
	
	OUTP : process ( STATE, PS2_DATA, PS2_CLK, PAR, PS2_PAR, PS2_END, SC )
	begin
		case STATE is
			when W_START													=> NEW_SC <= '0';
																					SC_LOAD <= '0';
																					SC_RESET <= '0';
																					PAR_LOAD <= '0';
																					END_LOAD <= '0';
																					SC_OUT <= '0';
			when R_START													=>	NEW_SC <= '0';
																					SC_LOAD <= '0';
																					SC_RESET <= '1';
																					PAR_LOAD <= '0';
																					END_LOAD <= '0';
																					SC_OUT <= '0';
			when W_0 | W_1 | W_2 | W_3 | W_4 | W_5 | W_6 | W_7	=>	if PS2_CLK = '0' then
																						SC_LOAD <= '1';
																					else
																						SC_LOAD <= '0';
																					end if;
																					NEW_SC <= '0';
																					SC_RESET <= '0';
																					PAR_LOAD <= '0';
																					END_LOAD <= '0';
																					SC_OUT <= '0';
			when W_PAR  													=>	if PS2_CLK = '0' then
																						PAR_LOAD <= '1';
																					else
																						PAR_LOAD <= '0';
																					end if;
																					NEW_SC <= '0';
																					SC_LOAD <= '0';
																					SC_RESET <= '0';
																					END_LOAD <= '0';
																					SC_OUT <= '0';
			when W_END  													=>	if PS2_CLK = '0' then
																						END_LOAD <= '1';
																					else
																						END_LOAD <= '0';
																					end if;																					
																					NEW_SC <= '0';
																					SC_LOAD <= '0';
																					SC_RESET <= '0';
																					PAR_LOAD <= '0';
																					SC_OUT <= '0';
			when R_END  													=>	if PS2_CLK = '1' and PAR = PS2_PAR and PS2_END = '1' then
																						SC_OUT <= '1';
																					else
																						SC_OUT <= '0';
																					end if;																					
																					NEW_SC <= '0';
																					SC_LOAD <= '0';
																					SC_RESET <= '0';
																					PAR_LOAD <= '0';
																					END_LOAD <= '0';
			when VALID														=> NEW_SC <= '1';
																					SC_LOAD <= '0';
																					SC_RESET <= '0';
																					PAR_LOAD <= '0';
																					END_LOAD <= '0';
																					SC_OUT <= '0';
			when others														=> NEW_SC <= '0';
																					SC_LOAD <= '0';
																					SC_RESET <= '0';
																					PAR_LOAD <= '0';
																					END_LOAD <= '0';
																					SC_OUT <= '0';
		end case;
	end process;

	

end RECEIVER_BODY;

