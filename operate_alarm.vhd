----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    19:08:10 12/17/2018
-- Design Name:
-- Module Name:    operate_alarm - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity operate_alarm is
    Port ( mode_fsm : in  STD_LOGIC;
           mode : in  STD_LOGIC;
           time_mm : in  STD_LOGIC_VECTOR (7 downto 0);
           time_ss : in  STD_LOGIC_VECTOR (7 downto 0);
           action_imp : in  STD_LOGIC;
           action_long : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  clk1: in std_logic;
           rst : in  STD_LOGIC;
           set_time_mm : in  STD_LOGIC_VECTOR (7 downto 0);
           set_time_ss : in  STD_LOGIC_VECTOR (7 downto 0);
			  time_count: in  STD_LOGIC_VECTOR (7 downto 0);
			  activate_counter: out std_logic;
			  activate_set: out std_logic;
           led_alarm_act : out  STD_LOGIC;
           led_alarm_ring : out  STD_LOGIC;
			  lcd_z:out std_logic;
			  alarm_ring: out std_logic);

end operate_alarm;

architecture Behavioral of operate_alarm is

type state_type is (display,set_time,active,ring,snooze,inactive);
signal cst: state_type;
signal next_state: state_type;
signal count:integer;
signal blink:std_logic;
signal alarmring : std_logic;

begin
alarm_fsm:process(clk,rst,action_imp,action_long,mode_fsm,mode,set_time_mm,set_time_ss,time_mm,time_ss)
begin
if rst='1' then
	alarmring<='0';
elsif rising_edge(clk) then
	lcd_z<='0';
 case cst is
  when display =>
                 led_alarm_act<='0';
					  alarmring<='0';
					  --led_alarm_ring<='0';
                if (mode_fsm='1') then next_state<= set_time;
                else next_state<= display;
                end if;
  when set_time =>
                led_alarm_act<='0';
					 alarmring<='0';
					 --led_alarm_ring<='0';
					 activate_set<='1';
                if(action_imp='1') then
					 next_state<= active;
					 activate_set<='0';
					 elsif(mode='1') then next_state<=display;
--                elsif(action_imp='0') then
--					 next_state<= inactive;
--					 activate_set<='0';
                else
					 next_state<= set_time;
                end if;
  when active =>
               led_alarm_act<='1';
					alarmring<='0';
					--led_alarm_ring<='0';
               if(time_mm=set_time_mm and time_ss=set_time_ss) then next_state<= ring;
					elsif(action_imp='1') then
				   next_state<= inactive;
				   activate_set<='0';
					elsif(mode='1') then next_state<=display;
               else next_state<= active;
               end if;
  when ring =>
             led_alarm_act<='1';
				 alarmring<='1';
				 activate_counter<='1';
				 if(time_mm/=set_time_mm and time_ss/=set_time_ss) then next_state<= active;
				 elsif(action_imp='0' and time_count="00111100") then
				 next_state<= active;
             elsif(action_imp='1') then next_state<= snooze;
				 elsif(action_long='1') then next_state<= active;
             else next_state<= ring;
             end if;
  when snooze =>
               led_alarm_act<='1';
					alarmring<='0';
					--led_alarm_ring<='0';
					lcd_z<='1';
               activate_counter<='1';
               if(action_imp='1' or time_count>="00111100") then
					next_state<= ring;
					activate_counter<='0';
               else next_state<= snooze;
               end if;
  when inactive =>
                 led_alarm_act<='0';
					  alarmring<='0';
					  --led_alarm_ring<='0';
                 if(action_imp='1') then next_state<= active;
                 else next_state<= inactive;
                 end if;
  when others =>
               led_alarm_act<='0';
					alarmring<='0';
					 --led_alarm_ring<='0';
               next_state <= display;
 end case;
 end if;
end process;
state: process(clk)
begin
if rising_edge(clk) then
if(rst = '1') then
cst <= display;
else
cst<=next_state;
end if;
end if;
end process;

led_counter: process(clk1,cst)
--count<=0;
begin
if(rst='1') then count<=0;
end if;
if rising_edge(clk1) then
if (cst=ring) then
 count<=count+1;
 if(count=0) then led_alarm_ring<='1';
 elsif(count=5) then led_alarm_ring<='0';
 elsif(count=10) then count<=0;
 end if;
else
led_alarm_ring<='0';
count <= 0;
end if;

end if;
end process;


process(clk,clk1,rst, alarmring)
variable counter : integer := 0;
	begin
	if (rst='1') then
		counter := 0;
		alarm_ring<='0';
	elsif rising_edge(clk) then
	
		if rising_edge(clk1) then
			counter := counter + 1;
		end if;
		
		
		--to test
		if alarmring = '1' then
			alarm_ring<='1';
			counter := 0;
		else
			alarm_ring<='0';
		end if;
		--end test
		
		
		--to test
		--if counter > 1000 then
		--	alarm_ring<='1';
		--	counter := 0;
		--end if;
		--end test
		
	end if;
end process;
end Behavioral;