-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY testbench IS
   END testbench;
  component alarmclock is
    Port ( mode_fsm : in  STD_LOGIC_VECTOR (1 downto 0);
           time_mm : in  STD_LOGIC_VECTOR (7 downto 0);
           time_ss : in  STD_LOGIC_VECTOR (7 downto 0);
           action_long : in  STD_LOGIC;
           action_imp : in  STD_LOGIC;
           plus_imp : in  STD_LOGIC;
           minus_imp : in  STD_LOGIC;
           mode : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           led_alarm_act : out  STD_LOGIC;
           led_alarm_ring : out  STD_LOGIC);
           --set_time_mm : out  STD_LOGIC_VECTOR (7 downto 0);
           --set_time_ss : out  STD_LOGIC_VECTOR (7 downto 0));
end component;
 

  ARCHITECTURE behavior OF testbench IS 

  -- Component Declaration
  component alarmclock is
    Port ( mode_fsm : in  STD_LOGIC_VECTOR (1 downto 0);
           time_mm : in  STD_LOGIC_VECTOR (7 downto 0);
           time_ss : in  STD_LOGIC_VECTOR (7 downto 0);
           action_long : in  STD_LOGIC;
           action_imp : in  STD_LOGIC;
           plus_imp : in  STD_LOGIC;
           minus_imp : in  STD_LOGIC;
           mode : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           led_alarm_act : out  STD_LOGIC;
           led_alarm_ring : out  STD_LOGIC);
           --set_time_mm : out  STD_LOGIC_VECTOR (7 downto 0);
           --set_time_ss : out  STD_LOGIC_VECTOR (7 downto 0));
end component;
     signal time_count: std_logic_vector(7 downto 0);
signal set_time_mm: std_logic_vector(7 downto 0);
signal set_time_ss: std_logic_vector(7 downto 0);
signal activate_set,activate_count: std_logic;
component counter
 port(clk: in  std_logic;
      activate_counter: in std_logic;
      timecount: out std_logic_vector(7 downto 0));
end component;
component operate_alarm
Port ( mode_fsm : in  STD_LOGIC_VECTOR (1 downto 0);
           mode : in  STD_LOGIC;
           time_mm : in  STD_LOGIC_VECTOR (7 downto 0);
           time_ss : in  STD_LOGIC_VECTOR (7 downto 0);
           action_imp : in  STD_LOGIC;
           action_long : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           set_time_mm : in  STD_LOGIC_VECTOR (7 downto 0);
           set_time_ss : in  STD_LOGIC_VECTOR (7 downto 0);
			  time_count: in  STD_LOGIC_VECTOR (7 downto 0);
           led_alarm_act : out  STD_LOGIC;
           led_alarm_ring : out  STD_LOGIC);
			  --plus_imp : in  STD_LOGIC;
			  --minus_imp : in  STD_LOGIC);
			  
end component;
component set_alarm
port(clk: in  STD_LOGIC;
     rst : in  STD_LOGIC;
	  set_time_mm : out STD_LOGIC_VECTOR (7 downto 0);
     set_time_ss : out  STD_LOGIC_VECTOR (7 downto 0);
	  plus_imp : in  STD_LOGIC;
	  minus_imp : in  STD_LOGIC);
end component;

begin
counter1: counter
port map(clk, activate_count, time_count);
--     clk <= clk,
--     activate_counter <= activate_counter,
--     timecount <= count);
operate_alarm1: operate_alarm
port map(mode_fsm, mode, time_mm, time_ss, action_imp, action_long, clk, rst, set_time_mm, set_time_ss, time_count, led_alarm_act, led_alarm_ring);
--    	  mode_fsm<=mode_fsm,
--		  mode<=mode,
--		  time_mm<=time_mm,
--		  time_ss<=time_ss,
--		  action_imp<=action_imp,
--		  action_long<=action_long,
--		  clk<=clk,
--		  rst<=rst,
--		  set_time_mm<=set_time_mm,
--		  set_time_ss<=set_time_ss,
--		  time_count<=time_count,
--		  led_alarm_act<=led_alarm_act,
--		  led_alarm_ring<=led_alarm_ring);
		  --plus_imp<=plus_imp,
		  --minus_imp<=minus_imp);
set_alarm1: set_alarm
port map(clk, rst, set_time_mm, set_time_ss, plus_imp, minus_imp);
--      clk<=clk,
--		rst<=rst,
--		set_time_mm<=set_time_mm,
--		set_time_ss<=set_time_ss,
--		plus_imp<=plus_imp,
--		minus_imp<=minus_imp);
          COMPONENT <component name>
          PORT(
                  <port1> : IN std_logic;
                  <port2> : IN std_logic_vector(3 downto 0);       
                  <port3> : OUT std_logic_vector(3 downto 0)
                  );
          END COMPONENT;

          SIGNAL <signal1> :  std_logic;
          SIGNAL <signal2> :  std_logic_vector(3 downto 0);
          

  BEGIN

  -- Component Instantiation
          uut: <component name> PORT MAP(
                  <port1> => <signal1>,
                  <port3> => <signal2>
          );


  --  Test Bench Statements
     tb : PROCESS
     BEGIN

        wait for 100 ns; -- wait until global set/reset completes

        -- Add user defined stimulus here

        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
