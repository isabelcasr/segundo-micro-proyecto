library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contador_sync is -
    port (
        clk     : in std_logic; --señal de reloj
        rst     : in std_logic; --señal de reset
        clr_cnt : in std_logic; -- señal para poner el contador en 0
        inc_cnt : in std_logic; -- señal para aumentar el contador 
        addr    : out std_logic_vector(3 downto 0) -- señal de la direccion generada
    );
end entity;

architecture rtl of contador_sync is
    -- Variable interna para poder sumar matematicamente
    signal cnt : unsigned(3 downto 0);
begin
    process(clk, rst) --el processo depende del reloj y del reset
    begin
        if rst = '1' then -- Si reset vale 1
            
            cnt <= (others => '0'); -- contador se pone 0
        
        elsif clk'event and clk = '1' then -- Si llega un flanco de subida del reloj
            
            if clr_cnt = '1' then -- Si la señal de clear está activa
                
                cnt <= (others => '0'); -- El contador vuelve a 0
            
                       elsif inc_cnt = '1' then -- Si la señal de aumentar está activa

                            cnt <= cnt + 1; -- El contador aumenta en uno
            
            end if; -- Aquí termina la decisión de limpiar o aumentar
        end if;
    end process;
    
    -- Convierto el numero de vuelta a std_logic_vector para las memorias
    addr <= std_logic_vector(cnt);
end architecture; 
