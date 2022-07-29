


library ieee;
use ieee.std_logic_1164.all;

entity elevator is

	port(
		reset				:in	std_logic;
		start_elevator		:in	std_logic;
		ILB1				:in std_logic;
		ILB2				:in std_logic;
		ILB3				:in std_logic;
		ILB4				:in std_logic;
		OLB1				:in std_logic;
		OLB2				:in std_logic;
		OLB3				:in std_logic;
		OLB4				:in std_logic;		
		man_mov_up			:in std_logic;
		man_mov_down		:in std_logic;
		man_opn_door		:in std_logic;
		man_close_door		:in std_logic;
		man_brake			:in std_logic;
		sns_enter_f1_up		:in	std_logic;
		sns_enter_f2_up		:in	std_logic;
		sns_enter_f3_up		:in	std_logic;
		sns_enter_f2_down	:in	std_logic;
		sns_enter_f3_down	:in	std_logic;
		sns_enter_f4_down	:in	std_logic;
		sns_stopped			:in	std_logic;
		sns_door_closed		:in	std_logic;
		sns_passing     :in std_logic;
		opn_btn         :in std_logic;
		move_up				:out std_logic;
		brake				:out std_logic;
		move_down			:out std_logic;
		opn_door			:out std_logic;
		close_door			:out std_logic
--		move_up				:out std_logic;
--		move_up				:out std_logic;		
	);
	
end entity;

architecture main of elevator is

	-- Build an enumerated type for the state machine
	type main_state_type is ( 
							revision_mode,
							normal_mode							
							);	
	-- Register to hold the current state
	signal state   : main_state_type;
	signal gl_reset :std_logic;
	signal gl_ready_to_move	:std_logic;
	signal gl_move_request	:std_logic;
	signal gl_LB1	:std_logic;
	signal gl_LB2	:std_logic;
	signal gl_LB3	:std_logic;
	signal gl_LB4	:std_logic;
	signal gl_at_F1	:std_logic;
	signal gl_at_F2	:std_logic;
	signal gl_at_F3	:std_logic;
	signal gl_at_F4	:std_logic;
	signal gl_arrive	:std_logic;	
	signal cabin_close_door	:std_logic;
	signal cabin_opn_door	:std_logic;
	signal cntrlr_brake	:std_logic;
	signal cntrlr_mov_down	:std_logic;
	signal cntrlr_mov_up	:std_logic;
	
	component controller is

	port(
		reset    		 	 :in	std_logic;
		ready_to_move :in std_logic;
		stopped		    	:in	std_logic;
		LB1			      	 :in	std_logic;
		LB2   		      :in	std_logic;
		LB3		        	:in	std_logic;
		LB4 			       :in	std_logic;
		enter_F1_up   :in	std_logic;
		enter_F2_up   :in	std_logic;
		enter_F3_up   :in	std_logic;
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
	
	end component;
	
	component BTN is
	port(
		reset	:in	std_logic;
		OLB		:in std_logic;
		ILB		:in std_logic;
		at_floor:in std_logic;
		LB		:out std_logic		
	);
	end component;
	
	component cabin is
	port(
		move_request	: in	std_logic;
		arrive			: in	std_logic;
		door_closed		: in	std_logic;
		open_btn		: in	std_logic;
		passing			: in	std_logic;
		reset			: in	std_logic;
		opn_door		: out	std_logic;
		close_door		: out std_logic;
		ready_to_move	: out std_logic
	);	
	end component;


begin

process(reset,start_elevator,state)
begin
	if (reset  = '1') then 
		state <= revision_mode;
	elsif(state = revision_mode) then
		if(start_elevator = '1') then 
			state <= normal_mode;
		end if;
	end if;
end process;

gl_reset <='1' when state = revision_mode else '0';

move_up <=	man_mov_up		when state = revision_mode else
			cntrlr_mov_up	when state = normal_mode;
	
move_down <=	man_mov_down	when state = revision_mode else
				cntrlr_mov_down when state = normal_mode;
				
opn_door <=	man_opn_door	when state = revision_mode else
			cabin_opn_door	when state = normal_mode;

close_door <=	man_close_door	when state = revision_mode else
			cabin_close_door	when state = normal_mode;

brake <=	man_brake		when state = revision_mode else
			cntrlr_brake	when state = normal_mode;	
gl_arrive <= ((gl_at_F1) OR (gl_at_F2) OR (gl_at_F3) OR (gl_at_F4));

cntrlr : controller port map (
		reset			=> gl_reset,
		ready_to_move 	=> gl_ready_to_move,
		stopped			=> sns_stopped,
		LB1				=> gl_LB1,
		LB2   			=> gl_LB2,
		LB3		    	=> gl_LB3,
		LB4 			=> gl_LB4,
		enter_F1_up 	=> sns_enter_f1_up,
		enter_F2_up 	=> sns_enter_f2_up,
		enter_F3_up 	=> sns_enter_f3_up,
		enter_F2_down	=> sns_enter_f2_down,
		enter_F3_down	=> sns_enter_f3_down,
		enter_F4_down	=> sns_enter_f4_down,
		
		move_request	=> gl_move_request,
		at_F1			=> gl_at_F1,
		at_F2  			=> gl_at_F2,
		at_F3  			=> gl_at_F3,
		at_F4  			=> gl_at_F4,
		brake   		=> cntrlr_brake,
		move_up 		=> cntrlr_mov_up,
		move_down		=>cntrlr_mov_down
								);
								
cbn :cabin port map(
		move_request	=>	gl_move_request,
		arrive			=> 	gl_arrive,
		door_closed		=>	sns_door_closed,
		open_btn		=>	opn_btn,
		passing			=>	sns_passing,
		reset			=>	gl_reset,
		opn_door		=>	cabin_opn_door,
		close_door		=>	cabin_close_door,
		ready_to_move	=>	gl_ready_to_move
					);
					
btn1: BTN 	port map(
		reset		=>	gl_reset,
		OLB			=>	OLB1,
		ILB			=>	ILB1,
		at_floor	=>	gl_at_F1,
		LB			=>	gl_LB1
	);

btn2: BTN 	port map(
		reset		=>	gl_reset,
		OLB			=>	OLB2,
		ILB			=>	ILB2,
		at_floor	=>	gl_at_F2,
		LB			=>	gl_LB2
	);
btn3: BTN 	port map(
		reset		=>	gl_reset,
		OLB			=>	OLB3,
		ILB			=>	ILB3,
		at_floor	=>	gl_at_F3,
		LB			=>	gl_LB3
	);
btn4: BTN 	port map(
		reset		=>	gl_reset,
		OLB			=>	OLB4,
		ILB			=>	ILB4,
		at_floor	=>	gl_at_F4,
		LB			=>	gl_LB4
	);

			
end main;