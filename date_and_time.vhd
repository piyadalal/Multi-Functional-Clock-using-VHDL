----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:05:36 01/11/2019 
-- Design Name: 
-- Module Name:    dat_time - Behavioral 
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
use IEEE.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dat_time is
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
end dat_time;

architecture Behavioral of dat_time is

-- signals
-- next day increment sent to LCD in integer form (BCD)
signal dow_next : integer range 1 to 8; 
signal day_next_second : integer range 0 to 9;  
signal day_next_first : integer range 0 to 3;
signal mon_next_second : integer range 0 to 9;
signal mon_next_first : integer range 0 to 1; 
signal yr_next_first : integer range 0 to 9; 
signal yr_next_second : integer range 0 to 9;  
signal hr_next_second : integer range 0 to 9;  
signal hr_next_first : integer range 0 to 2; 
signal min_next_second : integer range 0 to 9;
signal min_next_first : integer range 0 to 5; 
signal sec_next_second: integer range 0 to 9; 
signal sec_next_first : integer range 0 to 5; 

signal DCF_NEW : std_logic := '0';




-- input def new information
signal de_dow_next : std_logic_vector(2 downto 0);
signal de_day_next : std_logic_vector(5 downto 0);
signal de_mon_next : std_logic_vector(4 downto 0);
signal de_yr_next : std_logic_vector(7 downto 0);
signal de_hr_next : std_logic_vector(5 downto 0);
signal de_min_next : std_logic_vector(6 downto 0);


-- present day BCD send to LCD as vector
signal dow_pres : integer range 1 to 8; 
signal day_pres_second :integer range 0 to 9;
signal day_pres_first:  integer range 0 to 3;
signal  mon_pres_second : integer range 0 to 9;
signal  mon_pres_first : integer range 0 to 1;
signal  yr_pres_first  :integer range 0 to 9;
signal  yr_pres_second :integer range 0 to 9;
signal  hr_pres_second  :integer range 0 to 9;
signal  hr_pres_first:  integer range 0 to 2;
signal  min_pres_second:  integer range 0 to 9;
signal  min_pres_first : integer range 0 to 5;
signal  sec_pres_second: integer range 0 to 9;
signal  sec_pres_first  :integer range 0 to 5;



-- previous day BCD send to LCD
signal dow_prev: integer range 1 to 8;
signal day_prev_second: integer range 0 to 9;
signal day_prev_first: integer range 0 to 3;
signal mon_prev_second: integer range 0 to 9;
signal mon_prev_first: integer range 0 to 1;
signal yr_prev_second: integer range 0 to 9;
signal yr_prev_first: integer range 0 to 9;
signal hr_prev_second: integer range 0 to 9;
signal hr_prev_first: integer range 0 to 2;
signal min_prev_second: integer range 0 to 9;
signal min_prev_first: integer range 0 to 5;

begin
-- BCD stored as vector 
dow <= std_logic_vector(to_unsigned(dow_pres,3));
day(3 downto 0) <= std_logic_vector(to_unsigned(day_pres_second,4)); 
day(5 downto 4) <= std_logic_vector(to_unsigned(day_pres_first,2)); 
month(3 downto 0) <= std_logic_vector(to_unsigned(mon_pres_second,4)); 
month(4 downto 4) <= std_logic_vector(to_unsigned(mon_pres_first,1)); 
year(3 downto 0) <= std_logic_vector(to_unsigned(yr_pres_second,4)); 
year(7 downto 4) <= std_logic_vector(to_unsigned(yr_pres_first,4)); 
hour(3 downto 0) <= std_logic_vector(to_unsigned(hr_pres_second,4));
hour(5 downto 4) <= std_logic_vector(to_unsigned(hr_pres_first,2)); 
minute(3 downto 0) <= std_logic_vector(to_unsigned(min_pres_second,4)); 
minute(6 downto 4) <= std_logic_vector(to_unsigned(min_pres_first,3)); 
second(3 downto 0) <= std_logic_vector(to_unsigned(sec_pres_second,4)); 
second(6 downto 4) <= std_logic_vector(to_unsigned(sec_pres_first,3)); 

-- setting prev signals (to avoid latches)

process(en_1)
	begin
		if(falling_edge(en_1)) then
		if(reset='1') then
			dow_prev <= 1;
			day_prev_second <= 1;
			day_prev_first <= 0;
			mon_prev_second <= 1;
			mon_prev_first <= 0;
			yr_prev_second <= 1;
			yr_prev_first <= 0;
			hr_prev_second <= 0;
			hr_prev_first <= 0;
			min_prev_second <= 0;
			min_prev_first <= 0;
		else
			dow_prev <= dow_pres;
			day_prev_second <= day_pres_second;
		       day_prev_first<= day_pres_first;
			mon_prev_second <= mon_pres_second; 
			mon_prev_first<= mon_pres_first; 
		        yr_prev_second<= yr_pres_second; 
			yr_prev_first<= yr_pres_first; 
			hr_prev_second <= hr_pres_second; 
			hr_prev_first <= hr_pres_first;
			min_prev_second <= min_pres_second;
			min_prev_first <= min_pres_first; 		
		end if;
		end if;
end process;

-- counting and setting DCF_NEW

process(en_1,de_set)
	begin
		if(reset = '1') then
				dow_pres <= 1;
				day_pres_second <= 1;
				day_pres_first <= 0;
				mon_pres_second <= 1;
				mon_pres_first <= 0;
				yr_pres_second <= 1;
				yr_pres_first <= 0;
				hr_pres_second <= 0;
				hr_pres_first <= 0;
				min_pres_second <= 0;
				min_pres_first <= 0;
				sec_pres_second <= 0;
				sec_pres_first <= 0;
				valid <= '0'; 
			elsif(de_set = '1') then
			DCF_NEW <= '1';

			de_dow_next <= de_dow;
			de_day_next <= de_day;
			de_mon_next <= de_month;
			de_yr_next <= de_year;
			de_hr_next <= de_hour;
			de_min_next <= de_min;
		elsif(rising_edge(en_1)) then
		if(DCF_NEW = '1') then
				dow_pres <= to_integer(unsigned(de_dow_next));
				day_pres_second <= to_integer(unsigned(de_day_next(3 downto 0)));
				day_pres_first <= to_integer(unsigned(de_day_next(5 downto 4)));
				mon_pres_second <= to_integer(unsigned(de_mon_next(3 downto 0)));
				mon_pres_first <= to_integer(unsigned(de_mon_next(4 downto 4)));
				yr_pres_second <= to_integer(unsigned(de_yr_next(3 downto 0)));
				yr_pres_first <= to_integer(unsigned(de_yr_next(7 downto 4)));
				hr_pres_second <= to_integer(unsigned(de_hr_next(3 downto 0)));
				hr_pres_first <= to_integer(unsigned(de_hr_next(5 downto 4)));
				min_pres_second <= to_integer(unsigned(de_min_next(3 downto 0)));
				min_pres_first <= to_integer(unsigned(de_min_next(6 downto 4)));
				sec_pres_second <= 0;
				sec_pres_first <= 0;

				valid <= '1';
				DCF_NEW <= '0';
			else
				sec_pres_second <= sec_next_second;
				sec_pres_first <= sec_next_first;
				
				dow_pres <= dow_pres;
				day_pres_second <= day_prev_second;
				day_pres_first <= day_prev_first;
				mon_pres_second <= mon_prev_second;
				mon_pres_first <= mon_prev_first;
				yr_pres_second <= yr_prev_second;
				yr_pres_first <= yr_prev_first;
				hr_pres_second <= hr_prev_second;
				hr_pres_first <= hr_prev_first;
				min_pres_second <= min_prev_second;
				min_pres_first <= min_prev_first;

			if(sec_next_second = 0 and sec_next_first = 0) then
					valid <= '0'; -- info is at least 1 min old
					min_pres_second <= min_next_second;
					min_pres_first <= min_next_first;
					if(min_next_second = 0 and min_next_first = 0) then
						hr_pres_second <= hr_next_second;
						hr_pres_first <= hr_next_first;
						if(hr_next_second = 0 and hr_next_first = 0) then
							day_pres_second <= day_next_second;
							day_pres_first <= day_next_first;
							if(day_next_second = 1 and day_next_first = 0) then
								mon_pres_second <= mon_next_second;
								mon_pres_first <= mon_next_first;
								if(mon_next_second = 1 and mon_next_first = 0) then
									yr_pres_second <= yr_next_first;
									yr_pres_first <= yr_next_second;
								end if;
							end if;
						end if;
					end if;
				end if;
			end if;
		end if;

end process;

-- next processes

process(sec_pres_second, sec_pres_first)
	begin
		if(sec_pres_second = 9) then
			sec_next_second <= 0;
			if(sec_pres_first = 5) then
				sec_next_first <= 0; 
			else
				sec_next_first <= sec_pres_first + 1;
			end if;
		else
			sec_next_second <= sec_pres_second + 1;
			sec_next_first <= sec_pres_first;
		end if;
end process;

process(min_pres_second, min_pres_first)
	begin
		if(min_pres_second = 9) then
			min_next_second <= 0;
			if(min_pres_first = 5) then
				min_next_first <= 0; 
			else
				min_next_first <= min_pres_first + 1;
			end if;
		else
			min_next_second <= min_pres_second + 1;
			min_next_first <= min_pres_first;
		end if;
end process;

process(hr_pres_second, hr_pres_first)
	begin
		if(hr_pres_second = 3 and hr_pres_first = 2) then
			hr_next_second <= 0;
			hr_next_first <= 0;
		elsif(hr_pres_second = 9) then
			hr_next_second <= 0;
			hr_next_first <= hr_pres_first + 1;
		else
			hr_next_second <= hr_pres_second + 1;
			hr_next_first <= hr_pres_first;
		end if;
end process;

process(day_pres_second, day_pres_first, mon_pres_second, mon_pres_first, yr_pres_second, yr_pres_first)
	begin
		if(day_pres_second = 8 and day_pres_first = 2 and mon_pres_second = 2 and mon_pres_first = 0) then
			case(yr_pres_first) is
				when 1|3|5|7|9 =>
					case(yr_pres_second) is
						when 2|6|0 =>
							day_next_second <= 9;
							day_next_first <= 2;
						when others =>
							day_next_second <= 1;
							day_next_first <= 0;
					end case;
				when others =>
					case(yr_pres_second) is
						when 4|8 =>
							day_next_second <= 9;
							day_next_first <= 2;
						when others =>
							day_next_second <= 1;
							day_next_first <= 0;
					end case;
			end case;
		elsif(day_pres_second = 9 and day_pres_first = 2 and mon_pres_second = 2) then
			day_next_second <= 1;
			day_next_first <= 0;
		elsif(day_pres_second = 0 and day_pres_first = 3) then
			if(mon_pres_first = 0) then
				case(mon_pres_second) is
					when 4|6|9 => 
						day_next_second <= 1;
						day_next_first <= 0;
					when others =>
						day_next_second <= 1;
						day_next_first <= 3;
				end case;
			else
				if(mon_pres_second = 1) then
					day_next_second <= 1;
					day_next_first <= 0;
				else
					day_next_second <= 1;
					day_next_first <= 3;
				end if;
			end if;
		elsif(day_pres_second = 1 and day_pres_first = 3) then
			day_next_second <= 1;
			day_next_first <= 0;
		elsif(day_pres_second = 9) then
			day_next_second <= 0;
			day_next_first <= day_pres_first + 1;
		else
			day_next_second <= day_pres_second + 1;
			day_next_first <= day_pres_first;
		end if;
end process;

process(mon_pres_second, mon_pres_first)
	begin
		if(mon_pres_second = 2 and mon_pres_first = 1) then
			mon_next_second <= 1;
			mon_next_first <= 0;
		elsif(mon_pres_second = 9) then
			mon_next_second <= 0;
			mon_next_first <= mon_pres_first + 1;
		else
			mon_next_second <= mon_pres_second + 1;
			mon_next_first <= mon_pres_first;
		end if;
end process;

process(yr_pres_second, yr_pres_first)
	begin
		if(yr_pres_second = 9 and yr_pres_first = 9) then
			yr_next_first <= 0;
			yr_next_second <= 0;
		elsif(yr_pres_second = 9) then
			yr_next_first <= 0;
			yr_next_second <= yr_pres_first + 1;
		else
			yr_next_first <= yr_pres_second + 1;
			yr_next_second <= yr_pres_first;
		end if;
end process;

process(dow_pres)
	begin
		if(dow_pres = 7) then
			dow_next <= 1;
		else
			dow_next <= dow_pres + 1;
		end if;
end process;
end Behavioral;
