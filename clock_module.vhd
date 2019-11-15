library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity clock_module is
    Port ( clk : in  std_logic;
           reset : in  std_logic;
           en_1K : in  std_logic;
           en_100 : in  std_logic;
           en_10 : in  std_logic;
           en_1 : in  std_logic;
			  
           key_action_imp : in  std_logic;
           key_action_long : in std_logic;
           key_mode_imp : in  std_logic;
           key_minus_imp : in  std_logic;
           key_plus_imp : in  std_logic;
           key_plus_minus : in  std_logic;
           key_enable : in  std_logic;
			  
           de_set : in  std_logic;
           de_dow : in  std_logic_vector (2 downto 0);
           de_day : in  std_logic_vector (5 downto 0);
           de_month : in  std_logic_vector (4 downto 0);
           de_year : in  std_logic_vector (7 downto 0);
           de_hour : in  std_logic_vector (5 downto 0);
           de_min : in  std_logic_vector (6 downto 0);
			  
           led_alarm_act : out  std_logic;
           led_alarm_ring : out  std_logic;
           led_countdown_act : out  std_logic;
           led_countdown_ring : out  std_logic;
           led_switch_act : out  std_logic;
           led_switch_on : out  std_logic;
			  
           lcd_en : out std_logic;
           lcd_rw : out std_logic;
           lcd_rs : out std_logic;
           lcd_data : out std_logic_vector(7 downto 0)
           );
end clock_module;

architecture Behavioral of clock_module is
		--Component
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
		
		component lcd_control
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
	
	
	
	signal alarm_ring : STD_LOGIC := '0';
	
	signal counter : integer;
	signal counter2 : integer;
	
begin

	-- your code goes here
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

lcd_controler: lcd_control port map( 
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
           alarm_hh=>alarm_hh,
			  alarm_mm=>alarm_mm,
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
           lcd_data => lcd_data);
			  
			  
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



--
----Example of input to lcd module.
--	--15:39:28
--	time_hh <= "0001" & "0101";
--	time_mm <= "0011" & "1001";
--	time_ss <= "0010" & "1000";
--	
--	--2019-10-23   "23/10/2019"
--	year <= "0001" & "1001";
--	month <= "0001" & "0000";
--	day <= "0010" & "0011";
--	
--	--13:49
--alarm_hh <= "0001" & "0011";
--alarm_mm <= "0100" & "1001";
	
	--Friday       [monday="000" - sunday = "110"]
--	day_of_the_week <= "100";
	
	--Date    (states = [normal=000,date=001,alarm=010])
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
			elsif(state = "011" or state = "100" or state = "101" or state = "110") then
				if(en_1 = '1') then
					counter := counter + 1;
				else
					counter := counter;
				end if;
				if (counter = 6) then
					act_done <= '1';
					counter := 0;
				else
					act_done <= '0';
				end if;
			elsif (state = "001") then
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
	
	
	process(reset,clk)
	variable c : integer;
	begin
	if(clk='1' and clk'event) then
	if(reset='1') then
	c:=0;
	--state <= "000";
	elsif(en_1='1' and en_1'event) then
	if c=6 then
	c:=0;
	else
	c := c+1;
	end if;
	--state <= "010";
	end if;
	end if;
	end process;
	
	--To be used if we implement the rest of the functions...
   time_switch_time_1 <= (others => '0');
   time_switch_time_2 <= (others => '0');
	time_switch_state <='0';
	countdown_timer_time <= (others => '0');
	countdown_state <= '0';
	stop_watch_time <= (others => '0');
	stop_watch_state <= '0';  
	
	
	--Makes DCF blink.
	process(reset,clk)
	begin
	if(clk='1' and clk'event) then
	if(reset='1') then
	counter <= 0;
	--dcf_valid <= '0';
	elsif(en_10='1' and en_10'event) then
	counter <= counter +1;
	if(en_1='1' and en_1'event) then
		--dcf_valid <= not dcf_valid;
	end if;
	end if;
	end if;
	end process;
		
end Behavioral;

