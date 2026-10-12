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

### API da registry

Antes de chamar `main`, o bootloader armazena informações de inicialização em uma registry no endereço físico `0x500`. Cada entrada começa com um campo de tamanho de 32 bits, seguido pelo valor.

O código em assembly pode criar uma entrada com a macro `registry_create` e gravar seu valor logo após o campo de tamanho:

```asm
registry_create "MY_KEY", 4
movl $my_value, 4(%eax)
```

Em C, consulte uma entrada com `murmur_get_registry_key`:

```c
struct murmur_registry_entry *entry =
    murmur_get_registry_key("VBE_INFO");

if (entry) {
    /* entry->value contém entry->size bytes disponíveis */
}
```

Atualmente, o bootloader fornece estas entradas:

| Chave | Valor |
| --- | --- |
| `VBE_INFO` | Bloco de informações do modo VBE de 256 bytes |
| `BLOB_DATA` | Endereço de 32 bits dos dados do blob |
| `BLOB_SIZE` | Tamanho de 32 bits dos dados do blob |

### Licença

Apache-2.0.