library ieee;
use ieee.std_logic_1164.all;

entity divisor_reloj is
    -- Valor generico para poder acelerarlo en la simulacion
    generic ( FIN_CONTEO : integer := 24999999 );
    port ( 
        clk_50mhz : in  std_logic; -- Reloj rapidisimo de la tarjeta
        rst       : in  std_logic; -- Boton de reinicio
        clk_1hz   : out std_logic  -- Reloj lento para ver los LEDs
    );
end entity;

architecture rtl of divisor_reloj is 
    signal contador : integer := 0;      -- Cuenta los pulsos
    signal temporal : std_logic := '0';  -- Guarda el estado del reloj lento
begin
    process(clk_50mhz, rst) 
    begin
        if rst = '1' then
            contador <= 0;
            temporal <= '0';
        elsif clk_50mhz'event and clk_50mhz = '1' then
            -- Cuando llego al limite, invierto el pulso y reinicio la cuenta
            if contador = FIN_CONTEO then 
                temporal <= not temporal;
                contador <= 0;
            else
                contador <= contador + 1; -- Sigo contando
            end if;
        end if;
    end process;
    
    clk_1hz <= temporal; -- Saco el reloj lento
end architecture;