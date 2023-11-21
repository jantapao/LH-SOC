-- Pedro Mello e Igor Mello, Trabalho V1
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entidade testbench da memory
entity memory_tb is
end;

-- Arquitetura do testbench
architecture flex of memory_tb is
    -- Area de declaracoes da arquitetura
    constant addr_width: natural := 16; -- Memory Address Width (in bits)
    constant data_width: natural := 8; -- Data Width (in bits)
    signal clock: std_logic;
    signal data_read: std_logic;
    signal data_write: std_logic;
    signal data_addr : std_logic_vector(addr_width-1 downto 0);
    signal data_in : std_logic_vector(data_width-1 downto 0) := (others => '0'); 
    signal data_out : std_logic_vector((data_width*4)-1 downto 0);
begin
    -- Instanciacao da entidade mem
    mem: entity work.memory(behavioral)
    generic map (addr_width, data_width)
    port map (
        clock => clock, data_read => data_read , data_write => data_write, 
        data_addr => data_addr, data_in => data_in, data_out => data_out
    );

    check_process: process is
        -- data_out apos escrita de x"00" nos primeiros enderecos
        -- data_out := (x"00", x"00", x"00", x"00")
        variable data_out_aux: std_logic_vector((data_width*4)-1 downto 0) := (others => '0');

        -- data_out apos escrita de x"FF"
        -- data_out := (x"FF", x"00", x"00", x"00")
        variable data_out_aux1: std_logic_vector((data_width*4)-1 downto 0) := ((data_width*4)-1 downto (data_width*3) => '1',others => '0');
        
    begin
        -- Escrevendo 0 nos primiros enderecos
        clock <= '1';
        wait for 5 ns;
        data_read <= '0';
        data_write <= '1';
            data_addr <= std_logic_vector(to_unsigned(0, addr_width));
        clock <= not clock;
        wait until falling_edge(clock);
        wait for 5 ns;

        clock <= not clock;
        wait for 5 ns;
        data_read <= '0';
        data_write <= '1';
            data_addr <= std_logic_vector(to_unsigned(1, addr_width));
        clock <= not clock;
        wait until falling_edge(clock);
        wait for 5 ns;

        clock <= not clock;
        wait for 5 ns;
        data_read <= '0';
        data_write <= '1';
            data_addr <= std_logic_vector(to_unsigned(2, addr_width));
        clock <= not clock;
        wait until falling_edge(clock);
        wait for 5 ns;

        clock <= not clock;
        wait for 5 ns;
        data_read <= '0';
        data_write <= '1';
            data_addr <= std_logic_vector(to_unsigned(3, addr_width));
        clock <= not clock;
        wait until falling_edge(clock);
        wait for 5 ns;

        clock <= not clock;
        wait for 5 ns;
        data_read <= '0';
        data_write <= '1';
            data_addr <= std_logic_vector(to_unsigned(4, addr_width));
        clock <= not clock;
        wait until falling_edge(clock);
        wait for 5 ns;

        -- Leitura
        -- Testa leitura e escrita dos valores iniciais (0) nos primeiros enderecos
        clock <= not clock;
        wait for 5 ns;
        data_read <= '1';
        data_write <= '0';
            data_addr <= std_logic_vector(to_unsigned(0, addr_width));
        clock <= not clock;
        wait until falling_edge(clock);
        wait for 5 ns;

        assert data_out = data_out_aux 
        report "ERROR - esperado: " & integer'image(to_integer(unsigned(data_out_aux))) & " lido: " & integer'image(to_integer(unsigned(data_out)));

        -- Escrita
        -- Escreve x"FF" no primeiro endereco
        clock <= not clock;
        wait for 5 ns;
        data_read <= '0';
        data_write <= '1';
        data_in <=  x"FF";
            data_addr <= std_logic_vector(to_unsigned(0, addr_width));
        clock <= not clock;
        wait until falling_edge(clock);
        wait for 5 ns;
             
        -- Leitura apos escrita de x"FF"
        clock <= not clock;
        wait for 5 ns;
        data_read <= '1';
        data_write <= '0';
            data_addr <= std_logic_vector(to_unsigned(0, addr_width));
        clock <= not clock;
        wait until falling_edge(clock);
        wait for 5 ns;

        assert data_out = data_out_aux1 
        report "ERROR - esperado: " & integer'image(to_integer(unsigned(data_out_aux1))) & " lido: " & integer'image(to_integer(unsigned(data_out)));

        wait for 20 ns;
        wait;
    end process;
end architecture;