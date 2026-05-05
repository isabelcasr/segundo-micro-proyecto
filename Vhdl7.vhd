library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
    port (
        clk, rst, start : in std_logic;
        addr_in         : in std_logic_vector(3 downto 0); 
        clr_cnt         : out std_logic; 
        inc_cnt         : out std_logic; 
        we_out          : out std_logic; -- Cambiado de ram_we a we_out
        re_out          : out std_logic; -- ¡Añadido! (Faltaba aquí)
        ready           : out std_logic  
    );
end entity;

architecture rtl of control_unit is
    type state_type is (S_IDLE, S_READ, S_WRITE, S_NEXT);
    signal state_reg, state_next : state_type;
begin
    -- Proceso 1: Estado actual
    process(clk, rst)
    begin
        if rst = '1' then 
            state_reg <= S_IDLE;
        elsif rising_edge(clk) then 
            state_reg <= state_next;
        end if;
    end process;

    -- Proceso 2: Lógica de transición
    process(state_reg, start, addr_in)
    begin
        state_next <= state_reg;
        case state_reg is
            when S_IDLE  => 
                if start = '1' then state_next <= S_READ; end if;
            when S_READ  => state_next <= S_WRITE;
            when S_WRITE => state_next <= S_NEXT;
            when S_NEXT  => 
                if addr_in = "0011" then -- Ajusta esto si quieres procesar más de 4 datos
                    state_next <= S_IDLE;
                else 
                    state_next <= S_READ;
                end if;
        end case;
    end process;

    -- Proceso 3: Lógica de salidas
    process(state_reg)
    begin
        -- Valores por defecto (todo apagado)
        clr_cnt <= '0'; inc_cnt <= '0'; we_out <= '0'; re_out <= '0'; ready <= '0';
        
        case state_reg is
            when S_IDLE  => 
                clr_cnt <= '1';
                ready <= '1';
            when S_READ  => 
                re_out <= '1';  -- Activamos lectura para que la ROM saque el dato
            when S_WRITE => 
                re_out <= '1';  -- Mantenemos lectura activa
                we_out <= '1';  -- Activamos escritura para que la RAM guarde
            when S_NEXT  => 
                inc_cnt <= '1';
        end case;
    end process;
end architecture;