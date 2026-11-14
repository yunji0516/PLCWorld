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
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
    Y27 : BOOL;
    Y28 : BOOL;
    Y29 : BOOL;

    state : INT := 0;
    tape_step : INT := 0;
    roll_count : INT := 0;
END_VAR

CASE state OF
    0:
        Y1E := TRUE; 
        IF X0 THEN 
            state := 10; 
        END_IF;

    10:
        IF X10 THEN 
            Y10 := TRUE; 
            state := 11; 
        END_IF;
    11:
        Y10 := FALSE;
        IF X12 THEN 
            state := 12; 
        END_IF;
    12:
        Y12 := TRUE;
        IF X14 THEN 
            state := 20; 
        END_IF;

    20:
        IF X11 THEN 
            Y11 := TRUE; 
            state := 21; 
        END_IF;
    21:
        Y11 := FALSE;
        IF X13 THEN 
            state := 30; 
        END_IF;

    30:
        Y14 := TRUE;
        IF D2 >= D0 THEN
            Y14 := FALSE;
            state := 40;
        END_IF;

    40:
        Y13 := TRUE;
        IF X15 THEN 
            state := 50; 
        END_IF;

    50:
        Y15 := TRUE;
        state := 51;
    51:
        Y15 := FALSE;
        IF X16 THEN 
            state := 60; 
        END_IF;

    60:
        IF X17 THEN 
            Y16 := TRUE; 
            state := 61; 
        END_IF;
    61:
        Y16 := FALSE;
        state := 100;

    100:
        Y23 := TRUE;
        IF X2C THEN
            Y24 := TRUE;
            state := 110;
        END_IF;
    110:
        IF X2E THEN 
            state := 120; 
        END_IF;
    120:
        IF X2D THEN
            Y23 := FALSE;
            state := 130;
        END_IF;

    130:
        Y17 := TRUE;
        state := 131;
    131:
        Y17 := FALSE;
        IF X19 THEN
            Y24 := FALSE;
            state := 140;
        END_IF;

    140:
        Y1E := FALSE;
        Y1F := TRUE;
        IF X1E THEN 
            state := 150; 
        END_IF;

    150:
        Y18 := TRUE;
        Y19 := TRUE;
        IF X1B AND X1C THEN 
            state := 160; 
        END_IF;

    160:
        Y12 := FALSE;
        Y13 := FALSE;
        IF X24 AND X25 THEN 
            state := 170; 
        END_IF;

    170:
        Y1A := TRUE;
        IF D5 >= D4 THEN
            Y1A := FALSE;
            state := 180;
        END_IF;

    180:
        Y12 := TRUE;
        Y13 := TRUE;
        IF X14 AND X15 THEN 
            state := 190; 
        END_IF;

    190:
        Y1C := TRUE;
        Y1D := TRUE;
        state := 191;
    191:
        Y1C := FALSE;
        Y1D := FALSE;
        IF X27 AND X28 THEN 
            state := 200; 
        END_IF;

    200:
        Y1A := TRUE;
        IF X26 THEN
            Y1A := FALSE;
            state := 210;
        END_IF;

    210:
        IF tape_step = 6 THEN 
            state := 220; 
        END_IF;

    220:
        Y1B := TRUE;
        Y18 := FALSE;
        Y19 := FALSE;
        IF X1F THEN 
            state := 230; 
        END_IF;

    230:
        Y1F := FALSE;
        Y1E := TRUE;
        IF X1D THEN 
            state := 240; 
        END_IF;

    240:
        Y20 := TRUE;
        state := 241;
    241:
        Y20 := FALSE;
        IF X21 THEN 
            state := 242; 
        END_IF;
    242:
        IF X22 THEN 
            state := 250; 
        END_IF;

    250:
        Y21 := TRUE;
        state := 251;
    251:
        Y21 := FALSE;
        Y1B := FALSE;
        state := 252;
    252:
        IF X34 AND X35 AND X20 THEN 
            state := 260; 
        END_IF;

    260:
        Y29 := TRUE;
        IF NOT X34 THEN
            Y29 := FALSE;
            state := 270;
        END_IF;

    270:
        roll_count := roll_count + 1;
        IF roll_count < 3 THEN
            state := 100;
        ELSE
            state := 300;
        END_IF;

    300:
        Y22 := TRUE;

END_CASE;

CASE tape_step OF
    0:
        IF state = 170 THEN
            Y25 := TRUE;
            tape_step := 1;
        END_IF;
    1:
        IF X2F THEN
            Y26 := TRUE;
            tape_step := 2;
        END_IF;
    2:
        IF X30 THEN
            Y27 := TRUE;
            tape_step := 3;
        END_IF;
    3:
        Y27 := FALSE;
        IF X31 AND X2A THEN
            tape_step := 4;
        END_IF;
    4:
        IF state = 210 THEN
            Y28 := TRUE;
            tape_step := 5;
        END_IF;
    5:
        Y28 := FALSE;
        IF X33 THEN
            tape_step := 6;
        END_IF;
    6:
        IF state >= 220 THEN
            Y25 := FALSE;
            Y26 := FALSE;
            tape_step := 7;
        END_IF;
    7:
        IF state < 170 THEN
            tape_step := 0;
        END_IF;
END_CASE;

END_PROGRAM