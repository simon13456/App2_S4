----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/21/2022 02:15:53 PM
-- Design Name: 
-- Module Name: MefM6 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MefM6 is
    Port ( l_bdc : in STD_LOGIC;
           l_echd : in std_logic_vector (23 downto 0);
           l_reset : in STD_LOGIC;
           l_en : in STD_LOGIC;
           o_param : out STD_LOGIC);
end MefM6;

architecture Behavioral of MefM6 is
-- définition de la MEF de contrôle
   type etats is (
         ATT0,
         CheckMax
         );
       
   signal EtatCourant, prochainEtat : etats;
   signal dernierSignal : std_logic_vector (23 downto 0);

begin

   -- Assignation du prochain état
    process(l_bdc, l_reset)
    begin
       if (l_reset ='1') then
             EtatCourant <= ATT0;
       else
       if rising_edge(l_bdc) then
             EtatCourant <= prochainEtat;
       end if;
       end if;
    end process;
    
    process(l_echd)
        begin
        case EtatCourant is
            when ATT0 =>
                if l_echd(23)='0' then
                    prochainEtat <= CheckMax;
                   dernierSignal <= l_echd;
                else
                    prochainEtat <= EtatCourant;
                end if;
            when CheckMax =>
                if l_echd(23)='1' then
                    prochainEtat <= ATT0;
                else
                    if dernierSignal > l_echd then
                        
                end if;
         end case;
    end process;

end Behavioral;
