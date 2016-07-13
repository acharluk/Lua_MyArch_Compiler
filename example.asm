OUT "First number: "	; commenttt
IN_RAW F0 01
OUT "Second number: "
IN_RAW F1 01
LDA F0
LDB F1
ADD
STC F2
OUT "Result: "
OUT_RAW F2 01
HALT