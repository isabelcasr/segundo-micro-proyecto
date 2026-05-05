library ieee;
use ieee.std_logic_1164.all;
use work.microproyecto_pkg.all; 

entity top_system is
    generic ( LIMIT_VAL : integer := 24999999 ); 
    port (
        CLOCK_50 : in std_logic;                     -- Reloj maestro de la tarjeta
        BUTTON   : in std_logic_vector(1 downto 0);  -- Botones: [0]=Reset, [1]=Start
        SW       : in std_logic_vector(0 downto 0);  -- Switch para elegir ver RAM A o RAM B
        HEX0     : out std_logic_vector(6 downto 0); -- Display 7 segmentos para ver las letras
        LEDG     : out std_logic_vector(0 downto 0)  -- LED verde para indicar "Proceso Terminado"
    );
end entity;

architecture structural of top_system is
    -- Cables de interconexión
    signal clk_slow : std_logic;
    signal s_addr   : std_logic_vector(3 downto 0);
    signal s_clr, s_inc, s_we, s_re : std_logic; 
    
    signal data_rom_a, data_ram_a : std_logic_vector(7 downto 0);
    signal data_rom_b, data_ram_b : std_logic_vector(7 downto 0);
    signal dato_a_mostrar : std_logic_vector(7 downto 0);
begin
    -- 1. Divisor, Control y Contador
    U_DIV: divisor_reloj generic map ( FIN_CONTEO => LIMIT_VAL )
        port map ( clk_50mhz => CLOCK_50, rst => not BUTTON(0), clk_1hz => clk_slow );

    U_CTRL: control_unit port map (
        clk => clk_slow, rst => not BUTTON(0), start => not BUTTON(1),
        addr_in => s_addr, clr_cnt => s_clr, inc_cnt => s_inc, 
        we_out => s_we, re_out => s_re, ready => LEDG(0)
    );

    U_CNT: contador_sync port map (
        clk => clk_slow, rst => not BUTTON(0), clr_cnt => s_clr, inc_cnt => s_inc, addr => s_addr
    );

    -- 2. Memorias Ruta A
    ROM_A : rom_sync port map ( clk => clk_slow, re => s_re, addr => s_addr, data_out => data_rom_a );
    RAM_A : ram_sincrona port map ( clk => clk_slow, we => s_we, re => s_re, addr => s_addr, data_in => data_rom_a, data_out => data_ram_a );

    -- 3. Memorias Ruta B
    ROM_B : rom_sync port map ( clk => clk_slow, re => s_re, addr => s_addr, data_out => data_rom_b );
    RAM_B : ram_sincrona port map ( clk => clk_slow, we => s_we, re => s_re, addr => s_addr, data_in => data_rom_b, data_out => data_ram_b );

    -- 4. Selector de Muestra
    -- Si el switch 0 está apagado muestro la RAM A, si está encendido muestro la RAM B
    dato_a_mostrar <= data_ram_a when SW(0) = '0' else data_ram_b;

    -- 5. Decodificador para el Display
    -- Traduce el dato final a los segmentos de la placa
    DECODER: decodificador_7seg port map (
        data_in => dato_a_mostrar,
        seg_out => HEX0
    );
    
end architecture;