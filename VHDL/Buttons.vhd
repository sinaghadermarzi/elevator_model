


library ieee;
use ieee.std_logic_1164.all;

entity BTN is

	port(
		reset	:in	std_logic;
		OLB		:in std_logic;
		ILB		:in std_logic;
		at_floor:in std_logic;
		LB		:out std_logic
		
	);
	
end entity;

architecture BTN_behv_FSM of BTN is

	-- Build an enumerated type for the state machine
	type BTN_state_type is ( 
							BTN_off,
							BTN_on							
							);
	
	-- Register to hold the current state
	signal state   : BTN_state_type;

begin
	-- Logic to advance to the next state
  process(
			reset,
			ILB,
			OLB,
			state,
			at_floor
			   )
	begin
		if (reset = '1') then
		  state <= BTN_off;
		elsif(state = BTN_off) then
			if((ILB = '1' )OR(OLB = '1')) then
				state <= BTN_on;
			end if;
		elsif(state = BTN_on) then
			if(at_floor = '1') then
				state <=BTN_off;
			end if;
		end if;
	end process;
LB 	<= '1' when state = BTN_on else
		'0';

	
end BTN_behv_FSM;

