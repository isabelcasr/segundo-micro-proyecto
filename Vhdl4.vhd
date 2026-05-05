library ieee;
use ieee.std_logic_1164.all;

package microproyecto_pkg is
-- Creo un paquete para declarar los componentes del proyecto

    component rom_sync is
    -- Declaro el componente de la ROM síncrona

        port ( clk : in std_logic; re : in std_logic; addr : in std_logic_vector(3 downto 0); data_out : out std_logic_vector(7 downto 0) );
        -- Declaro las entradas y salidas de la ROM

    end component;
    -- Termino el componente de la ROM

    component ram_sincrona is
    -- Declaro el componente de la RAM síncrona

        port ( clk : in std_logic; we : in std_logic; re : in std_logic; addr : in std_logic_vector(3 downto 0); data_in : in std_logic_vector(7 downto 0); data_out : out std_logic_vector(7 downto 0) );
        -- Declaro las entradas y salidas de la RAM

    end component;
    -- Termino el componente de la RAM

    component decodificador_7seg is
    -- Declaro el componente del decodificador de 7 segmentos

        port ( data_in : in std_logic_vector(7 downto 0); seg_out : out std_logic_vector(6 downto 0) );
        -- Declaro la entrada del dato y la salida hacia el display

    end component;
    -- Termino el componente del decodificador

    component divisor_reloj is
    -- Declaro el componente que divide el reloj

        generic ( FIN_CONTEO : integer := 24999999 );
        -- Declaro un valor genérico para saber hasta dónde cuenta

        port ( clk_50mhz : in std_logic; rst : in std_logic; clk_1hz : out std_logic );
        -- Declaro el reloj rápido, el reset y el reloj lento

    end component;
    component contador_sync is
    -- Declaro el componente contador

        port ( clk : in std_logic; rst : in std_logic; clr_cnt : in std_logic; inc_cnt : in std_logic; addr : out std_logic_vector(3 downto 0) );
        -- Declaro sus entradas de control y su salida de dirección

    end component;

    component control_unit is
    -- Declaro el componente de la unidad de control

        port ( clk : in std_logic; rst : in std_logic; start : in std_logic; addr_in : in std_logic_vector(3 downto 0); clr_cnt : out std_logic; inc_cnt : out std_logic; we_out : out std_logic; re_out : out std_logic; ready : out std_logic );
        -- Declaro las señales que controlan todo el sistema

    end component;

end package;
