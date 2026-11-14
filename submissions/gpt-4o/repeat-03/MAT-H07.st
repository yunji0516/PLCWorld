PROGRAM Main
VAR
    (* Input signals *)
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
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
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
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    X33 : BOOL;
    X34 : BOOL;
    X35 : BOOL;
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
    
    (* Output signals *)
    Y10 : BOOL := FALSE;
    Y11 : BOOL := FALSE;
    Y12 : BOOL := FALSE;
    Y13 : BOOL := FALSE;
    Y14 : BOOL := FALSE;
    Y15 : BOOL := FALSE;
    Y16 : BOOL := FALSE;
    Y17 : BOOL := FALSE;
    Y18 : BOOL := FALSE;
    Y19 : BOOL := FALSE;
    Y1A : BOOL := FALSE;
    Y1B : BOOL := FALSE;
    Y1C : BOOL := FALSE;
    Y1D : BOOL := FALSE;
    Y1E : BOOL := FALSE;
    Y1F : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    Y22 : BOOL := FALSE;
    Y23 : BOOL := FALSE;
    Y24 : BOOL := FALSE;
    Y25 : BOOL := FALSE;
    Y26 : BOOL := FALSE;
    Y27 : BOOL := FALSE;
    Y28 : BOOL := FALSE;
    Y29 : BOOL := FALSE;
    
    (* Internal variables *)
    rollActive : BOOL := FALSE;
    acceptTrigA : R_TRIG;
    acceptTrigB : R_TRIG;
    trimTrigB : R_TRIG;
    ackTrimTrig : R_TRIG;
    cutATrig : R_TRIG;
    cutBTrig : R_TRIG;
    ejectTrig : R_TRIG;
    windAllowed : BOOL := FALSE;
    mandrelState : BOOL := FALSE;
    tapeActionState : BOOL := FALSE;
    timer : TON;
END_VAR

(* Rising edge detections *)
acceptTrigA(CLK := X10);
acceptTrigB(CLK := X11);
trimTrigB(CLK := X15);
ackTrimTrig(CLK := X17);
cutATrig(CLK := X29);
cutBTrig(CLK := X1C);
ejectTrig(CLK := X20);

(* Core preparation and roll acceptance logic *)
IF acceptTrigA.Q THEN
    Y10 := TRUE;
    Y13 := FALSE;
END_IF;

IF acceptTrigB.Q THEN
    Y11 := TRUE;
    Y12 := FALSE;
    Y14 := TRUE;
END_IF;

(* Trimming logic *)
IF trimTrigB.Q THEN
    Y15 := TRUE;
END_IF;

IF ackTrimTrig.Q THEN
    Y16 := TRUE;
END_IF;

(* Roll preparation logic *)
IF Y10 AND Y11 AND NOT rollActive THEN
    Y17 := TRUE;
    rollActive := TRUE;
END_IF;

(* Winding and cutting logic *)
windAllowed := rollActive AND X1E AND (X18 OR X19) AND (D5 >= D4 - 2) AND (D5 <= D4 + 2);
IF windAllowed THEN
    Y1A := TRUE;
    IF X27 AND X28 THEN
        Y18 := TRUE;
        Y19 := TRUE;
        Y1C := cutATrig.Q;
        Y1D := cutBTrig.Q;
    END_IF;
ELSE
    Y1A := FALSE;
    Y18 := FALSE;
    Y19 := FALSE;
END_IF;

(* Mandrel manipulation logic *)
IF rollActive AND NOT mandrelState THEN
    Y1F := TRUE;
    mandrelState := TRUE;
ELSIF NOT rollActive AND mandrelState THEN
    Y1E := TRUE;
    mandrelState := FALSE;
END_IF;

(* Ejection and exit logic *)
IF ejectTrig.Q THEN
    Y20 := TRUE;
    rollActive := FALSE;
END_IF;

IF X22 THEN
    Y21 := TRUE;
END_IF;

(* Tape logic *)
IF NOT tapeActionState AND X2F THEN
    IF D9 >= 80 THEN
        Y25 := TRUE;
        Y26 := X30;
        Y27 := X31;
        Y28 := X33;
        tapeActionState := TRUE;
    END_IF;
ELSIF tapeActionState THEN
    Y25 := FALSE;
    Y26 := FALSE;
    Y27 := FALSE;
    Y28 := FALSE;
    tapeActionState := FALSE;
END_IF;

(* Completion logic *)
IF rollActive AND NOT (Y1F OR Y1E) THEN
    Y22 := FALSE;
ELSE
    Y22 := TRUE;
END_IF;

(* Safety check to prohibit certain actions *)
IF NOT (X24 AND X25 AND X1F) THEN
    Y1E := FALSE;
END_IF;

(* Timer implementation to ensure minimum delay *)
timer(IN := X0 OR Y17 OR Y20, PT := T#100ms);
IF timer.Q THEN
    Y22 := Y22 OR Y21 OR Y16;
END_IF;

END_PROGRAM