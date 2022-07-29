library ieee;
use ieee.std_logic_1164.all;

entity cabin is

	port(
		move_request		 : in	std_logic;
		arrive	 : in	std_logic;
		door_closed	 : in	std_logic;
		open_btn	 : in	std_logic;
		passing	 : in	std_logic;
		reset	 : in	std_logic;
		opn_door	 : out	std_logic;
		close_door :out std_logic;
		ready_to_move :out std_logic
	);
	
end entity; 

architecture bhv_cabin of cabin is

	-- Build an enumerated type for the state machine
	type cabin_state_type is (idle, pending_close, movingready);
	
	-- Register to hold the current state
	signal state   : cabin_state_type;

begin
	-- Logic to advance to the next state
	process (move_request,door_closed,arrive,passing,open_btn, reset)
	begin
		if reset = '1' then
			state <= idle;
			opn_door <= '1';
			close_door <= '0';		
		elsif (state = idle ) then
			if (  move_request = '1') then
				close_door <= '1';
				opn_door <= '0';
				state <= pending_close;
			end if;
		elsif(state = pending_close) then
			if(door_closed = '1')then
				opn_door <= '0' ;
				close_door <= '1';
				state <= movingready;  		
			elsif(passing = '1') OR (open_btn = '1') then
				opn_door <= '1';
				close_door <= '0';
				state		<= pending_close;				
				opn_door <= '0' after 2 ns ;
				close_door <= '1' after 2 ns;
				state <= movingready after 2 ns;
			end if;
		elsif(state  = movingready)then 
			if((arrive'event)AND(arrive = '1'))then
				opn_door <= '1';
				close_door <= '0';
				state <= idle;
			end if;
			if(move_request = '1') then
				opn_door <= '0' after 5 ns;
				close_door <= '1' after 5 ns;
				state <= pending_close;
			end if;		
		end if;
	end process;
	
	-- Output depends solely on the current state

	ready_to_move <= '1' when state  = movingready else
	             '0';
end bhv_cabin;

