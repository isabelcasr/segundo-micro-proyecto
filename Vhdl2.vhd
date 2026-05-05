library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_sync is
    port (
        clk      : in  std_logic;                    -- Reloj del sistema
        re       : in  std_logic;                    -- Permiso de lectura (Read Enable)
        addr     : in  std_logic_vector(3 downto 0); -- Dirección (de 0 a 15)
        data_out : out std_logic_vector(7 downto 0)  -- El dato que sale de la memoria
    );
end entity;

architecture behavioral of rom_sync is
    type rom_type is array (0 to 15) of std_logic_vector(7 downto 0);
    
    -- Lleno la ROM con los números que el decodificador convertirá en letras
    constant mem : rom_type := (
        0 => x"00", -- Se convertirá en 'A'
        1 => x"01", -- Se convertirá en 'b'
        2 => x"02", -- Se convertirá en 'C'
        3 => x"03", -- Se convertirá en 'd'
        others => x"FF" -- El resto no importa
    );
    signal reg_data : std_logic_vector(7 downto 0);
begin
    process(clk)
    begin
        if clk'event and clk = '1' then
            -- Solo lee el dato si tiene el permiso 're' encendido
            if re = '1' then 
                reg_data <= mem(to_integer(unsigned(addr)));
            end if;
        end if;
    end process;
    data_out <= reg_data;
end architecture;
