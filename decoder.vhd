--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package decoder is

constant BLANK : std_logic_vector := "00010000"; --Code for blank charachter

function getNumber(number : std_logic_vector) return std_logic_vector;

function fontMap(c : character) return std_logic_vector;

function getChar(x: integer; y: integer; info: std_logic_vector) return std_logic_vector;

function printTime(x: integer; y: integer; info: std_logic_vector) return std_logic_vector;

function printDate(x: integer; y: integer; info: std_logic_vector) return std_logic_vector;

function printAlarm(x: integer; y: integer; info: std_logic_vector) return std_logic_vector;

function printStopWatch(x: integer; y: integer; info: std_logic_vector) return std_logic_vector;

function printSwitch(x: integer; y: integer; info: std_logic_vector; on_off: std_logic) return std_logic_vector;

function printCountdown(x: integer; y: integer; info: std_logic_vector) return std_logic_vector;

function getDay(info:std_logic_vector) return std_logic_vector;

type mode_type is (normal,date,alarm,time_switch_on,time_switch_off,countdown,stop_watch);

type alarm_state_type is (active,inactive,snooze);

end decoder;

package body decoder is


--Returns the address of a number given a number as a 4 bit logic vector.
function getNumber(number : std_logic_vector) return std_logic_vector is
variable n : std_logic_vector(3 downto 0);
begin
n := number;
if n(3)='1' and (n(2)='1' or n(1)='1') then
return "0100" & n;
else
return "0011" & n;
end if;
end function getNumber;

--Returns character.
function fontMap(c : character) return std_logic_vector is
variable char : std_logic_vector(7 downto 0);
begin
with c select 
	char := 		"01000001" when 'A',
				"01000010" when 'B',
				"01000011" when 'C',
				"01000100" when 'D',
				"01000101" when 'E',
				"01000110" when 'F',
				"01000111" when 'G',
				"01001000" when 'H',
				"01001001" when 'I',
				"01001010" when 'J',
				"01001011" when 'K',
				"01001100" when 'L',
				"01001101" when 'M',
				"01001110" when 'N',
				"01001111" when 'O',
				"01010000" when 'P',
				"01010001" when 'Q',
				"01010010" when 'R',
				"01010011" when 'S',
				"01010100" when 'T',
				"01010101" when 'U',
				"01010110" when 'V',
				"01010111" when 'W',
				"01011000" when 'X',
				"01011001" when 'Y',
				"01011010" when 'Z',
				"01100001" when 'a',
				"01100010" when 'b',
				"01100011" when 'c',
				"01100100" when 'd',
				"01100101" when 'e',
				"01100110" when 'f',
				"01100111" when 'g',
				"01101000" when 'h',
				"01101001" when 'i',
				"01101010" when 'j',
				"01101011" when 'k',
				"01101100" when 'l',
				"01101101" when 'm',
				"01101110" when 'n',
				"01101111" when 'o',
				"01110000" when 'p',
				"01110001" when 'q',
				"01110010" when 'r',
				"01110011" when 's',
				"01110100" when 't',
				"01110101" when 'u',
				"01110110" when 'v',
				"01110111" when 'w',
				"01111000" when 'x',
				"01111001" when 'y',
				"01111010" when 'z',
				"00101111" when '/',
				"00111010" when ':',
				"00101110" when '.',
				"00101010" when '*',
				"00111111" when others; --prints a ?
	return char;
end function fontMap;

function getDay(info:std_logic_vector) return std_logic_vector is
variable day : std_logic_vector(23 downto 0);
begin
with info(57 downto 55) select
	day := 	fontMap('M')&fontMap('o')&fontMap('n') when "001",
				fontMap('T')&fontMap('u')&fontMap('e') when "010",
				fontMap('W')&fontMap('e')&fontMap('d') when "011",
				fontMap('T')&fontMap('h')&fontMap('u') when "100",
				fontMap('F')&fontMap('r')&fontMap('i') when "101",
				fontMap('S')&fontMap('a')&fontMap('t') when "110",
				fontMap('S')&fontMap('u')&fontMap('n') when "111",
				fontMap('E')&fontMap('r')&fontMap('r') when others;
return day;
end function getDay;


function printTime(x: integer; y: integer; info: std_logic_vector) return std_logic_vector is
variable data : std_logic_vector(7 downto 0);
begin
case y is
	when 0 => 
	if (x>=0 and x<7) or x>11 then
		data:=BLANK;		
	else
	with x select
		data := fontMap('T') when 7,
		fontMap('i') when 8,
		fontMap('m') when 9,
		fontMap('e') when 10,
		fontMap(':') when 11,
		BLANK when others;
	end if;
	when 1 =>
	if x=0 then
	data := fontMap('A');
	elsif x=19 then
	data := fontMap('S');
	elsif (x>0 and x<5) or x=13 or x=14 or x=18 then
	data := BLANK;
	elsif x=7 or x=10 then
	data := fontMap(':');
	else
	with x select
	data := getNumber(info(14 downto 11)) when 5,
			  getNumber(info(10 downto 7)) when 6,
			  
			  getNumber(info(22 downto 19)) when 8,
			  getNumber(info(18 downto 15)) when 9,
			  
			  getNumber(info(30 downto 27)) when 11,
			  getNumber(info(26 downto 23)) when 12,
			  
			  fontMap('X') when others;
	end if; 
	when others =>
	data := BLANK; 
	end case;
	return data;
end function printTime;


function printDate(x: integer; y: integer; info: std_logic_vector) return std_logic_vector is
variable data : std_logic_vector(7 downto 0);
variable day : std_logic_vector(23 downto 0);
begin
if y=2 then --Print "Date:"
with x select
data := 	fontMap('D') when 7,
			fontMap('a') when 8,
			fontMap('t') when 9,
			fontMap('e') when 10,
			fontMap(':') when 11,
			BLANK when others;
elsif y=3 then
day := getDay(info);
with x select
data := 	day(23 downto 16) when 4,
			day(15 downto 8) when 5,
			day(7 downto 0) when 6,
			
			getNumber(info(38 downto 35)) when 14,
			getNumber(info(34 downto 31)) when 15,
			fontMap('/') when 10,
			
			getNumber(info(46 downto 43))when 11,
			getNumber(info(42 downto 39)) when 12,
			fontMap('/') when 13,
			
			getNumber(info(54 downto 51)) when 8,
			getNumber(info(50 downto 47)) when 9,
			BLANK when others;

else
data:=BLANK;
end if;
return data;
end function printDate;

function printAlarm(x: integer; y: integer; info: std_logic_vector) return std_logic_vector is
variable data : std_logic_vector(7 downto 0);
begin
if y=2 then --Print "Alarm:"
with x select
data := 	fontMap('A') when 6,
			fontMap('l') when 7,
			fontMap('a') when 8,
			fontMap('r') when 9,
			fontMap('m') when 10,
			fontMap(':') when 11,
			BLANK when others;
elsif y=3 then
with x select
data := 	getNumber(info(38 downto 35)) when 7,
			getNumber(info(34 downto 31)) when 8,
			fontMap(':') when 9,
			getNumber(info(46 downto 43))when 10,
			getNumber(info(42 downto 39)) when 11,
			BLANK when others;
else
data:=BLANK;
end if;
return data;
end function printAlarm;

function printCountdown(x: integer; y: integer; info: std_logic_vector) return std_logic_vector is
variable data : std_logic_vector(7 downto 0);
begin
if y=2 then --Print "Alarm:"
with x select
	data := 	fontMap('T') when 6,
				fontMap('i') when 7,
				fontMap('m') when 8,
				fontMap('e') when 9,
				fontMap('r') when 10,
				fontMap(':') when 11,
				BLANK when others;
elsif y=3 then
with x select
	data := 	getNumber(info(38 downto 35)) when 7,
				getNumber(info(34 downto 31)) when 8,
				fontMap(':') when 9,
				getNumber(info(46 downto 43))when 10,
				getNumber(info(42 downto 39)) when 11,
				fontMap('O') when 14, --its always O 
				BLANK when others;
	if(info(47)='1') then 
		if(x=15) then
			data:=fontMap('n');
		end if;
	else
		if(x=15 or x=16) then
			data := fontMap('f');
		end if;
	end if;
else
data:=BLANK;
end if;
return data;
end function printCountdown;




function printSwitch(x: integer; y: integer; info: std_logic_vector; on_off : std_logic) return std_logic_vector is
variable data : std_logic_vector(7 downto 0);
begin
if y=0 then --Print "On"
with x select
	data := 	fontMap('O') when 8,
				fontMap('n') when 9,
				fontMap(':') when 10,
				BLANK when others;
elsif y=2 then --Print "Off"
with x select
	data := 	fontMap('O') when 8,
				fontMap('f') when 9,
				fontMap('f') when 10,
				fontMap(':') when 11,
				BLANK when others;
elsif y=1 then
with x select
	data := 	getNumber(info(38 downto 35)) when 8,
				getNumber(info(34 downto 31)) when 9,
				fontMap(':') when 10,
				getNumber(info(46 downto 43))when 11,
				getNumber(info(42 downto 39)) when 12,
				BLANK when others;
	if(on_off='1') then 
		if(x=7) then
			data:=fontMap('*');
		end if;
	end if;
elsif y=3 then
with x select
	data := 	getNumber(info(54 downto 51)) when 8,
				getNumber(info(50 downto 47)) when 9,
				fontMap(':') when 10,
				getNumber(info(62 downto 59))when 11,
				getNumber(info(58 downto 55)) when 12,
				BLANK when others;
	if(on_off='0') then 
		if(x=7) then
			data:=fontMap('*');
		end if;
	end if;
else
data:=BLANK;
end if;
return data;
end function printSwitch;


function printStopWatch(x: integer; y: integer; info: std_logic_vector) return std_logic_vector is
variable data : std_logic_vector(7 downto 0);
begin
if y=2 then --Print "Stop watch:"
with x select
	data := 	fontMap('S') when 3,
				fontMap('t') when 4,
				fontMap('o') when 5,
				fontMap('p') when 6,
				fontMap('W') when 8,
				fontMap('a') when 9,
				fontMap('t') when 10,
				fontMap('c') when 11,
				fontMap('h') when 12,
				fontMap(':') when 13,
				BLANK when others;
elsif y=3 then
with x select
	data := 	getNumber(info(38 downto 35)) when 4,
				getNumber(info(34 downto 31)) when 5,
				fontMap(':') when 6,
				getNumber(info(46 downto 43))when 7,
				getNumber(info(42 downto 39)) when 8,
				fontMap(':') when 9,
				getNumber(info(54 downto 51)) when 10,
				getNumber(info(50 downto 47)) when 11,
				fontMap('.') when 12,
				getNumber(info(62 downto 59))when 13,
				getNumber(info(58 downto 55)) when 14,
				BLANK when others;
if(info(63)='1') then 
		if(x=0) then
			data:=fontMap('L');
		end if;
		if(x=1) then
			data:=fontMap('a');
		end if;
		if(x=2) then
			data:=fontMap('p');
		end if;
	end if;
else
data:=BLANK;
end if;
return data;
end function printStopWatch;



function getChar(x: integer; y: integer; info: std_logic_vector) return std_logic_vector is
	variable data : std_logic_vector(7 downto 0);
	variable state : mode_type;
	variable DCF : std_logic;
	variable alarm_state : alarm_state_type;
	variable time_switch_state : std_logic;
	begin
	with info(2 downto 0) select
	state := normal when "000",
				date when "001",
				alarm when "010",
				time_switch_on when "011",
				time_switch_off when "100",
				countdown when "101",
				stop_watch when "110",
				normal when others;
	DCF := info(3);
	time_switch_state := info(4);
	with info(6 downto 5) select
	alarm_state := active when "01",
						inactive when "00",
						snooze when others;
	
	
	-- The DCF signal and the Alarm and time switch state is shown in all modes
	-- So for them we don't need to look at which mode we are in 
	if y = 1 and(x=17 or x=16 or x=15) then
	if(DCF='1') then
		with x select
		data := fontMap('D') when 15,
				fontMap('C') when 16,
				fontMap('F') when 17,
				BLANK	when others;
	else
		data := BLANK;
	end if;
	elsif y = 1  and x=0 then
		data := fontMap('A'); --The Constant A. 
	elsif y = 1 and x = 19 then
		data := fontMap('S'); --The Constant S. 
	elsif y = 2 and x = 0 then --Alarm state
		with alarm_state select
			data := fontMap('*') when active,
			fontMap('Z') when snooze,
			BLANK when others;
	elsif y = 2 and x = 19 then --Time switch state
		if time_switch_state = '1'then
		data := fontMap('*');
		else
		data := BLANK;
		end if;
	else --The rest of the cases are state dependent.
	case state is
	when normal => --The default mode, only clock.
	data := printTime(x,y,info);
	when date =>  -- Clock+date
		if y=0 or y=1 then
			data:=printTime(x,y,info);
		else
			data:=printDate(x,y,info);
		end if;
	when alarm => --Clock+alarm
		if y=0 or y=1 then
			data:=printTime(x,y,info);
		else
			data:=printAlarm(x,y,info);
		end if;
	when time_switch_on =>
		data := printSwitch(x,y,info,'1');
	when time_switch_off =>
		data := printSwitch(x,y,info,'0');
	when countdown =>
		if y=0 or y=1 then
			data:=printTime(x,y,info);
		else
			data:=printCountdown(x,y,info);
		end if;
	when stop_watch =>
		if y=0 or y=1 then
			data:=printTime(x,y,info);
		else
			data:=printStopWatch(x,y,info);
		end if;
	when others =>
	data := fontMap('X');
	end case;
	end if;
	return data;
end function getChar;

end decoder;
