----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/21/2022 02:15:53 PM
-- Design Name: 
-- Module Name: MoyenneFuyante - Behavioral
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

entity MoyenneFuyante is
    Port ( l_bdk : in STD_LOGIC;
           l_reset : in STD_LOGIC;
           l_en : in STD_LOGIC;
           l_ech : in STD_LOGIC;
           L_echd : out STD_LOGIC);
end MoyenneFuyante;

architecture Behavioral of MoyenneFuyante is

begin


end Behavioral;
