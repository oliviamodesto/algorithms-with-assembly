TITLE SquareMatrixMultiplication          (SquareMatrixMultiplication.asm)

; Program Description: implementing the square matrix multiplication algorithm
; Author: olivia
; Creation Date: July 2nd, 2022
; Revisions: none
; Date: July 5th, 2022

includelib C:\masm32\lib\Kernel32.Lib
includelib C:\masm32\lib\User32.Lib
includelib C:\masm32\lib\Irvine32.lib

.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
DumpRegs PROTO

.data
	; (insert variables here)

tableA BYTE 1h, 1h, 1h
RowsizeA = ($ - tableA)
       BYTE 1h, 1h, 1h
       BYTE 1h, 1h, 1h


tableB BYTE 1h, 1h, 1h
RowsizeB = ($ - tableB)
       BYTE 1h, 1h, 1h
       BYTE 1h, 1h, 1h

tableC BYTE 0h, 0h, 0h
RowsizeC = ($ - tableC)
       BYTE 0h, 0h, 0h
       BYTE 0h, 0h, 0h

curri BYTE 0h
currj BYTE 0h
currk BYTE 0h

rowi BYTE 0h
rowj BYTE 0h
rowk BYTE 0h

.code
main PROC
	
    mov ebx, 0h
    mov bl, [RowSizeA]      ; n vairable
    mov ecx, 0h             ; i variable
    ;mov edx, 0h             ; j variable
    ;mov eax, 0h             ; k variable

FIRSTCYCLE: mov edx, 0h     ; j variable
            cmp ecx, ebx    ; if i < n ...
            jl SECONDCYCLE  ; ... then proceed
            jmp EXITING     ; ... else exit cycle            

SECONDCYCLE: mov eax, 0h    ; k variable
             cmp edx, ebx   ; if j < n ...
             jl THIRDCYCLE
             add ecx, 1
             jmp FIRSTCYCLE

THIRDCYCLE: cmp eax, ebx    ; if k < n ...
            jl CALCULATE
            add edx, 1
            jmp SECONDCYCLE

CALCULATE:mov [currk], al
          mov [currj], dl
          mov [curri], cl
          ;call DumpRegs
          push eax
          push ebx
          push ecx
          push edx
          mul bl
          mov [rowk], al
          mov al, dl
          mul bl
          mov [rowj], al
          mov al, cl
          mul bl
          mov [rowi], al          
          call CalculateRow 
          pop edx
          pop ecx
          pop ebx
          pop eax
          add eax, 1
          jmp THIRDCYCLE

EXITING:mov al, [tableC+4]
        mov bl, [tableC+5]
        mov cl, [tableC+6]
        mov dl, [tableC+7] 
        call DumpRegs

main ENDP

CALCULATEROW PROC

           mov cl, [rowi]
           add cl, [currj]
           mov dl, [tableC + ecx]

CYCLE:     push ecx
           mov cl, [rowj]
           add cl, [currk]
           ;call DumpRegs
           mov al, [tableA + ecx]
           mov cl, [rowk]
           add cl, [currj]
           mov bl, [tableA + ecx]
           mul bl
           pop ecx
           add dl, al
           mov [tableC + ecx], dl
           ret
    
CALCULATEROW ENDP


END main