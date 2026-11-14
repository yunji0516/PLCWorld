PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    D14 : DINT;
    X12 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    D20 : DINT;
    Y2 : BOOL;
    
    state : INT;
    maintain_count : INT;
    observe_count : INT;
END_VAR

CASE state OF
    0:
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        maintain_count := 0;
        observe_count := 0;
        IF X10 THEN
            state := 1;
        END_IF;
        
    1:
        Y20 := TRUE;
        Y21 := FALSE;
        Y2 := FALSE;
        maintain_count := 0;
        observe_count := 0;
        IF X11 THEN
            D20 := D14;
            Y21 := TRUE;
            state := 2;
        END_IF;
        
    2:
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := FALSE;
        maintain_count := maintain_count + 1;
        IF maintain_count >= 3 THEN
            state := 3;
        END_IF;
        
    3:
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := TRUE;
        observe_count := observe_count + 1;
        IF observe_count >= 10 THEN
            state := 4;
        END_IF;
        
    4:
        Y20 := TRUE;
        Y21 := TRUE;
        Y2 := TRUE;
        
END_CASE;

END_PROGRAM