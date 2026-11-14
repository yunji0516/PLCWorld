PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D13 : INT;
    D14 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y26 : BOOL;
    Y27 : BOOL;
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
    D20 : INT;
    D22 : INT;

    (* internal *)
    state       : INT := 0;
    curLayer    : INT := 0;
    layerKind   : ARRAY[1..4] OF INT;
    startEdge   : R_TRIG;
    targetTop   : INT := 700;
END_VAR

startEdge(CLK := X10);

CASE state OF

0: (* IDLE - wait for start, no actuator commands before accept *)
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
    Y24 := FALSE; Y26 := FALSE; Y27 := FALSE;
    IF startEdge.Q AND D10 = 4 THEN
        layerKind[1] := D11;
        layerKind[2] := D12;
        layerKind[3] := D13;
        layerKind[4] := D14;
        curLayer := 1;
        state := 10;
    END_IF

10: (* Lift to high before horizontal travel to source *)
    Y20 := FALSE; Y26 := FALSE; Y27 := FALSE;
    IF X23 THEN
        Y23 := FALSE; Y24 := FALSE;
        state := 20;
    ELSE
        Y23 := TRUE; Y24 := FALSE;
    END_IF

20: (* Move horizontally to requested source *)
    Y20 := FALSE; Y23 := FALSE; Y24 := FALSE; Y26 := FALSE; Y27 := FALSE;
    IF layerKind[curLayer] = 0 THEN
        IF X20 THEN
            Y21 := FALSE; Y22 := FALSE;
            state := 30;
        ELSE
            Y21 := TRUE; Y22 := FALSE;
        END_IF
    ELSE
        IF X21 THEN
            Y21 := FALSE; Y22 := FALSE;
            state := 30;
        ELSE
            Y22 := TRUE; Y21 := FALSE;
        END_IF
    END_IF

30: (* Descend to source pickup level *)
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y26 := FALSE; Y27 := FALSE;
    IF X24 THEN
        Y24 := FALSE; Y23 := FALSE;
        state := 40;
    ELSE
        Y24 := TRUE; Y23 := FALSE;
    END_IF

40: (* Close grip on source item *)
    Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE; Y26 := FALSE; Y27 := FALSE;
    Y20 := TRUE;
    IF X25 THEN
        state := 50;
    END_IF

50: (* Lift with plate to high (safety for horizontal travel) *)
    Y20 := TRUE; Y21 := FALSE; Y22 := FALSE; Y26 := FALSE; Y27 := FALSE;
    IF X23 THEN
        Y23 := FALSE; Y24 := FALSE;
        state := 60;
    ELSE
        Y23 := TRUE; Y24 := FALSE;
    END_IF

60: (* Move horizontally to stack *)
    Y20 := TRUE; Y23 := FALSE; Y24 := FALSE; Y26 := FALSE; Y27 := FALSE;
    IF layerKind[curLayer] = 0 THEN
        (* came from A -> go right *)
        IF X22 THEN
            Y21 := FALSE; Y22 := FALSE;
            state := 65;
        ELSE
            Y22 := TRUE; Y21 := FALSE;
        END_IF
    ELSE
        (* came from B -> go left *)
        IF X22 THEN
            Y21 := FALSE; Y22 := FALSE;
            state := 65;
        ELSE
            Y21 := TRUE; Y22 := FALSE;
        END_IF
    END_IF

65: (* Adjust table so actual stack top matches fixed receipt level *)
    Y20 := TRUE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE;
    IF D22 <= targetTop THEN
        Y26 := FALSE; Y27 := FALSE;
        state := 70;
    ELSE
        Y26 := TRUE; Y27 := FALSE;
    END_IF

70: (* Descend to place plate on stack *)
    Y20 := TRUE; Y21 := FALSE; Y22 := FALSE; Y26 := FALSE; Y27 := FALSE;
    IF X24 THEN
        Y24 := FALSE; Y23 := FALSE;
        state := 80;
    ELSE
        Y24 := TRUE; Y23 := FALSE;
    END_IF

80: (* Release plate *)
    Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE; Y26 := FALSE; Y27 := FALSE;
    Y20 := FALSE;
    IF X26 THEN
        state := 90;
    END_IF

90: (* Lift clear after release *)
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y26 := FALSE; Y27 := FALSE;
    IF X23 THEN
        Y23 := FALSE; Y24 := FALSE;
        IF curLayer < 4 THEN
            curLayer := curLayer + 1;
            state := 10;
        ELSE
            state := 95;
        END_IF
    ELSE
        Y23 := TRUE; Y24 := FALSE;
    END_IF

95: (* Return to home position at A *)
    Y20 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE; Y26 := FALSE; Y27 := FALSE;
    IF X20 THEN
        Y21 := FALSE;
        state := 100;
    ELSE
        Y21 := TRUE;
    END_IF

100: (* Finalize: verify empty tool at A upper, all actuators off *)
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE; Y26 := FALSE; Y27 := FALSE;
    IF X20 AND X23 AND X26 THEN
        Y2 := TRUE;
        state := 999;
    END_IF

999: (* Complete - maintain claim and terminal state *)
    Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y24 := FALSE; Y26 := FALSE; Y27 := FALSE;
    Y2 := TRUE;

END_CASE

END_PROGRAM