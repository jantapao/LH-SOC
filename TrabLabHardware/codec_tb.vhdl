-- Pedro Mello e Igor Mello, Trabalho V1
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity codec_tb is
end;

architecture flex of codec_tb is

    signal interrupt:  std_logic := '0'; -- interrupt signal
    signal read_signal:  std_logic := '0'; -- Read signal
    signal write_signal:  std_logic := '0'; -- Write signal
    signal valid: std_logic; -- Valid signal    
    signal codec_data_in:  std_logic_vector(7 downto 0); -- Byte written to codec
    signal codec_data_out: std_logic_vector(7 downto 0); -- Byte read from codec
begin
    -- instanciacao da entidade mem
    codec: entity work.codec(flex)
    port map (
        interrupt => interrupt, read_signal => read_signal , write_signal => write_signal, 
        valid => valid, codec_data_in => codec_data_in, codec_data_out => codec_data_out
    );

    estimulo_process: process is
        variable valid_aux: std_logic := '1';
        file arquivo: text;
        variable linha: line;
        variable out_aux : integer;
        variable in_aux: std_logic_vector(7 downto 0) := b"0100_0001"; -- A ASCII 
    begin
        wait for 4 ns;

        -- Leitura
        interrupt <= '0';
        read_signal <= '1';
        write_signal <= '0';
        interrupt <= '1';
        wait for 1 ps;
        interrupt <= '0';
        wait for 4 ns;

        assert in_aux = codec_data_out
        report "ERROR Leitura";

        -- Escrita
        interrupt <= '0';
        codec_data_in <= b"0100_0010"; -- B ASCII 
        read_signal <= '0';
        write_signal <= '1';
        interrupt <= '1';
        wait for 1 ps;
        interrupt <= '0';
        wait for 4 ns;

        -- Verifica escrita
        file_open(arquivo, "saida_test.txt", read_mode);
        while not endfile(arquivo) loop
            readline(arquivo, linha);
            read(linha, out_aux);
        end loop;
        file_close(arquivo);

        assert out_aux = to_integer(unsigned(codec_data_in))
        report "ERROR Escrita - esperado: " & integer'image(to_integer(unsigned(codec_data_in))) & " lido: " & integer'image(out_aux);

        assert std_logic_vector(to_unsigned(out_aux,codec_data_in'length)) = codec_data_in
        report "ERROR Escrita - esperado: " & integer'image(to_integer(unsigned(codec_data_in))) & " lido: " & integer'image(out_aux);

        wait;
    end process;
end architecture;