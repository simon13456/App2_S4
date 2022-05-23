--  module_commande.vhd
--  D. Dalle  30 avril 2019, 16 janv 2020, 23 avril 2020
--  module qui permet de r?unir toutes les commandes (problematique circuit sequentiels)
--  recues des boutons, avec conditionnement, et des interrupteurs

-- 23 avril 2020 elimination constante mode_seq_bouton: std_logic := '0'

LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity module_commande IS
generic (nbtn : integer := 4;  mode_simulation: std_logic := '0');
    PORT (
          clk              : in  std_logic;
          o_reset          : out  std_logic; 
          i_btn            : in  std_logic_vector (nbtn-1 downto 0); -- signaux directs des boutons
          i_sw             : in  std_logic_vector (3 downto 0);      -- signaux directs des interrupteurs
          o_btn_cd         : out std_logic_vector (nbtn-1 downto 0); -- signaux conditionn?s 
          o_selection_fct  :  out std_logic_vector(1 downto 0);
          o_selection_par  :  out std_logic_vector(1 downto 0)
          );
end module_commande;

ARCHITECTURE BEHAVIOR OF module_commande IS


component conditionne_btn_v7 is
generic (nbtn : integer := nbtn;  mode_simul: std_logic := '0');
    port (
         CLK          : in std_logic;         -- devrait etre de l ordre de 50 Mhz
         i_btn        : in    std_logic_vector (nbtn-1 downto 0);
         --
         o_btn_db     : out    std_logic_vector (nbtn-1 downto 0);
         o_strobe_btn : out    std_logic_vector (nbtn-1 downto 0)
         );
end component;
    
    type fsm_c_etats is (
         sta_S0,
         sta_S1,
         sta_S2,
         sta_S3
         );

    signal d_strobe_btn :    std_logic_vector (nbtn-1 downto 0);
    signal d_btn_cd     :    std_logic_vector (nbtn-1 downto 0); 
    signal d_reset      :    std_logic;
    signal fsm_EtatCourant, fsm_prochainEtat : fsm_c_etats;
    signal btn_fChange : std_logic_vector(1 downto 0) := d_btn_cd(0)& d_btn_cd(1);
BEGIN 
process(clk, d_reset)
    begin
       if (d_reset ='1') then
             fsm_EtatCourant <= sta_S0;
       else
       if rising_edge(clk) then
             fsm_EtatCourant <= fsm_prochainEtat;
       end if;
       end if;
end process;
                  
 inst_cond_btn:  conditionne_btn_v7
    generic map (nbtn => nbtn, mode_simul => mode_simulation)
    port map(
        clk           => clk,
        i_btn         => i_btn,
        o_btn_db      => d_btn_cd,
        o_strobe_btn  => d_strobe_btn  
         );
 
   o_btn_cd        <= d_btn_cd;
   o_selection_par <= i_sw(1 downto 0); -- mode de selection du parametre par sw
   o_selection_fct <= i_sw(3 downto 2); -- mode de selection de la fonction par sw
   d_reset         <= i_btn(3);         -- pas de contionnement particulier sur reset
   o_reset         <= d_reset;          -- pas de contionnement particulier sur reset
   
   
process (d_btn_cd)
    begin
       case fsm_EtatCourant is
      when sta_S0 =>
         if btn_fChange = "01" then
            fsm_prochainEtat <= sta_S3;
         elsif btn_fChange = "10" then
            fsm_prochainEtat <= sta_S1;
         else
            fsm_prochainEtat <= sta_S0;   
         end if;
      when sta_S1 =>
         if btn_fChange = "01" then
            fsm_prochainEtat <= sta_S0;
         elsif btn_fChange = "10" then
            fsm_prochainEtat <= sta_S2;
         else
            fsm_prochainEtat <= sta_S1;   
         end if;
      when sta_S2 =>
          if btn_fChange = "01" then
            fsm_prochainEtat <= sta_S1;
         elsif btn_fChange = "10" then
            fsm_prochainEtat <= sta_S3;
         else
            fsm_prochainEtat <= sta_S2;   
         end if;
      when sta_S3 =>
          if btn_fChange = "01" then
            fsm_prochainEtat <= sta_S2;
         elsif btn_fChange = "10" then
            fsm_prochainEtat <= sta_S0;
         else
            fsm_prochainEtat <= sta_S3;   
         end if;
      when others =>
         fsm_prochainEtat <= fsm_EtatCourant;
    end case;    
    end process;
END BEHAVIOR;