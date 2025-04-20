/* _______________________________________________________________________ 
  |  ______ __          ,.'   __.'.__  .   ______               ___       |
  | |      |  |         /b`  '-.   .-'  d\|      ;             |   |      |
  | |   __ |  |        .5h     /.'.\    =5|   _   \            |   |      |
  | |.  1 \|  |        (0=h    '   '    =C)   1\   \        .--:.  |      |
  | |   1_/|  |        ?3==,          .==7|   | \   \       |__|   |      |
  | |.     | .-- -.-----{=`==oo____oo==`=}|   |  |.----.-- -.--:.  |      |
  | |.  __ | |  V |  ^__|'"o58888888888,; |.  |  ||  ^_|  V |  |.  |      |
  | |:  1 \|_|____|_____| `?88P^\,?88^\P  |.  | / |____|\___|__|:  |___   |
  | |:  1_/   /            C8?\__d88\_/'  |:  1/   / .         |:  1   |  |
  | |::.. .  /             `8o8888/\88P   |::.. . /            |::.. . |  |
  | `-------'               '7oo88oo8P    `------'             `-------'  |
  |                     Cooo##~\/\/\/~====>        github.com/blue-devil  |
  |                                                 gitlab.com/bluedevil  |
  | Özgürlük, ikinci el düşüncelerle olmaz.              www.sctzine.com  |
  |_______________________________________________________________________|
  | @author   : Blue DeviL <bluedevil.SCT@gmail.com>                      |
  | @tester   : ErrorInside <errorinside@sctzine.com>                     |
  | @IDE      : ViM <Vi iMproved>                                         |
  | @template : Blue DeviL                                                |
  | @date     : 10/03/2025                                                |
  | @license  : AGPLv3                                                    |
  |_______________________________________________________________________|
  |                                                                       |
  |       GAS ile Linux MIPS(o32) Sembolik Makine Dili Çalışmaları        |
  |              Komut Satırına "Hello World" Basan Uygulama              |
  \_______________________________________________________________________/
  |                                                                       |
  | Linux sistem çağrılarından `write` kullanarak `stdout` yani standart  |
  | çıktıya istediğim dizgeyi basabilirim.                                |
  |                                                                       |
  | Geliştirme ortamım Arch Linux (Bazen x86_64, bazen ARM64) olup çapraz |
  | derleyicileri sisteme kurdum. Bu sayede derleyip, `qemu-mips`  ile    |
  | uygulamaları çalıştırabiliyorum.                                      |
  |                                                                       |
  | Disassembly of section .text:                                         |
  |                                                                       |
  | 004000f0 <__start>:                                                   |
  |   4000f0:       2406000d        li      a2,13                         |
  |   4000f4:       3c050041        lui     a1,0x41                       |
  |   4000f8:       24a50120        addiu   a1,a1,288                     |
  |   4000fc:       24040001        li      a0,1                          |
  |   400100:       24020fa4        li      v0,4004                       |
  |   400104:       0000000c        syscall                               |
  |                                                                       |
  | 00400108 <__exit>:                                                    |
  |   400108:       24040000        li      a0,0                          |
  |   40010c:       24020fa1        li      v0,4001                       |
  |   400110:       0000000c        syscall                               |
  |         ...                                                           |
  |                                                                       |
  | Disassembly of section .data:                                         |
  |                                                                       |
  | 00410120 <_fdata>:                                                    |
  |   410120:       48656c6c        .word   0x48656c6c                    |
  |   410124:       6f20576f        .word   0x6f20576f                    |
  |   410128:       726c6421        .word   0x726c6421                    |
  |   41012c:       0a000000        j       8000000 <_gp+0x7be7ee0>       |
  |                                                                       |
  | Birleştir, bağla ve yürüt:                                            |
  |                                                                       |
  | mips-sct-linux-uclibc-as 01_hello1.s -o 01_hello1.o                   |
  | mips-sct-linux-uclibc-ld 01_hello1.o -o 01_hello1                     |
  | qemu-mips ./01_hello1                                                 |
  |                                                                       |
  | Yukarıdaki işlevsellik için gcc'yi `-nostdlib` ve `-static`           |
  | etiketleriyle de kullanabiliriz.                                      |
  | mips-sct-linux-uclibc-gcc 01_hello1.s -o 01_hello1 -static -nostdlib  |
  |                                                                       |
  | __start yerine main yazarsak gcc ile de derleyebiliriz:               |
  | çapraz platform glibc paketinin kurulu olması gerekiyor               |
  | mips-sct-linux-uclibc-gcc -static 01_hello1.o -o 01_hello1            |
  |                                                                       |
  | # as -march=mips32r2 -o 01-hello1.o 01-hello1.s                       |
  | # ld -EB -m elf32btsmip -o 01-hello1.elf 01-hello1.o                  |
  | # file ./01-hello1.elf                                                |
  | ./01-hello1.elf: ELF 32-bit MSB executable, MIPS, MIPS32              |
  | rel2 version 1 (SYSV), statically linked, not stripped                |
  | # ./01-hello1.elf                                                     |
  | Hello World!                                                          |
  |                                                                       |
  |_______________________________________________________________________|
*/
    .section .data
msg:
    .asciiz "Hello World!\n"

    .section .text
    .global __start

__start:
    /* syscall write(unsigned int fd, const char *buf, size_t count) */
    li  $a2, 13
    la  $a1, msg
    li  $a0, 1
    li  $v0, 4004
    syscall

__exit:
    /* syscall exit(int status) */
    li  $a0, 0
    li  $v0, 4001
    syscall
