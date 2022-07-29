-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;

entity controller is

	port(
		reset    		 	 :in	std_logic;
		ready_to_move :in std_logic;
		stopped		    	:in	std_logic;
		LB1		      	 :in	std_logic;
		LB2   		      :in	std_logic;
		LB3	        	:in	std_logic;
		LB4 	       :in	std_logic;
		enter_F1_up   	:in	std_logic;
		enter_F2_up   	:in	std_logic;
		enter_F3_up  	 :in	std_logic;
		enter_F2_down	:in	std_logic;
		enter_F3_down	:in	std_logic;
		enter_F4_down	:in	std_logic;
		
		move_request  :out	std_logic;
		at_F1		  :out	std_logic;
		at_F2  			:out	std_logic;
		at_F3  			:out	std_logic;
		at_F4  			:out	std_logic;
		brake         :out	std_logic;
		move_up       :out std_logic;
		move_down     :out std_logic	
	);
	
end entity;

architecture controller_behv_FSM of controller is

	-- Build an enumerated type for the state machine
	type mc_state_type is (F1, F2, F3, F4,
							F1_up_pending,F2_up_pending,F3_up_pending,
							F2_down_pending,F3_down_pending,F4_down_pending,
							F1_up_F2_braking,F2_up_F3_braking,F3_up_F4_braking,
							F1_up_F2,F2_up_F3,F3_up_F4,
							F2_down_F1_braking,F3_down_F2_braking,F4_down_F3_braking,
							F2_down_F1,F3_down_F2,F4_down_F3
							);
	
	-- Register to hold the current state
	signal state   : mc_state_type;
	
	

begin
	-- Logic to advance to the next state
  process(
           reset,
	         ready_to_move,
	       		stopped,
  	      		LB1,		
        			LB2,			
	      			LB3,			
       				LB4,			
       				enter_F1_up,		
    			    enter_F2_up,	
		     	 enter_F3_up,	
				   enter_F2_down,	
		      	enter_F3_down,	
				   enter_F4_down,
			    	state
			   )
	begin
		if (reset = '1') then
		  state <= F1;
		  move_request <='0';
		  at_F1	<='1';	
		  at_F2  <='0';		
		  at_F3  <='0'	;	
		  at_F4  <='0'	;		
		  brake  <='0'	;     
		  move_up     <='0'	;
		  move_down  <='0'	;
		  		  
		elsif(state = F1) then
			if((LB2 = '1') OR (LB3 = '1') OR (LB4 = '1'))then
				move_request <= '1';
				state <= F1_up_pending;			
			end if; 
			
		elsif(state = F2) then
			if((LB3 = '1') OR (LB4 = '1'))then
				move_request <= '1';
				state <= F2_up_pending;				 
			elsif((LB1 = '1')) then
				move_request <='1';
				state <=F2_down_pending;
			end if;
			
		elsif(state = F3) then
			if((LB4 = '1')) then
				move_request <= '1';
				state <= F3_up_pending;				
			elsif((LB2 = '1')OR(LB1 = '1')) then
				move_request <='1';
				state <=F3_down_pending;
			end if;
			
		elsif(state = F4) then
			if((LB1 = '1') OR (LB2 = '1') OR (LB3 = '1')) then
				move_request <= '1';
				state <= F4_down_pending;				
			end if;
			
		elsif(state = F1_up_pending) then
			if(ready_to_move = '1') then
				move_request <= '0';
				move_up <= '1';
				state <= F1_up_F2;
				at_F1 <= '0';
			end if;
			
		elsif(state = F2_up_pending) then
			if(ready_to_move = '1') then
				move_request <= '0';
				move_up <= '1';
				state <= F2_up_F3;
				at_F2 <= '0';
			end if;
			
		elsif(state = F3_up_pending) then
			if(ready_to_move = '1') then
				move_request <= '0';
				move_up <= '1';
				state <= F3_up_F4;
				at_F3 <= '0';
			end if;
			

		elsif(state = F4_down_pending) then
			if(ready_to_move = '1') then
				move_request <= '0';
				move_down <= '1';
				state <= F4_down_F3;
				at_F4 <= '0';
			end if;
			
		elsif(state = F3_down_pending) then
			if(ready_to_move = '1') then
				move_request <= '0';
				move_down <= '1';
				state <= F3_down_F2;
				at_F3 <= '0';				
			end if;
			
		elsif(state = F2_down_pending) then
			if(ready_to_move = '1') then
				move_request <= '0';
				move_down <= '1';
				state <= F2_down_F1;
				at_F2 <= '0';				
			end if;
			
		elsif(state = F1_up_F2) then
			if(enter_F2_down = '1') then
				if(LB2 = '1') then
					move_up <= '0';
					brake <= '1';
					state <= F1_up_F2_braking;
				elsif(LB2 = '0') then
					state <= F2_up_F3; 
				end if;
			end if;
		elsif(state = F2_up_F3) then
			if(enter_F3_down = '1') then
				if(LB3 = '1') then
					move_up <= '0';
					brake <= '1';
					state <= F2_up_F3_braking;
				elsif(LB2 = '0') then
					state <= F3_up_F4;
				end if;
			end if;
				
		elsif(state = F3_up_F4) then
			if(enter_F4_down = '1') then
				move_up <= '0';
				brake <= '1';
				state <= F2_up_F3_braking;
			end if;
			
		elsif(state = F2_down_F1) then
			if(enter_F1_up = '1') then
				move_down <= '0';
				brake <= '1';
				state <= F2_down_F1_braking;
			end	if;		
			
		elsif(state = F3_down_F2) then
			if(enter_F2_up = '1') then
				if(LB2 = '1')then
					move_down <= '0';
					brake <= '1';
					state <= F3_down_F2_braking;
				elsif(LB2 = '0') then
					state <= F2_down_F1;
				end if;
			end if;

		elsif(state = F4_down_F3) then
			if(enter_F3_up = '1') then
				if(LB3 = '1') then
					move_down <= '0';
					brake <= '1';
					state <= F4_down_F3_braking;
				elsif(LB2 = '0') then
					state <= F3_down_F2;
				end if;
			end if;
			
		elsif(state = F1_up_F2_braking) then
			if(stopped = '1') then
				at_F2 <= '1';
				if((LB3 = '1') OR (LB4 = '1')) then
					move_request <= '1';
					state <= F2_up_pending;				
				elsif((LB3 = '0') AND (LB4 = '0')) then
					state <= F2;

				end if;
			end if;
			
		elsif(state = F2_up_F3_braking) then
			if(stopped = '1') then
				at_F3 <= '1';
				if(LB4 = '1') then
					move_request <= '1';
					state <= F3_up_pending;				
				elsif(LB4 = '0') then
					state <= F3;

				end if;
			end if;
		elsif(state = F3_up_F4_braking) then
    		if(stopped = '1') then
			state <= F4;
			at_F4 <= '1';
		  end if;
		  
		elsif(state = F4_down_F3_braking) then
			if(stopped = '1') then
 				at_F3 <='1';
				if((LB2 = '1') OR (LB1 = '1')) then
					move_request <= '1';
					state <= F3_down_pending;				
				elsif((LB2 = '0') AND (LB1 = '0')) then
					state <= F3;

				end if;
			end if;

		elsif(state = F3_down_F2_braking) then
			if(stopped = '1') then
								at_F2 <='1';		
				if(LB1 = '1') then
					move_request <= '1';
					state <= F2_down_pending;				
				elsif(LB4 = '0') then
					state <= F2;

				end if;
			end if;
			
		elsif(state = F2_down_F1_braking) then
      if(stopped = '1') then
		  	state <= F1;
			at_F1 <= '1';
	   	end if;
	  end if;
	end process;

end controller_behv_FSM;
