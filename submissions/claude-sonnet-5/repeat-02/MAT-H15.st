PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D13 : INT;
    D14 : INT;
    D15 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    D203 : INT := 850;
    D204 : INT := 850;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    (* internal state *)
    Phase        : INT := 0;
    curSideSel   : INT := 0;
    curKindSel   : INT := 0;
    aAccepted    : BOOL := FALSE;
    bAccepted    : BOOL := FALSE;
    aBundleSent  : BOOL := FALSE;
    bBundleSent  : BOOL := FALSE;
    ackSent      : BOOL := FALSE;
    completeLatched : BOOL := FALSE;
    completeCond    : BOOL := FALSE;
    completeTimer   : TON;
END_VAR

(* ---- default reset of pulse type outputs each scan ---- *)
Y10 := FALSE;
Y11 := FALSE;
Y12 := FALSE;
Y13 := FALSE;
Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;
Y18 := FALSE;
Y19 := FALSE;
Y1A := FALSE;
Y1C := FALSE;
Y1D := FALSE;
Y1E := FALSE;
Y1F := FALSE;

CASE Phase OF

0: (* WAIT START *)
    IF X0 THEN
        Phase := 1;
    END_IF;

(* ---- order acceptance ---- *)
1:
    IF X1B AND NOT aAccepted THEN
        Y10 := TRUE;
        aAccepted := TRUE;
        Phase := 2;
    END_IF;

2:
    IF X1C AND NOT bAccepted THEN
        Y11 := TRUE;
        bAccepted := TRUE;
        Phase := 3;
    END_IF;

(* ---- pallet supply for A ---- *)
3:
    IF X28 THEN
        Phase := 20;
    ELSIF X27 THEN
        Phase := 4;
    END_IF;

4:
    Y1C := TRUE;
    Phase := 5;

5:
    IF X2A THEN
        Phase := 6;
    END_IF;

6:
    Y1D := TRUE;
    Phase := 7;

7:
    IF X2B THEN
        Phase := 8;
    END_IF;

8:
    D201 := 1;
    Y1E := TRUE;
    Phase := 9;

9:
    IF X2C THEN
        Phase := 10;
    END_IF;

10:
    Y1F := TRUE;
    Phase := 11;

11:
    IF X18 THEN
        Phase := 20;
    END_IF;

(* ---- pallet supply for B ---- *)
20:
    IF X29 THEN
        Phase := 40;
    ELSIF X27 THEN
        Phase := 21;
    END_IF;

21:
    Y1C := TRUE;
    Phase := 22;

22:
    IF X2A THEN
        Phase := 23;
    END_IF;

23:
    Y1D := TRUE;
    Phase := 24;

24:
    IF X2B THEN
        Phase := 25;
    END_IF;

25:
    D201 := 2;
    Y1E := TRUE;
    Phase := 26;

26:
    IF X2C THEN
        Phase := 27;
    END_IF;

27:
    Y1F := TRUE;
    Phase := 28;

28:
    IF X18 THEN
        Phase := 40;
    END_IF;

(* ---- placement loop ---- *)
40:
    IF X1F AND X20 THEN
        Phase := 60;
    ELSIF (NOT X1F) AND X1D THEN
        curSideSel := 1;
        curKindSel := D7;
        Phase := 41;
    ELSIF (NOT X20) AND X1E THEN
        curSideSel := 2;
        curKindSel := D8;
        Phase := 41;
    END_IF;

41:
    IF ( (curKindSel = 1 AND X10) OR (curKindSel = 2 AND X11) )
       AND ( (curSideSel = 1 AND X25) OR (curSideSel = 2 AND X26) ) THEN
        Phase := 42;
    END_IF;

42:
    D200 := curKindSel;
    Y12 := TRUE;
    Phase := 43;

43:
    IF X12 THEN
        Phase := 44;
    END_IF;

44:
    IF NOT X12 THEN
        Phase := 45;
    END_IF;

45:
    D201 := curSideSel;
    IF curSideSel = 1 THEN
        D202 := D9;
    ELSE
        D202 := D10;
    END_IF;
    Phase := 46;

46:
    Y13 := TRUE;
    Phase := 47;

47:
    IF X12 THEN
        Phase := 48;
    END_IF;

48:
    IF NOT X12 THEN
        Phase := 40;
    END_IF;

(* ---- transfer completed bundle A to exit ---- *)
60:
    D203 := 780;
    Y14 := TRUE;
    Phase := 61;

61:
    IF X23 THEN
        Phase := 62;
    END_IF;

62:
    IF NOT X12 THEN
        Phase := 63;
    END_IF;

63:
    D201 := 1;
    Y16 := TRUE;
    Phase := 64;

64:
    IF X15 THEN
        Phase := 65;
    END_IF;

65:
    Y17 := TRUE;
    Phase := 66;

66:
    IF X16 THEN
        Phase := 67;
    END_IF;

67:
    Y18 := TRUE;
    Phase := 68;

68:
    IF X17 THEN
        Phase := 69;
    END_IF;

69:
    Y19 := TRUE;
    Phase := 70;

70:
    IF X18 THEN
        Phase := 71;
    END_IF;

71:
    D203 := 850;
    Y14 := TRUE;
    Phase := 72;

72:
    IF X21 THEN
        aBundleSent := TRUE;
        Phase := 80;
    END_IF;

(* ---- transfer completed bundle B to exit ---- *)
80:
    D204 := 780;
    Y15 := TRUE;
    Phase := 81;

81:
    IF X24 THEN
        Phase := 82;
    END_IF;

82:
    IF NOT X12 THEN
        Phase := 83;
    END_IF;

83:
    D201 := 2;
    Y16 := TRUE;
    Phase := 84;

84:
    IF X15 THEN
        Phase := 85;
    END_IF;

85:
    Y17 := TRUE;
    Phase := 86;

86:
    IF X16 THEN
        Phase := 87;
    END_IF;

87:
    Y18 := TRUE;
    Phase := 88;

88:
    IF X17 THEN
        Phase := 89;
    END_IF;

89:
    Y19 := TRUE;
    Phase := 90;

90:
    IF X18 THEN
        Phase := 91;
    END_IF;

91:
    D204 := 850;
    Y15 := TRUE;
    Phase := 92;

92:
    IF X22 THEN
        bBundleSent := TRUE;
        Phase := 100;
    END_IF;

(* ---- shared receiving transaction + ack ---- *)
100:
    IF X19 THEN
        Phase := 101;
    END_IF;

101:
    Y1A := TRUE;
    ackSent := TRUE;
    Phase := 102;

102:
    Phase := 103;

(* ---- completion supervision ---- *)
103:
    ;

ELSE
    Phase := 0;

END_CASE;

(* completion condition evaluated continuously while at/after phase 103 *)
IF Phase = 103 THEN
    completeCond := X21 AND X22 AND X18 AND (NOT X12) AND (NOT X14) AND ackSent AND X19;
ELSE
    completeCond := FALSE;
END_IF;

completeTimer(IN := completeCond, PT := T#500ms);

IF completeTimer.Q THEN
    completeLatched := TRUE;
END_IF;

IF completeLatched THEN
    Y1B := TRUE;
ELSE
    Y1B := FALSE;
END_IF;

END_PROGRAM