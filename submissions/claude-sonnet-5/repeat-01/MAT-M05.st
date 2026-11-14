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

    (* internal state *)
    step        : INT := 0;
    layerIdx    : INT := 1;
    recipe      : ARRAY[1..4] OF INT;
    targetX     : INT;
    material    : INT;
    startEdge   : R_TRIG;

    (* scratch output flags, recomputed every scan *)
    outGrip     : BOOL;
    outLeft     : BOOL;
    outRight    : BOOL;
    outUp       : BOOL;
    outDown     : BOOL;
    outTblDown  : BOOL;
    outTblUp    : BOOL;
END_VAR

startEdge(CLK := X10);

(* default all commands to OFF each scan; steps assert what they need *)
outGrip    := FALSE;
outLeft    := FALSE;
outRight   := FALSE;
outUp      := FALSE;
outDown    := FALSE;
outTblDown := FALSE;
outTblUp   := FALSE;

CASE step OF

0: (* IDLE - wait for start request *)
    IF startEdge.Q THEN
        recipe[1] := D11;
        recipe[2] := D12;
        recipe[3] := D13;
        recipe[4] := D14;
        layerIdx  := 1;
        step := 10;
    END_IF;

10: (* ensure lift high before travelling to source *)
    material := recipe[layerIdx];
    IF material = 0 THEN
        targetX := -700;
    ELSE
        targetX := 700;
    END_IF;
    IF X23 THEN
        step := 11;
    ELSE
        outUp := TRUE;
    END_IF;

11: (* travel to selected source *)
    IF (material = 0 AND X20) OR (material = 1 AND X21) THEN
        step := 12;
    ELSE
        IF D20 < targetX - 9 THEN
            outRight := TRUE;
        ELSIF D20 > targetX + 9 THEN
            outLeft := TRUE;
        END_IF;
    END_IF;

12: (* lower onto source item *)
    IF X24 THEN
        step := 13;
    ELSE
        outDown := TRUE;
    END_IF;

13: (* grab source plate *)
    outGrip := TRUE;
    IF X25 THEN
        step := 14;
    END_IF;

14: (* lift with plate before travel *)
    outGrip := TRUE;
    IF X23 THEN
        step := 15;
    ELSE
        outUp := TRUE;
    END_IF;

15: (* travel to stack position *)
    outGrip := TRUE;
    IF X22 THEN
        step := 16;
    ELSE
        IF D20 < -9 THEN
            outRight := TRUE;
        ELSIF D20 > 9 THEN
            outLeft := TRUE;
        END_IF;
    END_IF;

16: (* align deck so actual stack top is near 700 mm (within tolerance) *)
    outGrip := TRUE;
    IF D22 > 701 THEN
        outTblDown := TRUE;
    ELSE
        IF X29 THEN
            step := 17;
        END_IF;
    END_IF;

17: (* lower held plate to place it *)
    outGrip := TRUE;
    IF X24 THEN
        step := 18;
    ELSE
        outDown := TRUE;
    END_IF;

18: (* release and confirm receipt *)
    IF X26 AND X28 THEN
        step := 19;
    END_IF;
    (* outGrip stays FALSE (default) while releasing *)

19: (* lift clear after placement *)
    IF X23 THEN
        step := 20;
    ELSE
        outUp := TRUE;
    END_IF;

20: (* advance to next layer or finish sequence *)
    IF layerIdx < 4 THEN
        layerIdx := layerIdx + 1;
        step := 10;
    ELSE
        step := 30;
    END_IF;

30: (* return tool home to A, upper position *)
    IF X23 THEN
        IF X20 THEN
            step := 31;
        ELSE
            IF D20 > -700 + 9 THEN
                outLeft := TRUE;
            END_IF;
        END_IF;
    ELSE
        outUp := TRUE;
    END_IF;

31: (* finalize: all commands off, claim completion *)
    step := 99;

99: (* maintain terminal state for remainder of run *)
    ;

ELSE
    step := 0;

END_CASE;

(* apply computed commands to outputs - mutually exclusive by construction *)
Y20 := outGrip;
Y21 := outLeft;
Y22 := outRight;
Y23 := outUp;
Y24 := outDown;
Y26 := outTblDown;
Y27 := outTblUp;

IF step = 99 THEN
    Y2 := TRUE;
END_IF;

END_PROGRAM