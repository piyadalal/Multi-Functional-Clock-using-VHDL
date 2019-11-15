--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:03:57 12/04/2018
-- Design Name:   
-- Module Name:   /nas/ei/home/ge34med/Documents/icdesign/skeleton/lcd_control_tb.vhd
-- Project Name:  Projlab
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: lcd_control
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use STD.textio.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

use WORK.ddram_package.all;

ENTITY system_tb IS
END system_tb;
 
ARCHITECTURE behavior OF system_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT lcd_control
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         state : IN  std_logic_vector(2 downto 0);
         dcf_valid : IN  std_logic;
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
         lcd_en : OUT  std_logic;
         lcd_rw : OUT  std_logic;
         lcd_rs : OUT  std_logic;
         lcd_data : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    
    component display is
    Port (  clk : in std_logic;
            reset : in std_logic;
            lcd_en : in std_logic;
            lcd_rs : in std_logic;
            lcd_data : in std_logic_vector(7 downto 0);
            ddram : out ddram_x_y;
            finished : out std_logic
            );
    end component;
    
    component global_fsm is port(
		clk                    : in  std_logic;
           reset                  : in  std_logic;
           en_100                 : in  std_logic;
           act_done               : in  std_logic;
           key_mode_imp           : in  std_logic;       
			  key_minus_imp          : in  std_logic;
           key_plus_imp           : in  std_logic;
	   start_time             : out std_logic;
	   start_time_date        : out std_logic;
	   start_alarm_clock      : out std_logic;
	   start_time_switch      : out std_logic;
	   start_counterdown_time : out std_logic;
	   start_stop_watch       : out std_logic;
	   status_out	          : out std_logic_vector(2 downto 0)
		);
		end component;
		
	
	
	component alarmclock is
    Port ( mode_fsm : in  STD_LOGIC;
           time_mm : in  STD_LOGIC_VECTOR (7 downto 0);
           time_ss : in  STD_LOGIC_VECTOR (7 downto 0);
           action_long : in  STD_LOGIC;
           action_imp : in  STD_LOGIC;
           plus_imp : in  STD_LOGIC;
           minus_imp : in  STD_LOGIC;
           mode : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  clk1: in std_logic;
			  clk2: in std_logic;
           bcd_mm : out  STD_LOGIC_VECTOR (7 downto 0);
           bcd_ss : out  STD_LOGIC_VECTOR (7 downto 0);
           led_alarm_act : out  STD_LOGIC;
           led_alarm_ring : out  STD_LOGIC;
			  lcd_z:out std_logic;
			  alarm_ring: out std_logic);
	end component;
	
	
	component dat_time is
    Port ( en_1 : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           de_set : in  STD_LOGIC;
           de_day : in  STD_LOGIC_VECTOR (5 downto 0);
           de_month : in  STD_LOGIC_VECTOR (4 downto 0);
           de_year : in  STD_LOGIC_VECTOR (7 downto 0);
           de_hour : in  STD_LOGIC_VECTOR (5 downto 0);
           de_min : in  STD_LOGIC_VECTOR (6 downto 0);
           de_dow : in  STD_LOGIC_VECTOR (2 downto 0);
           valid : out  STD_LOGIC;
           dow : out  STD_LOGIC_VECTOR (2 downto 0);
           day : out  STD_LOGIC_VECTOR (5 downto 0);
           month : out  STD_LOGIC_VECTOR (4 downto 0);
           year : out  STD_LOGIC_VECTOR (7 downto 0);
           hour : out  STD_LOGIC_VECTOR (5 downto 0);
           minute : out  STD_LOGIC_VECTOR (6 downto 0);
           second : out  STD_LOGIC_VECTOR (6 downto 0));
	end component;
	
	component clock_gen is
    Port ( clk : in  STD_LOGIC;
           clk_10K : out  STD_LOGIC;
           en_1K : out  STD_LOGIC;
           en_100 : out  STD_LOGIC;
           en_10 : out  STD_LOGIC;
           en_1 : out  STD_LOGIC);
  end component;
    

   --Inputs
   signal clkg : std_logic := '0';
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal lcd_en : std_logic;
   signal lcd_rw : std_logic;
   signal lcd_rs : std_logic;
   signal lcd_data : std_logic_vector(7 downto 0);
   signal ddram : ddram_x_y;
   signal finished : std_logic;
   
   signal current_character : character := 'i';

  	signal key_action_imp : std_logic := '0';
	signal key_action_long : std_logic := '0';
	signal key_mode_imp : std_logic := '0';
	signal key_minus_imp : std_logic := '0';
	signal key_plus_imp : std_logic := '0';
	signal key_plus_minus : std_logic := '0';
	signal key_enable : std_logic := '0';

	signal de_set : std_logic := '0';
	signal de_dow : std_logic_vector (2 downto 0) := (others => '0');
	signal de_day : std_logic_vector (5 downto 0) := (others => '0');
	signal de_month : std_logic_vector (4 downto 0) := (others => '0');
	signal de_year : std_logic_vector (7 downto 0) := (others => '0');
	signal de_hour : std_logic_vector (5 downto 0) := (others => '0');
	signal de_min : std_logic_vector (6 downto 0) := (others => '0');
	
	
	
		signal state : STD_LOGIC_VECTOR (2 downto 0);
   signal dcf_valid : STD_LOGIC;
   signal time_hh : STD_LOGIC_VECTOR(7 downto 0);
	signal time_mm : STD_LOGIC_VECTOR(7 downto 0);
	signal time_ss : STD_LOGIC_VECTOR(7 downto 0);
   signal year : STD_LOGIC_VECTOR(7 downto 0);
	signal month : STD_LOGIC_VECTOR(7 downto 0);
	signal day : STD_LOGIC_VECTOR(7 downto 0);
	signal day_of_the_week : STD_LOGIC_VECTOR (2 downto 0);
   signal alarm_hh : STD_LOGIC_VECTOR(7 downto 0);
	signal alarm_mm : STD_LOGIC_VECTOR(7 downto 0);
   signal alarm_state : STD_LOGIC_VECTOR(1 downto 0);
   signal time_switch_time_1 : STD_LOGIC_VECTOR (15 downto 0);
   signal time_switch_time_2 : STD_LOGIC_VECTOR (15 downto 0);
   signal time_switch_state : STD_LOGIC;
   signal countdown_timer_time : STD_LOGIC_VECTOR (15 downto 0);
   signal countdown_state : STD_LOGIC;
   signal stop_watch_time : STD_LOGIC_VECTOR (31 downto 0);
   signal stop_watch_state : STD_LOGIC;
	signal act_done : STD_LOGIC;
	signal start_time : STD_LOGIC;
	signal start_time_date : STD_LOGIC;
	signal start_alarm_clock : STD_LOGIC;
	signal start_time_switch : STD_LOGIC;
	signal start_counterdown_time : STD_LOGIC;
	signal start_stop_watch : STD_LOGIC;
	
  signal clk_10k,en_1K,en_100,en_10,en_1 : std_logic;
	
	signal alarm_ring : STD_LOGIC := '0';
	
	signal led_alarm_ring : std_logic;
	signal led_alarm_act : std_logic;
	
	signal counter : integer;
	signal counter2 : integer;

   -- Clock period definitions
   constant clk_period : time := 2 ns;
   file file_RESULTS : text;
 
BEGIN
  file_open(file_RESULTS, "testlog_system.txt", write_mode);
 
	-- Instantiate the Unit Under Test (UUT)
   uut: lcd_control PORT MAP (
          clk => clk,
          reset => reset,
          state => state,
          dcf_valid => dcf_valid,
          time_hh => time_hh,
			    time_mm => time_mm,
			    time_ss => time_ss,
			    year => year,
			    month => month,
			    day => day,
			    day_of_the_week => day_of_the_week,
			    alarm_hh => alarm_hh,
			    alarm_mm => alarm_mm,
          alarm_state => alarm_state,
          time_switch_time_1 => time_switch_time_1,
          time_switch_time_2 => time_switch_time_2,
          time_switch_state => time_switch_state,
          countdown_timer_time => countdown_timer_time,
          countdown_state => countdown_state,
          stop_watch_time => stop_watch_time,
          stop_watch_state => stop_watch_state,
          lcd_en => lcd_en,
          lcd_rw => lcd_rw,
          lcd_rs => lcd_rs,
          lcd_data => lcd_data
        );
globalFSM: global_fsm port map(
			  clk => clk,
           reset => reset,
           en_100 => en_100,
           act_done => act_done,
           key_mode_imp => key_mode_imp,
           			  key_minus_imp=> key_minus_imp,
           key_plus_imp => key_plus_imp,
			  start_time  => start_time,
			  start_time_date => start_time_date,
			  start_alarm_clock => start_alarm_clock,
			  start_time_switch => start_time_switch,
			  start_counterdown_time => start_counterdown_time,
			  start_stop_watch => start_stop_watch,
			  status_out	=>state
);
dateandtime : dat_time port map( 
				en_1 => en_1,
           reset => reset,
           de_set => de_set,
           de_day => de_day,
           de_month => de_month,
           de_year => de_year,
           de_hour => de_hour,
           de_min => de_min,
           de_dow => de_dow,
           valid => dcf_valid,
           dow => day_of_the_week,
           day => day( 5 downto 0),
           month => month(4 downto 0),
           year => year,
           hour => time_hh(5 downto 0),
           minute => time_mm(6 downto 0),
           second => time_ss(6 downto 0));

alarm : alarmclock port map(mode_fsm => start_alarm_clock,
           time_mm => time_hh,
           time_ss => time_mm,
           action_long => key_action_long,
           action_imp => key_action_imp,
           plus_imp => key_plus_imp,
           minus_imp => key_minus_imp,
           mode => key_mode_imp,
           rst => reset,
           clk => clk,
			  clk1 => en_10,
			  clk2 => en_1,
			  bcd_mm(7 downto 0) => alarm_hh,
           bcd_ss(7 downto 0) => alarm_mm,
           led_alarm_act => alarm_state(0),
           led_alarm_ring => led_alarm_ring,
			  lcd_z => alarm_state(1),
			  alarm_ring => alarm_ring);
			  

led_alarm_act <= alarm_state(0);
			
		
time_hh(7 downto 6) <= "00";
time_mm(7) <= '0';
time_ss(7) <= '0';
day(7 downto 6) <= "00";
month(7 downto 5) <= "000";
        
  display_model : display port map (clk => clk,
            reset => reset,
            lcd_en => lcd_en,
            lcd_rs => lcd_rs,
            lcd_data => lcd_data,
            ddram => ddram,
            finished => finished
                       );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
    clk_process221 :process
   begin
		clk_10k <= '0';
		wait for 10*clk_period/2;
		clk_10k <= '1';
		wait for 10*clk_period/2;
   end process;
   
   
       clk_process4 :process
   begin
		en_1k <= '0';
		wait for 100*clk_period/2;
		en_1k <= '1';
		wait for 100*clk_period/2;
   end process;
   
   
          clk_process32 :process
   begin
		en_100 <= '0';
		wait for 1000*clk_period/2;
		en_100 <= '1';
		wait for 1000*clk_period/2;
   end process;
   
    clk_processs2 :process
   begin
		en_10 <= '0';
		wait for 10000*clk_period/2;
		en_10 <= '1';
		wait for 10000*clk_period/2;
   end process;
   
  clk_process1 :process
   begin
		en_1 <= '0';
		wait for 100000*clk_period/2;
		en_1 <= '1';
		wait for 100000*clk_period/2;
   end process;

  --Test stuff
   reset <= '1' after 0 ns, '0' after 10 ns;
   
   testcases : process
   begin
     
  wait for 500000*clk_period;
  de_set <= '0';
  de_dow <= "001";
  de_day <= "000001";
  de_month <= "00001";
  de_year <= "10011011";
  de_hour <= "000010";
  de_min <= "0000010";
  wait for clk_period;
  de_set <= '0';
  wait for 500000*clk_period;
  wait for clk_period;
  key_mode_imp <= '1';
    wait for clk_period;
  key_mode_imp <= '0';
  wait for 10000*clk_period;
  wait for clk_period;
  key_mode_imp <= '1';
  wait for 1*clk_period;
  key_mode_imp <= '0';
  wait for clk_period;
  end process;
   
	--To be used if we implement the rest of the functions...
   time_switch_time_1 <= (others => '0');
   time_switch_time_2 <= (others => '0');
	time_switch_state <='0';
	countdown_timer_time <= (others => '0');
	countdown_state <= '0';
	stop_watch_time <= (others => '0');
	stop_watch_state <= '0';  
   
   
   process(reset,clk, state)
	variable counter : integer;
	begin
	
		if reset = '1' then
			counter := 0;
			act_done <= '1';
		elsif (clk'event and clk = '1') then
		
			
		
			if (state = "010") then
				if alarm_ring = '1' then
					act_done <= '1';
				else
					act_done <= '0';
				end if;
			elsif (state = "001" or state = "011" or state = "100" or state = "101" or state = "110") then
				if(en_1 = '1') then
					counter := counter + 1;
				else
					counter := counter;
				end if;
				if (counter = 3) then
					act_done <= '1';
					counter := 0;
				else
					act_done <= '0';
				end if;
			end if;
			
		end if;
	end process;
   
   process(key_mode_imp)
      variable v_OLINE     : line;
     begin
       if(key_mode_imp = '1') then
        write(v_OLINE,"Mode key pressed at : " &time'image(now));
        writeline(file_RESULTS,v_OLINE);
      end if;
     end process;
   
   --Print process;
   process(clk)
     
     variable v_OLINE     : line;
     begin
       if(rising_edge(clk) and finished = '1') then
        write(v_OLINE,string'("____________________________________________________________"));
        writeline(file_RESULTS,v_OLINE);
        write(v_OLINE,"new frame at " &time'image(now));
        writeline(file_RESULTS,v_OLINE);
        write(v_OLINE,string'("The current inputs to the display control module is"));
        writeline(file_RESULTS,v_OLINE);
        writeline(file_RESULTS,v_OLINE);
        write(v_OLINE,string'("Current State:"));
        case state is 
        when "000" => write(v_OLINE,string'("Time only"));
        when "001" => write(v_OLINE,string'("Time & date"));
        when "010" => write(v_OLINE,string'("Alarm"));
        when "011" => write(v_OLINE,string'("Time switch on time"));
        when "100" => write(v_OLINE,string'("Time switch off time"));
        when "101" => write(v_OLINE,string'("Countdown timer"));
        when "110" => write(v_OLINE,string'("Stopwatch"));
        when others => 
        write(v_OLINE,string'("INVALID STATE"));
        report "state NOT defined";
        end case;
        writeline(file_RESULTS,v_OLINE);
        
        write(v_OLINE,string'("Time:"));
        write(v_OLINE,to_integer(unsigned(time_hh(7 downto 4))));
        write(v_OLINE,to_integer(unsigned(time_hh(3 downto 0))));
        write(v_OLINE,string'(":"));
        write(v_OLINE,to_integer(unsigned(time_mm(7 downto 4))));
        write(v_OLINE,to_integer(unsigned(time_mm(3 downto 0))));
        write(v_OLINE,string'(":"));
        write(v_OLINE,to_integer(unsigned(time_ss(7 downto 4))));
        write(v_OLINE,to_integer(unsigned(time_ss(3 downto 0))));
        write(v_OLINE,string'(" Alarm:"));
        write(v_OLINE,to_integer(unsigned(alarm_hh(7 downto 4))));
        write(v_OLINE,to_integer(unsigned(alarm_hh(3 downto 0))));
        write(v_OLINE,string'(":"));
        write(v_OLINE,to_integer(unsigned(alarm_mm(7 downto 4))));
        write(v_OLINE,to_integer(unsigned(alarm_mm(3 downto 0))));
        write(v_OLINE,string'(":"));
        write(v_OLINE,string'("Date:"));
        write(v_OLINE,to_integer(unsigned(day(7 downto 4))));
        write(v_OLINE,to_integer(unsigned(day(3 downto 0))));
        write(v_OLINE,string'("/"));
        write(v_OLINE,to_integer(unsigned(month(7 downto 4))));
        write(v_OLINE,to_integer(unsigned(month(3 downto 0))));
        write(v_OLINE,string'("/"));
        write(v_OLINE,to_integer(unsigned(year(7 downto 4))));
        write(v_OLINE,to_integer(unsigned(year(3 downto 0))));
        write(v_OLINE,string'("-"));
        write(v_OLINE,string'(" -- "));
        case day_of_the_week is
        when "001" => write(v_OLINE,string'("Monday"));
          when "010" => write(v_OLINE,string'("Tuesday"));
            when "011" => write(v_OLINE,string'("Wednsday"));
              when "100" => write(v_OLINE,string'("Thursday"));
                when "101" => write(v_OLINE,string'("Friday"));
                when "110" => write(v_OLINE,string'("Saturday"));
                  when "111" => write(v_OLINE,string'("Sunday"));
                when others => write(v_OLINE,string'("invalid weekday"));
        end case;
        writeline(file_RESULTS,v_OLINE);
        write(v_OLINE,string'("Alarm is "));
        case alarm_State is
        when "01" => write(v_OLINE,string'("Active"));
        when "10" => write(v_OLINE,string'("Snooze"));
        when "11" => write(v_OLINE,string'("Snooze"));
        when "00" => write(v_OLINE,string'("Inactive"));
        when others => write(v_OLINE,string'("invalid weekday"));
        end case;
        writeline(file_RESULTS,v_OLINE);
        
        
        write(v_OLINE,string'("Time Switch is "));
        case time_switch_state is
        when '1' => write(v_OLINE,string'("Active"));
        when others => write(v_OLINE,string'("Inactive"));
        end case;
        writeline(file_RESULTS,v_OLINE);
        
        write(v_OLINE,string'("Countdown is "));
        case countdown_state is
        when '1' => write(v_OLINE,string'("On"));
        when others => write(v_OLINE,string'("Off"));
        end case;
        writeline(file_RESULTS,v_OLINE);
        
        write(v_OLINE,string'("Stopwatch is "));
        case stop_watch_state is
        when '1' => write(v_OLINE,string'("showing lap time"));
        when others => write(v_OLINE,string'("not showing lap time"));
        end case;
        writeline(file_RESULTS,v_OLINE);
        
        write(v_OLINE,string'("DCF is "));
        case dcf_valid is
        when '1' => write(v_OLINE,string'("valid"));
        when others => write(v_OLINE,string'("not valid"));
        end case;
        writeline(file_RESULTS,v_OLINE);
        writeline(file_RESULTS,v_OLINE);
        write(v_OLINE,string'("And the display is showing"));
        writeline(file_RESULTS,v_OLINE);
        
        for y in 0 to 3 loop
        for x in 0 to 19 loop
        write(v_OLINE,"|" & ddram(x,y) & "|");
      end loop;
      writeline(file_RESULTS,v_OLINE);
      end loop;
      write(v_OLINE,string'("____________________________________________________________"));
      writeline(file_RESULTS,v_OLINE);
      write(v_OLINE,lf & lf & lf & lf);
      writeline(file_RESULTS,v_OLINE);
     end if;
   end process;
      
  process(lcd_data)
    begin
    if(lcd_rs = '1') then
    case lcd_data is
        when "01000001" => current_character <= 'A';
				when "01000010" => current_character <= 'B';
				when "01000011" => current_character <= 'C';
				when "01000100" => current_character <= 'D';
				when "01000101" => current_character <= 'E';
				when "01000110" => current_character <= 'F';
				when "01000111" => current_character <= 'G';
				when "01001000" => current_character <= 'H';
				when "01001001" => current_character <= 'I';
				when "01001010" => current_character <= 'J';
				when "01001011" => current_character <= 'K';
				when "01001100" => current_character <= 'L';
				when "01001101" => current_character <= 'M';
				when "01001110" => current_character <= 'N';
				when "01001111" => current_character <= 'O';
				when "01010000" => current_character <= 'P';
				when "01010001" => current_character <= 'Q';
				when "01010010" => current_character <= 'R';
				when "01010011" => current_character <= 'S';
				when "01010100" => current_character <= 'T';
				when "01010101" => current_character <= 'U';
				when "01010110" => current_character <= 'V';
				when "01010111" => current_character <= 'W';
				when "01011000" => current_character <= 'X';
				when "01011001" => current_character <= 'Y';
				when "01011010" => current_character <= 'Z';
				when "01100001" => current_character <= 'a';
				when "01100010" => current_character <= 'b';
				when "01100011" => current_character <= 'c';
				when "01100100" => current_character <= 'd';
				when "01100101" => current_character <= 'e';
				when "01100110" => current_character <= 'f';
				when "01100111" => current_character <= 'g';
				when "01101000" => current_character <= 'h';
				when "01101001" => current_character <= 'i';
				when "01101010" => current_character <= 'j';
				when "01101011" => current_character <= 'k';
				when "01101100" => current_character <= 'l';
				when "01101101" => current_character <= 'm';
				when "01101110" => current_character <= 'n';
				when "01101111" => current_character <= 'o';
				when "01110000" => current_character <= 'p';
				when "01110001" => current_character <= 'q';
				when "01110010" => current_character <= 'r';
				when "01110011" => current_character <= 's';
				when "01110100" => current_character <= 't';
				when "01110101" => current_character <= 'u';
				when "01110110" => current_character <= 'v';
				when "01110111" => current_character <= 'w';
				when "01111000" => current_character <= 'x';
				when "01111001" => current_character <= 'y';
				when "01111010" => current_character <= 'z';
				when "00101111" => current_character <= '/';
				when "00111010" => current_character <= ':';
				when "00101110" => current_character <= '.';
				when "00101010" => current_character <= '*';
				when "00010000" => current_character <= ' ';
				when "00110000" => current_character <= '0';
				when "00110001" => current_character <= '1';
				when "00110010" => current_character <= '2';
				when "00110011" => current_character <= '3';
				when "00110100" => current_character <= '4';
				when "00110101" => current_character <= '5';
				when "00110110" => current_character <= '6';
				when "00110111" => current_character <= '7';
				when "00111000" => current_character <= '8';
				when "00111001" => current_character <= '9';
				when others => current_character <= '?';
		end case;
		end if;
  end process;
   
   
END;


