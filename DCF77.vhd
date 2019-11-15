----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:05:36 01/12/2019 
-- Design Name: 
-- Module Name:    DCF77 - Behavioral 
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



entity DCF77 is
    Generic( fclk : integer := 50000000 ); -- 50MHz
    Port   ( clk       : in  std_logic; 
             dcf       : in  std_logic;
             dcf_sec0  : out std_logic;
             bitsout   : out std_logic_vector (58 downto 0) );
end DCF77;

architecture Behavioral of DCF77 is
constant cntmax    : integer := (11*fclk)/10;
constant cntsample : integer := (15*fclk)/100;
signal cnt         : integer range 0 to cntmax := 0; -- Z‰hler bis 1.1 sec
signal dcfsr       : std_logic_vector(2 downto 0);
signal bits        : std_logic_vector(58 downto 0):= (others=>'0');
begin
   process begin
      wait until rising_edge(clk);
      -- Einsynchronisieren
      dcfsr <= dcfsr(1 downto 0) & dcf;
   
      -- erst Zaehler hochz‰hlen (s‰ttigend bei 1.1 sec)
      if (cnt < cntmax) then 
         cnt <= cnt+1; 
      end if;
      
      -- steigende Flanke vom DCF-Signal
      dcf_sec0 <= '0';             -- f¸r 1 Taktzyklus bei Sekunde 0 aktiv
      if (dcfsr(2 downto 1)="01") then 
         if (cnt = cntmax) then    -- ‹berlauf? ja: Sekunde 59 war da
            dcf_sec0 <= '1';       -- Sekunde 0 anzeigen
            bitsout <= bits;       -- die gesammelten Daten ¸bergeben
            bits <= (others=>'0'); -- Bit-Schiebegregister zuruecksetzen
         end if;
         cnt <= 0;
      end if;
   
      -- Variante 1: einlesen bei fallender Flanke vom DCF-Signal
      if (dcfsr(2 downto 1)="10") then 
         if (cnt < cntsample) then           -- kurzer Impuls? Grenze 150ms
            bits <= '0' & bits(58 downto 1); -- ja: 0 von links einschieben
         else
            bits <= '1' & bits(58 downto 1); -- nein: 1 von links einschieben
         end if;      
      end if;
      -- --> Ressourcenverbrauch    
      -- Number of Slices       88
      -- Number of Slice FFs    137
      -- Number of 4 input LUTs 104
      
      -- Variante 2: bei Zeitpunkt "150ms" einlesen   
      if (cnt = cntsample) then             -- DCF-Signal einlesen bei 150ms
          bits <= dcfsr(2) & bits(58 downto 1); 
      end if;
      -- --> Ressourcenverbrauch
      -- Number of Slices       87
      -- Number of Slice FFs    137
      -- Number of 4 input LUTs 103

   end process;
end Behavioral;


