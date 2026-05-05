library ieee;
use ieee.std_logic_1164.all;

entity divisor_reloj is
-- Creo la entidad llamada divisor_reloj
    
    generic ( FIN_CONTEO : integer := 24999999 ); 
    -- Creo un valor que indica hasta dónde debe contar

    port (

        clk_50mhz : in  std_logic;
        -- Este es el reloj rápido de la tarjeta

        rst       : in  std_logic;
        -- Esta es la señal de reinicio

        clk_1hz   : out std_logic
        -- Esta es la salida del reloj lento
    );
end entity;
-- Aquí termina la entidad

architecture rtl of divisor_reloj is
-- Aquí empieza la parte interna del divisor

    signal contador : integer := 0;
    -- Creo un contador que empieza en cero

    signal temporal : std_logic := '0';
    -- Creo una señal temporal para guardar el reloj lento

begin
-- Aquí empieza el funcionamiento

    process(clk_50mhz, rst)
    -- Este proceso depende del reloj rápido y del reset

    begin
    -- Aquí empieza el proceso

        if rst = '1' then
        -- Si reset vale 1 se reinicia todo

            contador <= 0;
            -- El contador vuelve a cero

            temporal <= '0';
            -- El reloj lento vuelve a cero

        elsif clk_50mhz'event and clk_50mhz = '1' then
        -- Si llega un flanco de subida del reloj rápido

            if contador = FIN_CONTEO then
            -- Si el contador llegó al límite

                temporal <= not temporal;
                -- Cambio el valor del reloj lento

                contador <= 0;
                -- Reinicio el contador

            else
            -- Si todavía no llegó al límite

                contador <= contador + 1;
                -- Sumo uno al contador

            end if;
            -- Aquí termina la condición del contador

        end if;
        -- Aquí termina la condición principal

    end process;

    clk_1hz <= temporal;
    -- La salida recibe el valor del reloj lento

end architecture;
