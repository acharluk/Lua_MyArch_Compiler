OUT B0 0F	; commenttt
IN_RAW F0 01
OUT C0 0F
IN_RAW F1 01
LDA F0
LDB F1
ADD
STC F2
OUT D0 08
OUT_RAW F2 01
HALT