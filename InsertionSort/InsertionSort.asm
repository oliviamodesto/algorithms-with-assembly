TITLE Insertion Sort               (InsertionSort.asm)

; Program Description: Implementation of the Insertion Sort algorithm
; Author: olivia
; Creation Date: May 18th, 2022
; Revisions:None
; Date: May 23rd, 2022

includelib C:\masm32\lib\Kernel32.Lib
includelib C:\masm32\lib\User32.Lib
includelib C:\masm32\lib\Irvine32.lib

.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
DumpRegs PROTO
WriteBinB PROTO
.data
list BYTE 30h, 40h, 20h, 60h, 7h, 1h, 1h, 3h, 1h 	
ListSize = $ - list

.code
main PROC
    mov eax, 0              ; CLEAN THE GARBAGE IN EAX
    mov ebx, 0              ; CLEAN THE GARBAGE IN EBX
    mov ecx, 0              ; CLEAN THE GARBAGE IN ECX
    mov edx, 0              ; CLEAN THE GARBAGE IN EDX

    mov eax, ListSize       ; fetch the list size
    cmp eax, 1              ; if list size <= 1 ... 
    jle ENDING              ; ... then goto ending (no sorting is needed) ...
    mov eax, 0              ; ... else clear eax register

    mov bl, 1               ; load key index in bl
    mov cl, 1               ; load key index in cl
        
LOAD:    mov al, [list+ebx]     ; load key value in al
         mov dl, [list+ebx-1]   ; load i value in dl
         
         cmp al, dl             ; compare key with dl value
         jl L1                  ; if key is less than dl value goto L1...

         add cl, 1              ; ... else increase cl of 1 ...
         cmp cl, ListSize       ; if cl is now the size of our list ...
         jge ENDING             ; ... end program ...
         mov bl, cl             ; ... else update starting index
         jmp LOAD               ; start new cycle
    
L1: mov [list+ebx-1], al        ; load key value into its new position in the list
    mov [list+ebx], dl          ; load i value into its new position in the list
    sub bl, 1                   ; decrease i index
    cmp bl, 0                   ; if we arent at the end of the list ...
    jge LOAD                    ; ... start new cycle

ENDING: mov ecx, 0              ; clean out ecx register for printing

PRINTING:   mov al, [list+ecx]  ; load ecx index value of list
            add cl, 1           ; increase cl of 1
            call DumpRegs       ; print registers to screen
        
            cmp cl, ListSize    ; if we have reached end of list ...
            jge EXIT            ; ... then exit cycle ...
            jmp PRINTING        ; ... else continue cycle

EXIT:    
main ENDP
	
END main
