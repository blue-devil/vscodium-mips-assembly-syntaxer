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
  | @date     : 13/03/2025                                                |
  | @license  : AGPLv3                                                    |
  |_______________________________________________________________________|
  |                                                                       |
  |       GAS ile Linux MIPS(o32) Sembolik Makine Dili Çalışmaları        |
  |          "EXECVE" Sistem Çağrısı ile Kabuk Açmak Uygulaması           |
  \_______________________________________________________________________/
  |                                                                       |
  | MIPS ve uClibc ile hazırladığım Linux sanal makinemde execve          |
  | ile `/bin/sh` yürütmek istediğimde eskiden yaptığım gibi ikinci ve    |
  | üçüncü argümanları `NULL` bırakmak olmadı. Bu durumda hep             |
  | bölümlendirme hatası aldım (SIGSEGV). Bu nedenle ikinci parametreyi   |
  | bir argüman dizisi olarak ayarlamak gerekti. Üçüncü parametreyi yine  |
  | `NULL` bıraktım.                                                      |
  |                                                                       |
  | Objdump çıktısı:                                                      |
  |                                                                       |
  | Disassembly of section .text:                                         |
  |                                                                       |
  | 004000b0 <__start>:                                                   |
  |   4000b0:       24060000        li      a2,0                          |
  |   4000b4:       3c050041        lui     a1,0x41                       |
  |   4000b8:       24a500e8        addiu   a1,a1,232                     |
  |   4000bc:       3c040041        lui     a0,0x41                       |
  |   4000c0:       248400e0        addiu   a0,a0,224                     |
  |   4000c4:       24020fab        li      v0,4011                       |
  |   4000c8:       0000000c        syscall                               |
  |                                                                       |
  | 004000cc <__exit>:                                                    |
  |   4000cc:       24040000        li      a0,0                          |
  |   4000d0:       24020fa1        li      v0,4001                       |
  |   4000d4:       0000000c        syscall                               |
  |         ...                                                           |
  |                                                                       |
  | Disassembly of section .data:                                         |
  |                                                                       |
  | 004100e0 <_fdata>:                                                    |
  |   4100e0:       2f62696e        sltiu   v0,k1,26990                   |
  |   4100e4:       2f736800        sltiu   s3,k1,26624                   |
  |                                                                       |
  | 004100e8 <argv>:                                                      |
  |   4100e8:       004100e0        0x4100e0                              |
  |   4100ec:       00000000        nop                                   |
  |                                                                       |
  | Birleştir, bağla ve yürüt:                                            |
  |                                                                       |
  | as -march=mips32r2 -o 02-execve1.o 02-execve1.s                       |
  | ld -EB -m elf32btsmip -o 02-execve1.elf 02-execve1.o                  |
  | qemu-mips ./02-execve1.elf                                            |
  |                                                                       |
  |_______________________________________________________________________|
*/

.equ    NULL, 0

    .section .data
path:   .asciiz "/bin/sh"
argv:   .word   path    # argv[0] = "/bin/sh"
        .word   0       # argv[1] = NULL

    .section .text
    .global __start

__start:
    /* execve("/bin/sh", ["/bin/sh"], NULL) */
    /* execve("/bin/sh", NULL, NULL) */
    li      $a2, NULL
    la      $a1, argv
    la      $a0, path       # pointer to /bin/sh
    li      $v0, 4011       # execve syscall
    syscall

__exit:
    /* syscall exit(int status) */
    li      $a0, 0
    li      $v0, 4001
    syscall
