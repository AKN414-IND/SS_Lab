.model small
.stack 100h

.data
menuPrompt db "Select an option (add 1,sub 2,mul 3, div 4): $"
inputPrompt db 13, 10, "Enter number (0-9): $"
resultPrompt db 13, 10, "Result: $"
divByZeroMsg db "Cannot divide by zero!", 13, 10, "$"

num1 db ?
num2 db ?
result db ?

.code
start:
    mov ax, @data
    mov ds, ax

    ; Display the menu
    mov dx, offset menuPrompt
    mov ah, 09h
    int 21h

    ; Get the operation from the user
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al  ; Store the operation

    ; Get the first number
    mov dx, offset inputPrompt
    mov ah, 09h
    int 21h
    mov ah, 01h
    int 21h
    sub al, '0'
    mov num1, al

    ; Get the second number
    mov dx, offset inputPrompt
    mov ah, 09h
    int 21h
    mov ah, 01h
    int 21h
    sub al, '0'
    mov num2, al

    ; Perform the chosen operation
    cmp bl, 1
    je addition
    cmp bl, 2
    je subtraction
    cmp bl, 3
    je multiplication
    cmp bl, 4
    je division

    ; If an invalid operation was chosen, exit
    jmp exit

addition:
    mov al, num1
    add al, num2
    jmp showResult

subtraction:
    mov al, num1
    sub al, num2
    jmp showResult

multiplication:
    mov al, num1
    imul num2 ; For 8086, 'imul' is used for signed multiplication
    jmp showResult

division:
    ; Check for division by zero
    cmp num2, 0
    je divisionError
    mov al, num1
    mov ah, 0
    div num2
    jmp showResult

divisionError:
    mov dx, offset divByZeroMsg
    mov ah, 09h
    int 21h
    jmp exit

showResult:
    ; Display the result
    mov dx, offset resultPrompt
    mov ah, 09h
    int 21h
    mov dl, al
    add dl, '0' ; Convert the result to ASCII
    mov ah, 02h
    int 21h

exit:
    ; Terminate the program
    mov ah, 4ch
    int 21h
    int 21h

end start
