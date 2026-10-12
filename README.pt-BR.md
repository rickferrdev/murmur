# Murmur

Um bootloader leve para x86 baseado em BIOS, com foco em gráficos VBE e sistemas operacionais pequenos.

## Compilação

```sh
xmake
```

### Instalação

```sh
sudo xmake install -o /usr/local
```

Instala a biblioteca estática, os cabeçalhos públicos e o script do linker.

### Uso

Inclua o cabeçalho público:

```c
#include <murmur/murmur.h>
```

Vincule o projeto com `libmurmur.a`.

O arquivo `linker.ld` fornecido é necessário ao criar uma imagem de boot que dependa do layout de memória, do ponto de entrada e dos símbolos definidos pelo linker do Murmur.

### Licença

Apache-2.0.