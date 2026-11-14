PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;
    (* Add internal variables here. *)
    state : INT := 0;
    requestLatched : BOOL := FALSE;
    completed : BOOL := FALSE;
    safeLimit : DINT;
    clearanceTarget : DINT;
    clearanceThreshold : DINT;
    rotationSlideTarget : DINT := 0;
    absSlideSpeed : DINT;
    slideError : DINT;
    clearanceOK : BOOL;
    slideTerminalOK : BOOL;
    terminalOK : BOOL;
    terminalTimer : TON;
END_VAR

safeLimit := D16;
IF safeLimit > 50000 THEN
    safeLimit := 50000;
END_IF;
IF safeLimit < 0 THEN
    safeLimit := 0;
END_IF;

clearanceTarget := safeLimit - 200;
IF clearanceTarget < 0 THEN
    clearanceTarget := 0;
END_IF;

clearanceThreshold := safeLimit - 100;
IF clearanceThreshold < 0 THEN
    clearanceThreshold := 0;
END_IF;

absSlideSpeed := ABS(D13);
slideError := ABS(D12 - D15);

clearanceOK := X11 AND (absSlideSpeed <= 99) AND (D12 <= clearanceThreshold);
slideTerminalOK := (slideError <= 19) AND (absSlideSpeed <= 99);

IF (NOT requestLatched) AND X10 THEN
    requestLatched := TRUE;
    state := 10;
END_IF;

CASE state OF
    0:
        D20 := D10;
        D21 := D12;
        Y20 := FALSE;
        Y21 := FALSE;

    10:
        D20 := D10;
        Y20 := FALSE;
        Y21 := TRUE;

        IF D12 > clearanceTarget THEN
            D21 := clearanceTarget;
        ELSE
            D21 := D12;
        END_IF;

        IF clearanceOK THEN
            rotationSlideTarget := D12;
            state := 20;
        END_IF;

    20:
        D20 := D14;
        D21 := rotationSlideTarget;
        Y20 := TRUE;
        Y21 := TRUE;

        IF X12 THEN
            state := 30;
        END_IF;

    30:
        D20 := D14;
        Y20 := TRUE;
        Y21 := TRUE;

        IF X12 THEN
            D21 := D15;
        ELSE
            D21 := rotationSlideTarget;
        END_IF;

    40:
        D20 := D14;
        D21 := D15;
        Y20 := TRUE;
        Y21 := TRUE;

ELSE
        D20 := D10;
        D21 := D12;
        Y20 := FALSE;
        Y21 := FALSE;
        state := 0;
END_CASE;

terminalOK := ((state = 30) OR (state = 40)) AND X12 AND slideTerminalOK;

terminalTimer(IN := terminalOK AND (NOT completed), PT := T#30ms);

IF terminalTimer.Q THEN
    completed := TRUE;
    state := 40;
END_IF;

Y2 := completed;

END_PROGRAM