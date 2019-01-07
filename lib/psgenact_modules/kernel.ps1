param(
    [int]$cycles
)

function gen_header {
    param(
        [string]$arch
    )

    [array]$CFILES = (Get-Content $psscriptroot\..\line_list_files\cfiles.txt)
    [array]$CMDS = "SYSTBL  ", 
                   "SYSHDR  ", 
                   "WRAP    ", 
                   "CHK     ", 
                   "UPD     "

    [string]$cmd = $CMDS[(Get-Random -Maximum ($($CMDS.Length)))]
    [string]$file = $CFILES[(Get-Random -Maximum ($($CFILES.Length)))]
    $file = $file -replace "arch/.+/", "arch/$arch/"

    return "   $cmd  $file"
}

function gen_object {
    param(
        [string]$arch
    )

    [array]$CFILES = (Get-Content $psscriptroot\..\line_list_files\cfiles.txt)
    [array]$RARE_CMDS = "HOSTCC  ",
                        "AS      "
    [int]$ind = Get-Random -Maximum 1000
    [string]$cmd = if ($ind -lt 25) {
        $RARE_CMDS[(Get-Random -Maximum ($($RARE_CMDS.Length)))]
    } elseif ($ind -lt 400) {
        "AR      "
    } else {
        "CC      "
    }

    [string]$file = $CFILES[(Get-Random -Maximum ($($CFILES.Length)))]
    $file = $file -replace "arch/.+/", "arch/$arch/"

    return "   $cmd  $file"
}

function gen_special {
    param(
        [string]$arch
    )
    [array]$SPECIALS = "HOSTLD    arch/ARCH/tools/relocs.o",
                       "HOSTLD    scripts/mod/modpost",
                       "MKELF     scripts/mod/elfconfig.h",
                       "LDS       arch/ARCH/entry/vdso/vdso32/vdso32.lds",
                       "LDS       arch/ARCH/kernel/vmlinux.lds",
                       "LDS       arch/ARCH/realmode/rm/realmode.lds",
                       "LDS       arch/ARCH/boot/compressed/vmlinux.lds",
                       "EXPORTS   arch/ARCH/lib/lib-ksyms.o",
                       "EXPORTS   lib/lib-ksyms.o",
                       "MODPOST   vmlinux.o",
                       "SORTEX    vmlinux",
                       "SYSMAP    System.map",
                       "VOFFSET   arch/ARCH/boot/compressed/../voffset.h",
                       "OBJCOPY   arch/ARCH/entry/vdso/vdso32.so",
                       "OBJCOPY   arch/ARCH/realmode/rm/realmode.bin",
                       "OBJCOPY   arch/ARCH/boot/compressed/vmlinux.bin",
                       "OBJCOPY   arch/ARCH/boot/vmlinux.bin",
                       "VDSO2C    arch/ARCH/entry/vdso/vdso-image-32.c",
                       "VDSO      arch/ARCH/entry/vdso/vdso32.so.dbg",
                       "RELOCS    arch/ARCH/realmode/rm/realmode.relocs",
                       "PASYMS    arch/ARCH/realmode/rm/pasyms.h",
                       "XZKERN    arch/ARCH/boot/compressed/vmlinux.bin.xz",
                       "MRPIGGY   arch/ARCH/boot/compressed/piggy.S",
                       "DATAREL   arch/ARCH/boot/compressed/vmlinux",
                       "ZOFFSET   arch/ARCH/boot/zoffset.h"

    [string]$special = $SPECIALS[(Get-Random -Maximum ($($SPECIALS.Length)))]
    $special = $special -replace "ARCH", $arch

    return "   $special"
}

function gen_line {
    param(
        [string]$arch
    )

    [int]$ind = Get-Random -Maximum 1000

    if ($ind -lt 25) {
        gen_special $arch
    } elseif ($ind -lt 400) {
        gen_header $arch
    } else {
        gen_object $arch
    }
}


$num_lines = $cycles
$ARCH = "alpha",
        "arc",
        "arm",
        "arm64",
        "blackfin",
        "c6x",
        "cris",
        "frv",
        "h8300",
        "hexagon",
        "ia64",
        "m32r",
        "m68k",
        "metag",
        "microblaze",
        "mips",
        "mn10300",
        "nios2",
        "openrisc",
        "parisc",
        "powerpc",
        "s390",
        "score",
        "sh",
        "sparc",
        "tile",
        "um",
        "unicore32",
        "x86",
        "xtensa"

[string]$arch = $ARCH[(Get-Random -Maximum ($($ARCH.Length)))]

1..$num_lines | Foreach-Object {
    [string]$line = gen_line $arch
    [int]$sleep_length = Get-Random -Maximum 1000 -Minimum 10

    Write-Host "$line"
    Start-Sleep -m $sleep_length
}

Write-Host "`n   ----------------------------------------`n" -f White 
Write-Host "   BUILD   arch/$arch/boot/bzImage"


[int]$bytes = Get-Random -Maximum 1000000 -Minimum 9000
[int]$padded_bytes = Get-Random -Maximum 1100000 -Minimum $bytes

Write-Host "   Setup is $bytes bytes (padded to $padded_bytes bytes)."

[int]$system = Get-Random -Maximum 3000 -Minimum 300
Write-Host "   System is $system kB"

[int]$crc = Get-Random -Maximum 268435455 -Minimum 1000000
Write-Host "   CRC: $crc"
Write-Host "   Kernel: arch/$arch/boot/bzImage is ready (#1)`n"



