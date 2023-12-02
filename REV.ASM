.model small
.stack 100h

.data
inputPrompt db 10, 13, "Enter a string (max 9 chars): $"
outputPrompt db 10, 13, "Reversed string: $"
string db 9 dup('$') ; Reserve 9 characters for the string + '$' for string termination
stringLen db 0 ; Store the length of the string

.code
start:
    mov ax, @data
    mov ds, ax

    ; Display input prompt
    mov dx, offset inputPrompt
    mov ah, 09h
    int 21h

    ; Read string from user
    lea si, string ; Load effective address of string into SI
readChar:
    mov ah, 01h ; Function to read character from standard input
    int 21h ; Call DOS interrupt
    cmp al, 13 ; Compare AL with carriage return (Enter key)
    je finishedReading ; Jump to finishedReading if Enter key is pressed
    mov [si], al ; Store read character at address pointed by SI
    inc si ; Increment SI to point to next byte
    inc stringLen ; Increment string length counter
    cmp stringLen, 9 ; Check if maximum length is reached
    jl readChar ; If not, read next character

finishedReading:
    mov al, '$' ; Terminate the string
    mov [si], al

    ; Display output prompt
    mov dx, offset outputPrompt
    mov ah, 09h
    int 21h

    ; Print string in reverse
    dec si ; Move SI to the last character of the string
printReverse:
    mov al, [si] ; Load character into AL
    mov dl, al ; Move character into DL for printing
    mov ah, 02h ; Function to print character in DL
    int 21h ; Call DOS interrupt
    dec si ; Move to the previous character
    cmp si, offset string - 1 ; Check if start of string is reached
    jge printReverse ; If not at start, print previous character

    ; Terminate the program
    mov ax, 4c00h ; Function to exit with return code 0
    int 21h ; Call DOS interrupt

end start
