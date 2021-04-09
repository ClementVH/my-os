- Convert binary file to object file
```sh
ld -melf_i386 -r -b binary -o s.o strawberry.bmp
```

- List symbols
```sh
nm build/kernel.elf
```
