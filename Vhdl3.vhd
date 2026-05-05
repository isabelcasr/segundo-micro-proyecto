library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_sincrona is
    port (
        clk      : in  std_logic;                    -- Reloj del sistema
        we       : in  std_logic;                    -- Permiso para escribir (Write Enable)
        re       : in  std_logic;                    -- Permiso para leer (Read Enable)
        addr     : in  std_logic_vector(3 downto 0); -- Dirección a usar
        data_in  : in  std_logic_vector(7 downto 0); -- El dato que entra
        data_out : out std_logic_vector(7 downto 0)  -- El dato que sale
    );
end entity;

architecture behavioral of ram_sincrona is
    type ram_type is array (0 to 15) of std_logic_vector(7 downto 0);
    signal mem : ram_type := (others => (others => '0'));
    signal reg_addr : std_logic_vector(3 downto 0);
begin
    process(clk)
    begin
        if clk'event and clk = '1' then
            -- Si tengo permiso de escritura, guardo el dato
            if we = '1' then
                mem(to_integer(unsigned(addr))) <= data_in;
            end if;
            
            -- Si tengo permiso de lectura, actualizo la dirección de salida
            if re = '1' then
                reg_addr <= addr;
            end if;
        end if;
    end process;
    data_out <= mem(to_integer(unsigned(reg_addr)));
end architecture;