;
;  Copyright(C) 2018 Codnect
;
;  R kernel is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License, or
;  (at your option) any later version.
;
;  R kernel is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;  GNU General Public License for more details.
;
;  You should have received a copy of the GNU General Public License
;  along with R kernel.  If not, see <http://www.gnu.org/licenses/>.
;

BITS 32
ALIGN 4

extern code
extern bss
extern end

multiboot_header:
    ; Page aligned
    MULTIBOOT_PAGE_ALIGN            equ	1<<0
    ; We require memory information
    MULTIBOOT_MEMORY_INFO           equ	1<<1
    ; Multiboot header magic number
    MULTIBOOT_BOOT_HEADER_MAGIC     equ	0x1BADB002
    ; Load up those flags
    MULTIBOOT_HEADER_FLAGS          equ	MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO
    ; Checksum the result
    MULTIBOOT_CHECKSUM              equ	-(MULTIBOOT_BOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)
	; Load the headers into the binary image.
	dd MULTIBOOT_BOOT_HEADER_MAGIC  ; magic
	dd MULTIBOOT_HEADER_FLAGS       ; flags
	dd MULTIBOOT_CHECKSUM           ; checksum
	dd 0x00000000                   ; header_addr   (multiboot header address)
	dd 0x00000000                   ; load_addr     (the physical address of the beginning of the text segment)
    dd 0x00000000                   ; load_end_addr (the physical address of the end of the data segment)
    dd 0x00000000                   ; bss_end_addr  (the physical address of the end of the bss segment)
    dd 0x00000000                   ; entry_addr    (kernel start point address)


SECTION .text

global kernel_start_point;
extern kernel_main;

kernel_start_point:
	; Set up stack pointer.
	mov esp, stack_top
	push esp
	; Push the mulitboot headers
	push eax ; Header magic
	push ebx ; Header pointer
	; Disable interrupts
	cli
	; Call the C entry point
	call kernel_main
	jmp $

SECTION .bss
stack_bottom:
    ; 8 KiB for stack
    resb 8192
stack_top:



