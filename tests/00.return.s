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
  |                          "Return" Uygulaması                          |
  \_______________________________________________________________________/
  |                                                                       |
  | Bu basit ve ilk MIPS assembly uygulamasında `exit` sistem çağrısına   |
  | bir çıkış kodu verilerek uygulamadan çıkılıyor. Uygulamanın doğru     |
  | çalışıp çalışmadığı `echo $?` ile komut satırından denetlenebilir.    |
  |                                                                       |
  | Geliştirme ortamım Arch Linux (Bazen x86_64, bazen ARM64) olup çapraz |
  | derleyicileri sisteme kurdum. Bu sayede derleyip, `qemu-mips`  ile    |
  | uygulamaları çalıştırabiliyorum.                                      |
  |                                                                       |
  | Birleştir, bağla ve yürüt:                                            |
  |                                                                       |
  | mips-sct-linux-uclibc-as 00_return.s -o 00_return.o                   |
  | mips-sct-linux-uclibc-ld 00_return.o -o 00_return                     |
  | qemu-mips ./00_return                                                 |
  |                                                                       |
  | Yukarıdaki işlevsellik için gcc'yi `-nostdlib` ve `-static`           |
  | etiketleriyle de kullanabiliriz.                                      |
  | mips-sct-linux-uclibc-gcc 00-return.s -o 00-return -static -nostdlib  |
  |                                                                       |
  | __start yerine main yazarsak gcc ile de derleyebiliriz:               |
  | çapraz platform glibc paketinin kurulu olması gerekiyor               |
  | mips-sct-linux-uclibc-gcc -static 00_return.o -o 00_return            |
  |_______________________________________________________________________|
*/

    .section .text
    .global __start

__start:
    li  $a0, 13         # dönüş kodu
    li  $v0, 4001       # sistem çağrı kodu
    syscall

    .section .data
