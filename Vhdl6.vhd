library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contador_sync is
    port (
        clk     : in std_logic;
        rst     : in std_logic;
        clr_cnt : in std_logic; -- Orden para volver a 0
        inc_cnt : in std_logic; -- Orden para sumar 1
        addr    : out std_logic_vector(3 downto 0) -- Direccion generada
    );
end entity;

architecture rtl of contador_sync is
    -- Variable interna para poder sumar matematicamente
    signal cnt : unsigned(3 downto 0);
begin
    process(clk, rst)
    begin
        if rst = '1' then 
            cnt <= (others => '0'); -- Reseteo forzado
        elsif clk'event and clk = '1' then
            if clr_cnt = '1' then 
                cnt <= (others => '0'); -- La maquina me pide ir a 0
            elsif inc_cnt = '1' then 
                cnt <= cnt + 1;         -- La maquina me pide avanzar al siguiente dato
            end if;
        end if;
    end process;
    
    -- Convierto el numero de vuelta a std_logic_vector para las memorias
    addr <= std_logic_vector(cnt);
end architecture; 