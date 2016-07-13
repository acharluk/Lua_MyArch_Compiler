OUT "First number: "	; Print first string
IN_RAW A0 01			; Save first number
OUT "Second number: "	; Print second string
IN_RAW A1 01			; Save second number
LDA A0					; Load first number into register A
LDB A1					; Load second number into register B
ADD						; Add the two numbers
STC A2					; Store ALU register to address F2
OUT "Result: "			; Print Result:
OUT_RAW A2 01			; Show the result
HALT					; End program