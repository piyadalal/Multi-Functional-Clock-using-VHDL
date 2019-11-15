library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

entity global_fsm is
    Port ( clk                    : in  std_logic;
           reset                  : in  std_logic;
           en_100                 : in  std_logic;
           act_done               : in  std_logic;
           key_mode_imp           : in  std_logic;       
	   
	   start_time             : out std_logic;
	   start_time_date        : out std_logic;
	   start_alarm_clock      : out std_logic;
	   start_time_switch      : out std_logic;
	   start_counterdown_time : out std_logic;
	   start_stop_watch       : out std_logic;
	   status	          : out std_logic_vector(2 downto 0);
    )
end entity;

architecture Behavioral of global_fsm is
	signal key_mode_num       : integer range 0 to 7         := 0;
	signal counter            : integer range 0 to 511       := 0;
	signal time_on            : std_logic                    := '0';
	signal process_running    : std_logic                    := '0';	
	type State_type is (reset, start, active_time, active_time_date, active_alarm_clock, active_time_switch, active_counterdown_time, avtive_stop_watch);  -- Define the states
	signal state              : State_Type := start; 
begin

	clock:process (clk, reset, en_100, key_mode_imp)
		begin
		if (reset = '1') then
			counter <= 0;
		elsif clk'event and riding_edge(clk) then
			if timer_on = '1' then
				if en_100 = '1' then 
					counter <= counter + 1;
				else
					counter <= counter;
				end if;
				if key_mode_imp = '1' then
					key_mode_num <= key_mode_num + 1;
				else
					key_mode_num <= key_mode_num;
				end if;
				if counter > 300 then
					timer_on <= '0';
					counter <= 0;
				else
					timer_on <= '1';
				end if;
			else
				counter <= 0;
			end if;
		end if;
	end process;

	start_to_count: process (clk, reset, key_mode_imp)
		begin
		if (reset = '1') then
			key_mode_num <= 0;
			timer_on <= '0';
		elsif clk'event and riding_edge(clk) then
			if key_mode_imp = '1' and timer_on = '0' and process_running = '0' then
				key_mode_num <= 1;
				timer_on <= '1';
			else
				key_mode_num <= key_mode_num;
				timer_on <= timer_on;
			end if;
		end if;
	end process;

	process_stopped: process(clk, reset, act_done)
		begin
		if (reset = '1') then
			process_running <= '0';
		elsif clk'event and riding_edge(clk) then
			if process_running = '1' and act_done = '1' then
				process_running <= '0';
				act_done <= '0';
			else
				process_running <= process_running;
			end if;
		end if;
	end process;

	run: process (clk, reset)
		begin
		if (reset = '1') then
			start_time <= '1';
			start_time_date <= '0';
			start_alarm_clock <= '0';
			start_time_switch <= '0';
			start_counterdown_time <= '0';
			start_stop_watch <= '0';
			process_running <= '0';	
			status <= "110";

		elsif clk'event and riding_edge(clk) then
			if timer_on = '0' and process_running = '0' then
				case key_mode_num is
					when 0 =>
						start_time <= '1';
						start_time_date <= '0';
						start_alarm_clock <= '0';
						start_time_switch <= '0';
						start_counterdown_time <= '0';
						start_stop_watch <= '0';
						process_running <= '0';
						status <= "000";

					when 1 =>
						start_time <= '0';
						start_time_date <= '1';
						start_alarm_clock <= '0';
						start_time_switch <= '0';
						start_counterdown_time <= '0';
						start_stop_watch <= '0';
						process_running <= '1';
						status <= "001";

					when 2 =>
						start_time <= '0';
						start_time_date <= '0';
						start_alarm_clock <= '1';
						start_time_switch <= '0';
						start_counterdown_time <= '0';
						start_stop_watch <= '0';
						process_running <= '1';
						status <= "010";

					when 3 =>
						start_time <= '0';
						start_time_date <= '0';
						start_alarm_clock <= '0';
						start_time_switch <= '1';
						start_counterdown_time <= '0';
						start_stop_watch <= '0';
						process_running <= '1';
						status <= "011";

					when 4 =>
						start_time <= '0';
						start_time_date <= '0';
						start_alarm_clock <= '0';
						start_time_switch <= '0';
						start_counterdown_time <= '1';
						start_stop_watch <= '0';
						process_running <= '1';
						status <= "100";

					when 5 =>
						start_time <= '0';
						start_time_date <= '0';
						start_alarm_clock <= '0';
						start_time_switch <= '0';
						start_counterdown_time <= '0';
						start_stop_watch <= '1';
						process_running <= '1';
						status <= "101";

					others =>
						start_time <= '0';
						start_time_date <= '0';
						start_alarm_clock <= '0';
						start_time_switch <= '0';
						start_counterdown_time <= '0';
						start_stop_watch <= '1';
						process_running <= '1';
						status <= "101";						

				end case;
			else
				start_time <= start_time;
				start_time_date <= start_time_date;
				start_alarm_clock <= start_alarm_clock;
				start_time_switch <= start_time_switch;
				start_counterdown_time <= start_counterdown_time;
				start_stop_watch <= start_stop_watch;
				process_running <= process_running;
				status <= status;
			end if;
		end if;
	end process;

--	run: process (clk, reset) 
--  		begin
--    		if (reset = '1') then            -- Upon reset, set the state to start
--			state <= active_time;
--			start_time <= '0';
--			start_time_date <= '0';
--			start_alarm_clock <= '0';
--			start_time_switch <= '0';
--			start_counterdown_time <= '0';
--			start_stop_watch <= '0';
--			key_mode_num <= "000";
--			counter <= (others <= "0");
--			status <= "111";
--			
--		elsif clk'event and clk = clk_polarity then
--			case state is
--				when reset                   =>
--					state <= active_time;
--					start_time <= '0';
--					start_time_date <= '0';
--					start_alarm_clock <= '0';
--					start_time_switch <= '0';
--					start_counterdown_time <= '0';
--					start_stop_watch <= '0';
--					key_mode_num <= "000";
--					counter <= (others <= "0");
--					status <= "111";
--				
--				when start                   =>
--					state <= active_time;
--					start_time <= '0';
--					start_time_date <= '0';
--					start_alarm_clock <= '0';
--					start_time_switch <= '0';
--					start_counterdown_time <= '0';
--					start_stop_watch <= '0';
--					key_mode_num <= "000";
--					counter <= (others <= "0");
--					status <= "111";
--
--				when active_time             =>
--					start_time <= '1';
--					start_time_date <= '0';
--					start_alarm_clock <= '0';
--					start_time_switch <= '0';
--					start_counterdown_time <= '0';
--					start_stop_watch <= '0';
--					key_mode_num <= "000";
--					counter <= (others <= "0");
--					status <= "000";
--					if en_100 = '1' then
--						if key_mode_imp = '1' then
--							key_mode_num = "001";
--						end if;
--						state <= Counting_time;
--					else
--						if key_mode_imp = '1' then 
--							state <= active_time_date;
--						else
--							state <= active_time;
--					end if;
--				when active_time_date        =>
--					start_time <= '0';
--					start_time_date <= '1';
--					start_alarm_clock <= '0';
--					start_time_switch <= '0';
--					start_counterdown_time <= '0';
--					start_stop_watch <= '0';
--					key_mode_num <= "001";
--					counter <= (others <= "0");
--					status <= "001";
--					if en_100 = '1' then
--						if key_mode_imp = '1' then
--							key_mode_num = "010";
--						end if;
--						state <= Counting_time;
--					else
--						if key_mode_imp = '1' then
--							if counter < 300  
--								state <= active_alarm_clock;
--							else
--								state <= active_time;
--							end if;
--						else
--							state <= active_time_date;
--					end if;
--				when active_alarm_clock      =>
--				
--				when active_time_switch      =>
--
--				when active_counterdown_time =>
--
--				when avtive_stop_watch       =>
--					if listnext = '0' and listprev = '0' then --A1
--						State      <= idle;
--						req        <= '0';
--						busiv      <= '0';
--						--ctrl     <= 'don't care'
--						info_start <= '0';
--					else --A2
--						State	   <= wrdy;
--						req        <= '1';
--						busiv      <= '0';
--						ctrl     <= 'don't care'
--						info_start <= '0';
--					end if;
--			end case;
--	end process;
	
end Behavioral;

