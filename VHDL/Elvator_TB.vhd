



library ieee;
use ieee.std_logic_1164.all;

entity elevator_tb is
end entity;

architecture bh of elevator_tb is

component elevator is 	
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
		sns_passing    		 :in std_logic;
		opn_btn        		 :in std_logic;
		move_up				:out std_logic;
		brake				:out std_logic;
		move_down			:out std_logic;
		opn_door			:out std_logic;
		close_door			:out std_logic
	);
end component;

signal	tb_reset						: 	std_logic;	
signal	tb_start_elevator					: 	std_logic;	
signal	tb_ILB1					: std_logic;
signal	tb_ILB2					: std_logic;
signal	tb_ILB3							: std_logic;
signal	tb_ILB4					: std_logic;
signal	tb_OLB1					: std_logic;
signal	tb_OLB2					: std_logic;
signal	tb_OLB3					: std_logic;
signal	tb_OLB4					: std_logic;
signal	tb_man_mov_up				: std_logic;
signal	tb_man_mov_down			: std_logic;
signal	tb_man_opn_door			: std_logic;
signal	tb_man_close_door			: std_logic;
signal	tb_man_brake				: std_logic;
signal	tb_sns_enter_f1_up				: 	std_logic;	
signal	tb_sns_enter_f2_up				: 	std_logic;	
signal	tb_sns_enter_f3_up				: 	std_logic;	
signal	tb_sns_enter_f2_down			: 	std_logic;	
signal	tb_sns_enter_f3_down			: 	std_logic;	
signal	tb_sns_enter_f4_down			: 	std_logic;	
signal	tb_sns_stopped					: 	std_logic;	
signal	tb_sns_door_closed				: 	std_logic;	
signal	tb_sns_passing    			: std_logic;
signal	tb_opn_btn        			: std_logic;
signal	tb_move_up					: std_logic;
signal	tb_brake					: std_logic;
signal	tb_move_down				: std_logic;
signal	tb_opn_door				: std_logic;
signal	tb_close_door			: std_logic;


begin
		
test_elev : elevator port map (
		reset				=>tb_reset,				
		start_elevator		=>tb_start_elevator,			
		ILB1				=>tb_ILB1,
		ILB2				=>tb_ILB2,
		ILB3				=>tb_ILB3,				
		ILB4				=>tb_ILB4,
		OLB1				=>tb_OLB1,
		OLB2				=>tb_OLB2,
		OLB3				=>tb_OLB3,
		OLB4				=>tb_OLB4,
		man_mov_up			=>tb_man_mov_up,
		man_mov_down		=>tb_man_mov_down,
		man_opn_door		=>tb_man_opn_door,
		man_close_door		=>tb_man_close_door,	
		man_brake			=>tb_man_brake,
		sns_enter_f1_up		=>tb_sns_enter_f1_up,	
		sns_enter_f2_up		=>tb_sns_enter_f2_up,	
		sns_enter_f3_up		=>tb_sns_enter_f3_up,	
		sns_enter_f2_down	=>tb_sns_enter_f2_down,
		sns_enter_f3_down	=>tb_sns_enter_f3_down,
		sns_enter_f4_down	=>tb_sns_enter_f4_down,
		sns_stopped			=>tb_sns_stopped,	
		sns_door_closed		=>tb_sns_door_closed,	
		sns_passing    		=>tb_sns_passing,	
		opn_btn        		=>tb_opn_btn,	
		move_up				=>tb_move_up,	
		brake				=>tb_brake,
		move_down			=>tb_move_down,
		opn_door			=>tb_opn_door,
		close_door			=>tb_close_door
);

process
begin			
	tb_start_elevator <= '0';	
	tb_ILB1 <= '0';
	tb_ILB2 <= '0';
	tb_ILB3 <= '0';		
	tb_ILB4 <= '0';
	tb_OLB1 <= '0';
	tb_OLB2 <= '0';
	tb_OLB3 <= '0';
	tb_OLB4 <= '0';
	tb_man_mov_up <= '0';
	tb_man_mov_down <= '0';
	tb_man_opn_door <= '0';
	tb_man_close_door <= '0';
	tb_man_brake <= '0';
	tb_sns_enter_f1_up <= '0';
	tb_sns_enter_f2_up <= '0';
	tb_sns_enter_f3_up <= '0';
	tb_sns_enter_f2_down <= '0';
	tb_sns_enter_f3_down <= '0';
	tb_sns_enter_f4_down <= '0';
	tb_sns_stopped <= '1';
	tb_sns_door_closed <= '0';
	tb_sns_passing <= '0';
	tb_opn_btn <= '0';


	tb_reset <= '1';
	wait for 1 ns;
	tb_reset <= '0';
	wait for 1 ns;
	tb_start_elevator<='1';
	wait for 1 ns;
	tb_ILB3 <= '1';
	wait for 1 ns;
	tb_sns_door_closed <= '1';
	tb_ILB3 <= '0';
	tb_sns_stopped <= '0';
	wait for 5 ns;
	tb_sns_enter_f2_down <='1';
	wait for 5 ns;
	tb_sns_enter_f2_down <='0';
	wait for 5 ns;	
	tb_sns_enter_f3_down <='1';
	wait for 1 ns;
	tb_sns_stopped <='1';	
	wait;
end process;
	
	
end bh;		