library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_system_tb is
    -- Los testbench no tienen puertos de entrada ni salida porque se simulan solos
end entity;

architecture sim of top_system_tb is
    -- 1. Declaramos el componente que vamos a probar (Nuestro Top System)
    component top_system is
        generic ( LIMIT_VAL : integer := 24999999 ); 
        port (
            CLOCK_50 : in std_logic;
            BUTTON   : in std_logic_vector(1 downto 0);
            SW       : in std_logic_vector(0 downto 0);
            HEX0     : out std_logic_vector(6 downto 0); -- Salida actualizada al display
            LEDG     : out std_logic_vector(0 downto 0)
        );
    end component;

    -- 2. Creamos cables internos para conectar los pines de la placa en la simulación
    signal clk_tb    : std_logic := '0';
    -- OJO: Los botones inician en '1' porque en la placa son de lógica negada (1=suelto, 0=presionado)
    signal button_tb : std_logic_vector(1 downto 0) := "11"; 
    signal sw_tb     : std_logic_vector(0 downto 0) := "0";
    
    signal hex0_tb   : std_logic_vector(6 downto 0);
    signal ledg_tb   : std_logic_vector(0 downto 0);

    -- Configuración de la velocidad del reloj para la simulación (50 MHz)
    constant clk_period : time := 20 ns;

begin
    -- 3. Conectamos nuestro diseño a los cables de prueba
    DUT: top_system
        -- TRUCO VITAL: Reducimos el límite a 2 para que la simulación sea rápida
        generic map ( LIMIT_VAL => 2 ) 
        port map (
            CLOCK_50 => clk_tb,
            BUTTON   => button_tb,
            SW       => sw_tb,
            HEX0     => hex0_tb,
            LEDG     => ledg_tb
        );

    -- 4. Proceso que simula el latido del reloj de la tarjeta automáticamente
    clk_process : process
    begin
        clk_tb <= '0';
        wait for clk_period/2;
        clk_tb <= '1';
        wait for clk_period/2;
    end process;

    -- 5. Proceso de estímulos (Es como si tú estuvieras moviendo los dedos en la tarjeta)
    stim_process: process
    begin
        -- Esperamos un ratito al iniciar
        wait for 50 ns;

        -- PASO 1: Presionamos el botón de Reset (Button 0 a '0')
        button_tb(0) <= '0'; 
        wait for 40 ns;
        button_tb(0) <= '1'; -- Soltamos Reset
        wait for 100 ns;

        -- PASO 2: Presionamos el botón de Start (Button 1 a '0')
        button_tb(1) <= '0';
        wait for 40 ns;
        button_tb(1) <= '1'; -- Soltamos Start

        -- PASO 3: Esperamos a que la máquina lea de la ROM y escriba en la RAM
        -- Le damos tiempo suficiente para hacer todo el proceso (leer 4 datos)
        wait for 2000 ns;

        -- PASO 4: Movemos el switch hacia arriba para comprobar la RAM B
        sw_tb(0) <= '1';
        wait for 500 ns;

        -- Fin de la simulación
        wait;
    end process;

end architecture;