TITLE MaxSubarray2               (MaxSubarray2.asm)

; Program Description: Implementation of the maximum subarray algorithm
; Author: olivia
; Creation Date: June 21st, 2022
; Revisions: none
; Date: June 28th, 2022

includelib C:\masm32\lib\Kernel32.Lib
includelib C:\masm32\lib\User32.Lib
includelib C:\masm32\lib\Irvine32.lib

.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
DumpRegs PROTO

.data
LISTVAL BYTE 9h, 2h, 3h, 2h
LISTLEN = $ - LISTVAL

LEFTLOW BYTE 0h
LEFTHIGH BYTE 0h
LEFTSUM BYTE 0h

RIGHTLOW BYTE 0h
RIGHTHIGH BYTE 0h
RIGHTSUM BYTE 0h

CROSSLOW BYTE 0h
CROSSHIGH BYTE 0h
CROSSSUM BYTE 0h

LOWINDEX BYTE 0h
HIGHINDEX BYTE 0h
MIDINDEX BYTE 0h

SUM BYTE 0h

FINALLOW BYTE 0h
FINALHIGH BYTE 0h
FINALSUM BYTE 0h

.code
main PROC

    mov al, [LISTLEN]
    sub al, 1
    mov [HIGHINDEX], al

    mov eax, 0
    mov ebx, 0
    mov ecx, 0
    mov edx, 0

    mov al, [LOWINDEX]
    mov bl, [HIGHINDEX]
    
    cmp al, bl
    je EXITING
    
    add al, bl
    shr al, 1
    mov [MIDINDEX], al

    mov bl, [LOWINDEX] 
    push ebx

    mov bl, [MIDINDEX]
    push ebx

    mov bl, [HIGHINDEX]
    push ebx

    mov bl, [LOWINDEX] 
    push ebx

    mov bl, [MIDINDEX]
    push ebx

    mov bl, [HIGHINDEX]
    push ebx
    
    call findMaximumSubarrayL
    pop ebx
    mov [HIGHINDEX], bl

    pop ebx
    mov [MIDINDEX], bl

    pop ebx
    mov [LOWINDEX], bl

    call findMaximumSubarrayR
    
    pop ebx
    mov [HIGHINDEX], bl

    pop ebx
    mov [MIDINDEX], bl

    pop ebx
    mov [LOWINDEX], bl

    call findMaximumCrossingSubarray
    call finalCompare
    mov al, [FINALLOW]
    mov bl, [FINALHIGH]
    mov cl, [FINALSUM]
    call DumpRegs
    ret


EXITING: mov [FINALLOW], al
         mov [FINALHIGH], bl
         mov dl, [LISTVAL+eax]
         mov [FINALSUM], dl
         call DumpRegs
         ret
main ENDP

findMaximumSubarrayL PROC
    mov al, [LOWINDEX]
    mov bl, [MIDINDEX]

    cmp al, bl
    je EXITING
    mov [HIGHINDEX], bl
    add al, bl
    shr al, 1
    mov [MIDINDEX], al

    mov bl, [LOWINDEX] 
    push ebx

    mov bl, [MIDINDEX]
    push ebx

    mov bl, [HIGHINDEX]
    push ebx

    mov bl, [LOWINDEX] 
    push ebx

    mov bl, [MIDINDEX]
    push ebx

    mov bl, [HIGHINDEX]
    push ebx

    call findMaximumSubarrayL
    call leftCompare
    pop ebx
    mov [HIGHINDEX], bl

    pop ebx
    mov [MIDINDEX], bl

    pop ebx
    mov [LOWINDEX], bl

    call findMaximumSubarrayR

    pop ebx
    mov [HIGHINDEX], bl

    pop ebx
    mov [MIDINDEX], bl

    pop ebx
    mov [LOWINDEX], bl

    call findMaximumCrossingSubarray
    ret

EXITING: mov [LEFTLOW], al
         mov [LEFTHIGH], bl
         mov dl, [LISTVAL+eax]
         mov [LEFTSUM], dl
         ret

findMaximumSubarrayL ENDP

findMaximumSubarrayR PROC
    mov al, [MIDINDEX]
    add al, 1
    mov bl, [HIGHINDEX]

    cmp al, bl
    je EXITING
    mov [LOWINDEX], al
    add al, bl
    shr al, 1
    mov [MIDINDEX], al

    mov bl, [LOWINDEX] 
    push ebx

    mov bl, [MIDINDEX]
    push ebx

    mov bl, [HIGHINDEX]
    push ebx

    mov bl, [LOWINDEX] 
    push ebx

    mov bl, [MIDINDEX]
    push ebx

    mov bl, [HIGHINDEX]
    push ebx

    call findMaximumSubarrayL

    pop ebx
    mov [HIGHINDEX], bl

    pop ebx
    mov [MIDINDEX], bl

    pop ebx
    mov [LOWINDEX], bl

    call findMaximumSubarrayR

    pop ebx
    mov [HIGHINDEX], bl

    pop ebx
    mov [MIDINDEX], bl

    pop ebx
    mov [LOWINDEX], bl

    call findMaximumCrossingSubarray
    call rightCompare
    ret
    
EXITING: mov [LEFTLOW], al
         mov [LEFTHIGH], bl
         mov dl, [LISTVAL+eax]
         mov [LEFTSUM], dl
         ret

findMaximumSubarrayR ENDP

findMaximumCrossingSubarray PROC

    ;mov [LEFTSUM], 0h   ; should be -infinite
    ;mov [SUM], 0h

    mov al, [LOWINDEX]
    mov cl, [MIDINDEX]
    mov dl, 0h              ; left sum
    
    mov bl, 0h              ; sum

CYCLE:    cmp cl, al
          jl OTHERCYCLE
          add bl, [LISTVAL+ecx]
          cmp bl, dl              ; if sum > left-sum...
          jg UPDATELEFT           ; ...update leftsum and maxsum
          sub cl, 1
          jmp CYCLE
    
UPDATELEFT: mov dl, bl
            mov [CROSSLOW], cl
            sub cl, 1
            jmp CYCLE

OTHERCYCLE: mov dl, 0h
            push ebx
            mov bl, 0h
            mov al, [HIGHINDEX]
            mov cl, [MIDINDEX]
            add cl, 1

RIGHTCYCLE: cmp cl, al
            jg EXITING
            add bl, [LISTVAL+ecx]
            cmp bl, dl
            jg UPDATERIGHT
            add cl, 1
            jmp RIGHTCYCLE

UPDATERIGHT: mov dl, bl
             mov [CROSSHIGH], cl
             add cl, 1
             jmp RIGHTCYCLE

EXITING: pop eax
         add bl, al
         mov [CROSSSUM], bl
         ret

findMaximumCrossingSubarray ENDP

finalCompare PROC
     mov al, [LEFTSUM]
     mov bl, [RIGHTSUM]
     mov cl, [CROSSSUM]

LEFTVSRIGHT:     cmp al, bl
                 jg LEFTVSCROSS
                 jmp RIGHTVSCROSS

LEFTVSCROSS: cmp al, cl
             jg CHOOSELEFT
             jmp CHOOSECROSS

RIGHTVSCROSS: cmp bl, cl
              jg CHOOSERIGHT
              jmp CHOOSECROSS

CHOOSELEFT: mov al, [LEFTLOW]
            mov [FINALLOW], al
            mov al, [LEFTHIGH]
            mov [FINALHIGH], al
            mov al, [LEFTSUM]
            mov [FINALSUM], al
            ret

CHOOSERIGHT:mov al, [RIGHTLOW]
            mov [FINALLOW], al
            mov al, [RIGHTHIGH]
            mov [FINALHIGH], al
            mov al, [RIGHTSUM]
            mov [FINALSUM], al
            ret

CHOOSECROSS:mov al, [CROSSLOW]
            mov [FINALLOW], al
            mov al, [CROSSHIGH]
            mov [FINALHIGH], al
            mov al, [CROSSSUM]
            mov [FINALSUM], al
            ret

finalCompare ENDP

leftCompare PROC
     mov al, [LEFTSUM]
     mov bl, [RIGHTSUM]
     mov cl, [CROSSSUM]

LEFTVSRIGHT:     cmp al, bl
                 jg LEFTVSCROSS
                 jmp RIGHTVSCROSS

LEFTVSCROSS: cmp al, cl
             jg CHOOSELEFT
             jmp CHOOSECROSS

RIGHTVSCROSS: cmp bl, cl
              jg CHOOSERIGHT
              jmp CHOOSECROSS

CHOOSELEFT: ;mov al, [LEFTLOW]
            ;mov [LEFTLOW], al
            ;mov al, [LEFTHIGH]
            ;mov [LEFTHIGH], al
            ;mov al, [LEFTSUM]
            ;mov [LEFTSUM], al
            ret

CHOOSERIGHT:mov al, [RIGHTLOW]
            mov [LEFTLOW], al
            mov al, [RIGHTHIGH]
            mov [LEFTHIGH], al
            mov al, [RIGHTSUM]
            mov [LEFTSUM], al
            ret

CHOOSECROSS:mov al, [CROSSLOW]
            mov [LEFTLOW], al
            mov al, [CROSSHIGH]
            mov [LEFTHIGH], al
            mov al, [CROSSSUM]
            mov [LEFTSUM], al
            ret

leftCompare ENDP

rightCompare PROC
     mov al, [LEFTSUM]
     mov bl, [RIGHTSUM]
     mov cl, [CROSSSUM]

LEFTVSRIGHT:     cmp al, bl
                 jg LEFTVSCROSS
                 jmp RIGHTVSCROSS

LEFTVSCROSS: cmp al, cl
             jg CHOOSELEFT
             jmp CHOOSECROSS

RIGHTVSCROSS: cmp bl, cl
              jg CHOOSERIGHT
              jmp CHOOSECROSS

CHOOSELEFT: mov al, [LEFTLOW]
            mov [RIGHTLOW], al
            mov al, [LEFTHIGH]
            mov [RIGHTHIGH], al
            mov al, [LEFTSUM]
            mov [RIGHTSUM], al
            ret

CHOOSERIGHT:;mov al, [RIGHTLOW]
            ;mov [RIGHTLOW], al
            ;mov al, [RIGHTHIGH]
            ;mov [RIGHTHIGH], al
            ;mov al, [RIGHTSUM]
            ;mov [RIGHTSUM], al
            ret

CHOOSECROSS:mov al, [CROSSLOW]
            mov [RIGHTLOW], al
            mov al, [CROSSHIGH]
            mov [RIGHTHIGH], al
            mov al, [CROSSSUM]
            mov [RIGHTSUM], al
            ret

rightCompare ENDP

END main