
---------------------------------------------------------------------------------------------
--    calcul_param_1.vhd
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--    Universit? de Sherbrooke - D?partement de GEGI
--
--    Version         : 5.0
--    Nomenclature    : inspiree de la nomenclature 0.2 GRAMS
--    Date            : 16 janvier 2020, 4 mai 2020
--    Auteur(s)       : bera1107 & lers0601
--    Technologie     : ZYNQ 7000 Zybo Z7-10 (xc7z010clg400-1) 
--    Outils          : vivado 2019.1 64 bits
--
---------------------------------------------------------------------------------------------
--    Description (sur une carte Zybo)
---------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------
-- ? FAIRE: 
-- Voir le guide de la probl?matique
---------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- pour les additions dans les compteurs
USE ieee.numeric_std.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
entity calcul_param_1 is
    Port (
    i_bclk    : in   std_logic; -- bit clock (I2S)
    i_reset   : in   std_logic;
    i_en      : in   std_logic; -- un echantillon present a l'entr?e
    i_ech     : in   std_logic_vector (23 downto 0); -- echantillon en entr?e
    o_param   : out  std_logic_vector (7 downto 0)   -- param?tre calcul?
    );
end calcul_param_1;

----------------------------------------------------------------------------------

architecture Behavioral of calcul_param_1 is
--ajout d'un compteur
component  compteur_nbits is
generic (nbits : integer := 8);
   port ( clk             : in    std_logic; 
          i_en            : in    std_logic; 
          reset           : in    std_logic; 
          o_val_cpt       : out   std_logic_vector (nbits-1 downto 0)
          );
end component;

---------------------------------------------------------------------------------
-- Signaux
----------------------------------------------------------------------------------


    -- state list
 type fsm_c_etats is (
      sta_At,
      sta_Va,
      sta_Vb,
      sta_Vc,
      sta_Li
     );
signal fsm_EtatCourant, fsm_prochainEtat : fsm_c_etats; -- conserve le state
signal cpt_current, d_cpt : std_logic_vector (7 downto 0) := "00000000";

signal  d_en, d_clk : std_logic;
signal cpt_reset : std_logic := '0';
---------------------------------------------------------------------------------------------
--    Description comportementale
---------------------------------------------------------------------------------------------
begin 
-- instance du compteur
inst_cpt : compteur_nbits
 Port map(
    clk             => i_bclk,
    i_en            => i_en,        
    reset           => cpt_reset, 
    o_val_cpt       => d_cpt 
 );
--Actualise le state
    process(i_bclk, i_reset)
    begin
       if (i_reset ='1') then
             fsm_EtatCourant <= sta_At;
       else
       if rising_edge(i_bclk) then
             fsm_EtatCourant <= fsm_prochainEtat;
       end if;
       end if;
end process;

--MEF M5
    process(i_bclk)
    begin
      if i_ech(23) = '0' then  
        case fsm_EtatCourant is
            when sta_Va =>
                cpt_reset <= '0';
                if(i_reset = '1') then
                fsm_prochainEtat <= sta_At;
                else 
                fsm_prochainEtat <= sta_Vb;
                end if;
            when sta_Vb =>
                if(i_reset = '1') then
                fsm_prochainEtat <= sta_At;
                else 
                fsm_prochainEtat <= sta_Vb;
                end if;
            when sta_Vc =>
                if(i_reset = '1') then
                fsm_prochainEtat <= sta_At;
                else 
                fsm_prochainEtat <= sta_Li;
                cpt_current      <= d_cpt;
                end if;           
            when sta_Li =>
                if(i_reset = '1') then
                fsm_prochainEtat <= sta_At;
                else 
                fsm_prochainEtat <= sta_Li;
                end if;
            when others => -- Agit comme sta_At
                fsm_prochainEtat <= sta_At;
                cpt_reset <= '1';
        end case;
      else
        fsm_prochainEtat <= sta_At;    
      end if;  
    end process;
    process(cpt_current)
    begin
    if fsm_EtatCourant = sta_Vc then
    o_param <= cpt_current;
    cpt_reset <= '1';
    else 
    o_param <= "00000000";
    end if;
    end process;
end Behavioral;
