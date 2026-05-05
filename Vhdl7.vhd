library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
    port (
        clk, rst, start : in std_logic; -- Declaro el reloj, el reset y la señal de inicio
        addr_in         : in std_logic_vector(3 downto 0); -- Esta entrada recibe la dirección actual del contador
        clr_cnt         : out std_logic;-- Esta salida sirve para limpiar el contador
        inc_cnt         : out std_logic; -- Esta salida sirve para aumentar el contador
        we_out          : out std_logic; -- Esta salida activa la escritura en la RAM
        re_out          : out std_logic; -- Esta salida activa la lectura de la memoria
        ready           : out std_logic  --indica que el sistema está listo
    );
end entity;

architecture rtl of control_unit is
        type state_type is (S_IDLE, S_READ, S_WRITE, S_NEXT); -- Creo los estados que va a usar la maquina de estados

    signal state_reg, state_next : state_type; -- Creo una señal para el estado actual y otra para el siguiente estado

begin
    -- Proceso que guarda el estado actual
    process(clk, rst)
    begin
                if rst = '1' then
        -- Si reset está activo

            state_reg <= S_IDLE;
            -- La máquina vuelve al estado inicial

        elsif rising_edge(clk) then
        -- Si llega un flanco de subida del reloj

            state_reg <= state_next;
            -- El estado actual cambia al siguiente estado
        end if;
    end process;

    -- Proceso donde se decide cual es el sigueinte estado
    process(state_reg, start, addr_in)
    begin
        state_next <= state_reg;        -- Por defecto el siguiente estado es el mismo actual
            case state_reg is -- revisar en qué estado está la máquina

            when S_IDLE => -- Estado de espera

                if start = '1' 
                    then state_next <= S_READ; 
                end if; -- Si start vale 1 pasa al estado de lectura

            when S_READ => state_next <= S_WRITE; -- Después de leer pasa a escribir

            when S_WRITE => state_next <= S_NEXT; -- Después de escribir pasa al siguiente dato

            when S_NEXT => -- Estado para revisar si debe seguir o terminar

                if addr_in = "0011" then -- Si la dirección es 3 significa que ya procesó 4 datos

                    state_next <= S_IDLE; -- La máquina vuelve al estado inicial porque ya no hay más datos

                else -- pero si todavía no llega a la dirección 3

                    state_next <= S_READ; -- La máquina vuelve a leer otro dato

                end if;
        end case;
    end process;
    process(state_reg) -- Este proceso controla las salidas según el estado actual
    begin
        clr_cnt <= '0'; inc_cnt <= '0'; we_out <= '0'; re_out <= '0'; ready <= '0';
        -- Primero apago todas las señales de control

        case state_reg is -- y se revisa el estado actual

            when S_IDLE => -- Si está esperando

                clr_cnt <= '1'; -- Limpio el contador
    
                ready <= '1'; -- e indica que el sistema está listo

            when S_READ => -- Si está leyendo

                re_out <= '1'; -- entonces se activa la lectura

            when S_WRITE => -- y si está escribiendo

                re_out <= '1'; -- Mantengo la lectura activa

                we_out <= '1';-- y se activa la escritura

            when S_NEXT => -- si pasa al siguiente dato

                inc_cnt <= '1'; -- Aumento el contador
        end case;
    end process;
end architecture;
