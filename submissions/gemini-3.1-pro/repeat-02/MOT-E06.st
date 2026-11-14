PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    Y20 : BOOL;
    Y2 : BOOL;

    active : BOOL;
    initial_pos : DINT;
    height_ok : BOOL;
    maintain_timer : TON;
    y2_state : BOOL;
END_VAR

IF X10 AND NOT active THEN
    active := TRUE;
    initial_pos := D11;
END_IF;

IF NOT X10 THEN
    active := FALSE;
END_IF;

Y20 := active;

IF active THEN
    height_ok := (ABS(D11 - initial_pos) <= 20);
ELSE
    height_ok := FALSE;
END_IF;

maintain_timer(
    IN := active AND X11 AND (NOT X12) AND height_ok,
    PT := T#30ms
);

IF NOT active THEN
    y2_state := FALSE;
ELSIF maintain_timer.Q THEN
    y2_state := TRUE;
END_IF;

Y2 := y2_state;

END_PROGRAM