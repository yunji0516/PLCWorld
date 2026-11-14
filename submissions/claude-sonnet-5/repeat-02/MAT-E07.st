PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    D20 : INT;

    (* Internal state *)
    startEdge : R_TRIG;
    state : INT := 0; // 0=idle, 1=pushing, 2=retracting, 3=done
END_VAR

startEdge(CLK := X10);

CASE state OF

0: // idle - wait for a valid start request
    Y20 := FALSE;
    Y21 := FALSE;
    IF startEdge.Q AND (D10 = 1) THEN
        state := 1;
    END_IF;

1: // pushing forward until the whole plate is received
    Y20 := TRUE;
    Y21 := FALSE;
    IF X22 THEN
        Y20 := FALSE;
        state := 2;
    END_IF;

2: // retracting pusher back to home
    Y20 := FALSE;
    Y21 := TRUE;
    IF X20 THEN
        Y21 := FALSE;
        state := 3;
    END_IF;

3: // done - pusher home, outputs off
    Y20 := FALSE;
    Y21 := FALSE;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    state := 0;

END_CASE;

// Completion claim: pusher home, outputs off, whole plate inside receiver
// and plate centre within the region that keeps the entire 800mm plate
// inside the receiver span [250,1100] -> centre in [650,700].
IF (state = 3) AND X22 AND X20 AND (NOT Y20) AND (NOT Y21)
   AND (D20 >= 650) AND (D20 <= 700) THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM