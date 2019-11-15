----------------------------------------------------------------------------------
-- Company: IC DESIGN LAB
-- Engineer: Carl Valjus
-- 
-- Create Date:    16:06:55 11/28/2018 
-- Design Name: LCD CONTROL MODULE
-- Module Name:    lcd_control - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lcd_control is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           state : in  STD_LOGIC_VECTOR (2 downto 0);
           dcf_valid : in  STD_LOGIC;
			  time_hh : in STD_LOGIC_VECTOR(7 downto 0);
			  time_mm : in STD_LOGIC_VECTOR(7 downto 0);
			  time_ss : in STD_LOGIC_VECTOR(7 downto 0);
			  year : in STD_LOGIC_VECTOR(7 downto 0);
			  month : in STD_LOGIC_VECTOR(7 downto 0);
			  day : in STD_LOGIC_VECTOR(7 downto 0);
			  day_of_the_week : in STD_LOGIC_VECTOR (2 downto 0);
			  alarm_hh : in STD_LOGIC_VECTOR(7 downto 0);
			  alarm_mm : in STD_LOGIC_VECTOR(7 downto 0);
           alarm_state : in  STD_LOGIC_VECTOR(1 downto 0);
           time_switch_time_1 : in  STD_LOGIC_VECTOR (15 downto 0);
           time_switch_time_2 : in  STD_LOGIC_VECTOR (15 downto 0);
           time_switch_state : in  STD_LOGIC;
           countdown_timer_time : in  STD_LOGIC_VECTOR (15 downto 0);
           countdown_state : in  STD_LOGIC;
           stop_watch_time : in  STD_LOGIC_VECTOR (31 downto 0);
           stop_watch_state : in  STD_LOGIC;
           lcd_en : out  STD_LOGIC;
           lcd_rw : out  STD_LOGIC;
           lcd_rs : out  STD_LOGIC;
           lcd_data : out  STD_LOGIC_VECTOR (7 downto 0));
end lcd_control;

architecture Behavioral of lcd_control is
--Components
component lcd_sender
    Port ( clk 		: in STD_LOGIC;
			  reset 		: in STD_LOGIC;
			  data : in  STD_LOGIC_VECTOR (63 downto 0);
           new_data : in  STD_LOGIC;
			  lcd_en : out  STD_LOGIC;
           lcd_rw : out  STD_LOGIC;
           lcd_rs : out  STD_LOGIC;
           lcd_data : out  STD_LOGIC_VECTOR (7 downto 0);
           ready : out  STD_LOGIC);
end component lcd_sender;

component comparer is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           input_data : in  STD_LOGIC_VECTOR (63 downto 0);
           output_data : out  STD_LOGIC_VECTOR (63 downto 0);
           new_data : out  STD_LOGIC;
           ready : in  STD_LOGIC);
end component comparer;

component SELECTOR is
    Port ( state : in  STD_LOGIC_VECTOR (2 downto 0);
           ctime : in  STD_LOGIC_VECTOR (23 downto 0);
           date : in  STD_LOGIC_VECTOR (23 downto 0);
			  day : in STD_LOGIC_VECTOR (2 downto 0);
           alarm_time : in  STD_LOGIC_VECTOR (15 downto 0);
           alarm_state : in  STD_LOGIC_VECTOR (1 downto 0);
           time_switch_time_1 : in  STD_LOGIC_VECTOR (15 downto 0);
           time_switch_time_2 : in  STD_LOGIC_VECTOR (15 downto 0);
           time_switch_state : in  STD_LOGIC;
           countdown_timer_time : in  STD_LOGIC_VECTOR (15 downto 0);
           countdown_state : in  STD_LOGIC;
           stop_watch_time : in  STD_LOGIC_VECTOR (31 downto 0);
           stop_watch_state : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (56 downto 0));
end component SELECTOR;



--internal signals
signal data : std_logic_vector(63 downto 0);
signal mux_data : std_logic_vector(56 downto 0);
signal new_data : std_logic;
signal ready : std_logic;


begin
SENDER: lcd_sender port map(clk,reset,data,new_data,lcd_en,lcd_rw,lcd_rs,lcd_data,ready);
COMPARE: comparer port map(clk => clk,
									reset => reset,
									input_data(2 downto 0) => state,
									input_data(3) => dcf_valid,
									input_data(4) => time_switch_state,
									input_data(6 downto 5) => alarm_state,
									input_data(63 downto 7) => mux_data,
									output_data => data,
									new_data => new_data,
									ready => ready);
MUX: SELECTOR Port map ( state=>state,
									  ctime(7 downto 0)=>time_hh,
									  ctime(15 downto 8)=>time_mm,
									  ctime(23 downto 16)=>time_ss,
									  date(7 downto 0)=>year,
									  date(15 downto 8)=>month,
									  date(23 downto 16)=>day,
									  day=>day_of_the_week,
									  alarm_time(7 downto 0) => alarm_hh,
									  alarm_time(15 downto 8) => alarm_mm,
									  alarm_state=>alarm_state,
									  time_switch_time_1=>time_switch_time_1,
									  time_switch_time_2=>time_switch_time_2,
									  time_switch_state=>time_switch_state,
									  countdown_timer_time=>countdown_timer_time,
									  countdown_state=>countdown_state,
									  stop_watch_time=>stop_watch_time,
									  stop_watch_state=>stop_watch_state,
									  output=>mux_data);

process(clk,reset)
begin
	if(reset='1') then
	end if;
end process;


end Behavioral;

