----------------------------------------------------------------------------------
-- Company: UdS
-- Engineer: bera1107 & lers0601
-- 
-- Create Date: 05/22/2022 04:59:22 PM
-- Design Name: 
-- Module Name: M5_tb - Behavioral
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

entity M5_tb is
--  Port ( );
end M5_tb;

architecture Behavioral of M5_tb is

component calcul_param_1 is
    Port (
    i_bclk    : in   std_logic; -- bit clock (I2S)
    i_reset   : in   std_logic;
    i_en      : in   std_logic; -- un echantillon present a l'entrée
    i_ech     : in   std_logic_vector (23 downto 0); -- echantillon en entrée
    o_param   : out  std_logic_vector (7 downto 0)   -- paramètre calculé
    );
end component;

--signaux intermediaire calcul_param_1
signal d_reset : std_logic := '0';
signal d_en    : std_logic := '0';
signal d_ech   : std_logic_vector(23 downto 0);
signal d_param : std_logic_vector (7 downto 0);

signal   d_ac_en_clk     : std_logic := '0';   -- Clock de la sim
constant c_en_clk_Period : time :=  20 ns;  --  50 MHz
constant c_data_period : time := 20.8 us;
begin

sim_en_clk:  process
      begin
         d_ac_en_clk <= '1';  -- init
         loop
            wait for c_en_clk_Period / 2;
            d_ac_en_clk <= not d_ac_en_clk;
         end loop;
      end process;




----------------------------------------------------------------------------
-- unites objets du test  
----------------------------------------------------------------------------
UUT: calcul_param_1 
   Port map
    (
    i_bclk  => d_ac_en_clk,
    i_reset => d_reset,
    i_en    => d_en,
    i_ech   => d_ech,
    o_param => d_param    
);  

TB : PROCESS
    BEGIN
    d_reset <= '1';
    wait for c_en_clk_Period;
    d_reset <= '0';
    d_ech <= "100000000000000000000000";
    d_en <= '1'; 
    wait for c_en_clk_Period;
    d_en <= '0'; 
    wait for c_data_period;
    d_ech <= "000000000000000000000000";
    d_en <= '1'; 
    wait for c_en_clk_Period;
    d_en <= '0'; 
    wait for c_data_period;
     d_ech <= "000000000000000000000000";
    d_en <= '1'; 
    wait for c_en_clk_Period;
    d_en <= '0'; 
    wait for c_data_period;   
    d_ech <= "000000000000000000000000";
    d_en <= '1'; 
    wait for c_en_clk_Period;
    d_en <= '0'; 
    wait for c_data_period;
    d_ech <= "100000000000000000000000";
    d_en <= '1'; 
    wait for c_en_clk_Period;
    d_en <= '0'; 
    wait for c_data_period;
    d_ech <= "100000000000000000000000";
    d_en <= '1'; 
    wait for c_en_clk_Period;
    d_en <= '0'; 
    wait for c_data_period;        
    d_ech <= "100000000000000000000000";
    d_en <= '1'; 
    wait for c_en_clk_Period;
    d_en <= '0'; 
    wait for c_data_period;    
    d_ech <= "000000000000000000000000";
    d_en <= '1'; 
    wait for c_en_clk_Period;
    d_en <= '0'; 
    wait for c_data_period;        
    END PROCESS; 

end Behavioral;
