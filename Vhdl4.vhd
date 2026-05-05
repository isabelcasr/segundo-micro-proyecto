library ieee;
use ieee.std_logic_1164.all;

package microproyecto_pkg is
    
    component rom_sync is
        port ( clk : in std_logic; re : in std_logic; addr : in std_logic_vector(3 downto 0); data_out : out std_logic_vector(7 downto 0) );
    end component;

    component ram_sincrona is
        port ( clk : in std_logic; we : in std_logic; re : in std_logic; addr : in std_logic_vector(3 downto 0); data_in : in std_logic_vector(7 downto 0); data_out : out std_logic_vector(7 downto 0) );
    end component;
    
    component decodificador_7seg is
        port ( data_in : in std_logic_vector(7 downto 0); seg_out : out std_logic_vector(6 downto 0) );
    end component;

    component divisor_reloj is
        generic ( FIN_CONTEO : integer := 24999999 ); 
        port ( clk_50mhz : in std_logic; rst : in std_logic; clk_1hz : out std_logic );
    end component;

    component contador_sync is
        port ( clk : in std_logic; rst : in std_logic; clr_cnt : in std_logic; inc_cnt : in std_logic; addr : out std_logic_vector(3 downto 0) );
    end component;

    component control_unit is
        port ( clk : in std_logic; rst : in std_logic; start : in std_logic; addr_in : in std_logic_vector(3 downto 0); clr_cnt : out std_logic; inc_cnt : out std_logic; we_out : out std_logic; re_out : out std_logic; ready : out std_logic );
    end component;
    
end package;