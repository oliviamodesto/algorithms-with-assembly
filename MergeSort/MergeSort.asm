TITLE Merge Sort               (MergeSort.asm)

; Program Description: merge sort algorithm implementation
; Author: olivia
; Creation Date: May 24th, 2022
; Revisions: none
; Date: June 16th, 2022

includelib C:\masm32\lib\Kernel32.Lib
includelib C:\masm32\lib\User32.Lib
includelib C:\masm32\lib\Irvine32.lib

.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
WriteString PROTO
DumpRegs PROTO
.data

list BYTE 3h, 1h, 60h, 7h, 1h, 4h, 8h
lengthList = $ - list
finalList BYTE lengthList DUP (?)

p BYTE 1 DUP (?) 
q BYTE 1 DUP (?)
r BYTE 1 DUP (?)

temp BYTE 0h

.code
main PROC

    mov [p], 0
    mov al, [lengthList]
    sub al, 1
    mov [r], al

    mov eax, 0
    mov ebx, 0
    mov ecx, 0
    mov edx, 0
    
    call recursion

    mov al, [finallist+0]
    mov bl, [finallist+1]
    mov dl, [finallist+2]
    call DumpRegs

main ENDP

recursion PROC

    mov al, [p]
    mov bl, [r]

    cmp al, bl
    jge EXITING
    mov dl, al

    add dl, bl
    shr dl, 1

    push eax        ; saving current p
    push ebx        ; saving current r

    add dl, 1

    push edx        ; saving current q+1
    push ebx        ; saving current r

    sub dl, 1
    mov [p], al
    mov [r], dl
    call recursion

    pop ebx
    pop eax
    mov [p], al
    mov [r], bl
    call recursion
    

    pop ebx
    pop eax
    mov [p], al
    mov [r], bl
    mov dl, al

    add dl, bl
    shr dl, 1
    mov [q], dl
    call merge
    call UpdateList
    ret
    
EXITING: ret    
recursion ENDP

merge PROC
    mov eax, 0
    mov ebx, 0
    mov edx, 0
    
    mov al, [p]                 ; load i
    mov bl, [q]                 ; load j
    add bl, 1
    mov dl, [p]                 ; load k
    
CYCLE:   cmp dl, [r]            ; k <= r ?
         jle SORTING
         ret

SORTING: cmp al, [q]
         jg RUNOUTOFLEFT
         cmp bl, [r]
         jg RUNOUTOFRIGHT
         mov [temp], al
         mov al, [list+eax]
         cmp al, [list+ebx]
         jl LESSTHAN
         push ebx
         mov bl, [list+ebx] 
         mov [finalList+edx], bl
         pop ebx
         add bl, 1
         add dl, 1
         mov al, [temp]
         jmp CYCLE

LESSTHAN: mov [finalList+edx], al
          mov al, [temp]
          add al, 1
          add dl, 1
          jmp CYCLE

RUNOUTOFLEFT: push ebx
              mov bl, [list+ebx] 
              mov [finalList+edx], bl
              pop ebx
              add bl, 1
              add dl, 1
              cmp dl, [r]            ; k <= r ?
              jle RUNOUTOFLEFT
              ret

RUNOUTOFRIGHT: mov [temp], al
               mov al, [list+eax]
               mov [finalList+edx], al
               mov al, [temp]
               add al, 1
               add dl, 1
               cmp dl, [r]            ; k <= r ?
               jle RUNOUTOFRIGHT
               ret


merge ENDP

UpdateList PROC

    mov al, [p]
    mov bl, [r]

CYCLE: cmp al, bl
       jle COPY
       ret

COPY: mov dl, [finallist+eax]
      mov [list+eax], dl
      add al, 1
      jmp CYCLE

UpdateList ENDP

END main