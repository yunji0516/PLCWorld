PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    D20 : INT;
    start_edge : R_TRIG;
    state : INT := 0;
    target : INT := 0;
END_VAR

start_edge(CLK := X10);

CASE state OF
  0:
     Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE; Y2 := FALSE;
     IF start_edge.Q THEN
        state := 1;
        target := 0;
     END_IF;

  1:
     Y22 := FALSE; Y23 := FALSE;
     IF X25 THEN
        IF X24 THEN
           target := target + 160;
        ELSE
           Y20 := FALSE; Y21 := FALSE;
           state := 2;
        END_IF;
     ELSE
        IF D20 < target THEN
           Y20 := TRUE; Y21 := FALSE;
        ELSIF D20 > target THEN
           Y20 := FALSE; Y21 := TRUE;
        ELSE
           Y20 := FALSE; Y21 := FALSE;
        END_IF;
     END_IF;

  2:
     Y20 := FALSE; Y21 := FALSE;
     Y22 := TRUE; Y23 := FALSE;
     IF X23 THEN
        Y22 := FALSE;
        state := 3;
     END_IF;

  3:
     Y20 := FALSE; Y21 := FALSE;
     Y22 := FALSE; Y23 := TRUE;
     IF X22 THEN
        Y23 := FALSE;
        state := 4;
     END_IF;

  4:
     Y20 := FALSE; Y21 := FALSE; Y22 := FALSE; Y23 := FALSE;
     Y2 := TRUE;
END_CASE;

END_PROGRAM