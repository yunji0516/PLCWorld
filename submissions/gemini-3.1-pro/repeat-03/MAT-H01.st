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
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    X33 : BOOL;
    X34 : BOOL;
    X35 : BOOL;
    X36 : BOOL;
    X37 : BOOL;
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
    D100 : INT;
    D101 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    X2E : BOOL;
    X2F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;

    (* Internal variables *)
    started : BOOL := FALSE;
    
    A_State : INT := 0;
    B_State : INT := 0;
    I_State : INT := 0;
    R_State : INT := 0;
    
    parts_processed_A : INT := 0;
    parts_processed_B : INT := 0;
    parts_delivered : INT := 0;
    reject_count : INT := 0;
    
    Dest : INT := 0;
END_VAR

(* Initialization & Start logic *)
IF NOT started THEN
    IF X0 THEN
        started := TRUE;
    END_IF
    
    (* Safe initial states for robot jaw and cells *)
    Y11 := TRUE; Y10 := FALSE;
    Y13 := TRUE; 
    
    Y15 := TRUE; Y16 := FALSE;
    Y18 := TRUE; Y17 := FALSE;
    
    Y1A := TRUE; Y1B := FALSE;
    Y1D := TRUE; Y1C := FALSE;
    
    Y12 := FALSE; Y19 := FALSE; Y1E := FALSE;
    Y14 := FALSE;
    
    A_State := 0; B_State := 0; I_State := 0; R_State := 0;
    parts_processed_A := 0; parts_processed_B := 0;
    parts_delivered := 0; reject_count := 0; Dest := 0;
    RETURN;
END_IF

(* Outfeed conveyor always ON *)
Y13 := TRUE;

(* Main Robot Control State Machine *)
CASE R_State OF
    0:
        IF I_State = 5 THEN
            R_State := 100;
        ELSIF A_State = 7 AND I_State = 0 AND X21 AND X23 AND X25 AND X26 THEN
            R_State := 200;
        ELSIF B_State = 7 AND I_State = 0 AND X2C AND X2E AND X30 AND X31 THEN
            R_State := 300;
        ELSIF A_State = 0 AND parts_processed_A < 2 AND X21 AND X23 AND X25 AND X26 AND X1E THEN
            R_State := 400;
        ELSIF B_State = 0 AND parts_processed_B < 2 AND X2C AND X2E AND X30 AND X31 AND X29 THEN
            R_State := 500;
        END_IF

    (* Task 1: Unload Inspection *)
    100:
        IF NOT X10 THEN D100 := 5; D101 := D101 + 1; R_State := 101; END_IF
    101:
        IF D0 = 5 AND NOT X10 THEN
            Y10 := TRUE; Y11 := FALSE; R_State := 102;
        END_IF
    102:
        IF X12 AND NOT X10 THEN
            IF D4 >= 5800 AND D4 <= 6200 AND D5 >= 5800 AND D5 <= 6200 THEN
                Dest := 7;
            ELSE
                Dest := 8 + reject_count;
                reject_count := reject_count + 1;
            END_IF
            R_State := 1021;
        END_IF
    1021:
        IF Dest = 7 THEN
            IF X1A AND NOT X10 THEN 
                D100 := Dest; D101 := D101 + 1; R_State := 103; 
            END_IF
        ELSE
            IF NOT X10 THEN 
                D100 := Dest; D101 := D101 + 1; R_State := 103; 
            END_IF
        END_IF
    103:
        IF D0 = Dest AND NOT X10 THEN
            Y10 := FALSE; Y11 := TRUE; R_State := 104;
        END_IF
    104:
        IF X11 AND NOT X10 THEN
            D100 := 0; D101 := D101 + 1; R_State := 105;
        END_IF
    105:
        IF D0 = 0 AND NOT X10 THEN
            I_State := 0;
            parts_delivered := parts_delivered + 1;
            R_State := 0;
        END_IF

    (* Task 2: Unload Cell A *)
    200:
        IF NOT X10 THEN D100 := 3; D101 := D101 + 1; R_State := 201; END_IF
    201:
        IF D0 = 3 AND NOT X10 THEN
            Y10 := TRUE; Y11 := FALSE; R_State := 202;
        END_IF
    202:
        IF X12 AND NOT X10 THEN
            D100 := 5; D101 := D101 + 1; R_State := 203;
        END_IF
    203:
        IF D0 = 5 AND NOT X10 THEN
            Y10 := FALSE; Y11 := TRUE; R_State := 204;
        END_IF
    204:
        IF X11 AND NOT X10 THEN
            D100 := 0; D101 := D101 + 1; R_State := 205;
        END_IF
    205:
        IF D0 = 0 AND NOT X10 THEN
            A_State := 0;
            I_State := 2;
            R_State := 0;
        END_IF

    (* Task 3: Unload Cell B *)
    300:
        IF NOT X10 THEN D100 := 4; D101 := D101 + 1; R_State := 301; END_IF
    301:
        IF D0 = 4 AND NOT X10 THEN
            Y10 := TRUE; Y11 := FALSE; R_State := 302;
        END_IF
    302:
        IF X12 AND NOT X10 THEN
            D100 := 5; D101 := D101 + 1; R_State := 303;
        END_IF
    303:
        IF D0 = 5 AND NOT X10 THEN
            Y10 := FALSE; Y11 := TRUE; R_State := 304;
        END_IF
    304:
        IF X11 AND NOT X10 THEN
            D100 := 0; D101 := D101 + 1; R_State := 305;
        END_IF
    305:
        IF D0 = 0 AND NOT X10 THEN
            B_State := 0;
            I_State := 2;
            R_State := 0;
        END_IF

    (* Task 4: Load Cell A *)
    400:
        IF NOT X10 THEN D100 := 1; D101 := D101 + 1; R_State := 401; END_IF
    401:
        IF D0 = 1 AND NOT X10 THEN
            Y10 := TRUE; Y11 := FALSE; R_State := 402;
        END_IF
    402:
        IF X12 AND NOT X10 THEN
            D100 := 3; D101 := D101 + 1; R_State := 403;
        END_IF
    403:
        IF D0 = 3 AND NOT X10 THEN
            Y10 := FALSE; Y11 := TRUE; R_State := 404;
        END_IF
    404:
        IF X11 AND NOT X10 THEN
            D100 := 0; D101 := D101 + 1; R_State := 405;
        END_IF
    405:
        IF D0 = 0 AND NOT X10 THEN
            A_State := 2;
            parts_processed_A := parts_processed_A + 1;
            R_State := 0;
        END_IF

    (* Task 5: Load Cell B *)
    500:
        IF NOT X10 THEN D100 := 2; D101 := D101 + 1; R_State := 501; END_IF
    501:
        IF D0 = 2 AND NOT X10 THEN
            Y10 := TRUE; Y11 := FALSE; R_State := 502;
        END_IF
    502:
        IF X12 AND NOT X10 THEN
            D100 := 4; D101 := D101 + 1; R_State := 503;
        END_IF
    503:
        IF D0 = 4 AND NOT X10 THEN
            Y10 := FALSE; Y11 := TRUE; R_State := 504;
        END_IF
    504:
        IF X11 AND NOT X10 THEN
            D100 := 0; D101 := D101 + 1; R_State := 505;
        END_IF
    505:
        IF D0 = 0 AND NOT X10 THEN
            B_State := 2;
            parts_processed_B := parts_processed_B + 1;
            R_State := 0;
        END_IF
END_CASE

(* Cell A State Machine *)
CASE A_State OF
    0:
        ; (* Idle, Wait for Robot *)
    2:
        IF X22 AND X24 AND X27 THEN
            IF NOT X20 THEN A_State := 3; END_IF
        END_IF
    3:
        IF X20 THEN
            A_State := 4;
        END_IF
    4:
        IF X1F AND NOT X20 THEN
            A_State := 5;
        END_IF
    5:
        IF X21 AND X23 THEN
            A_State := 7;
        END_IF
    7:
        ; (* Ready to Unload *)
END_CASE

(* Cell B State Machine *)
CASE B_State OF
    0:
        ; (* Idle, Wait for Robot *)
    2:
        IF X2D AND X2F AND X32 THEN
            IF NOT X2B THEN B_State := 3; END_IF
        END_IF
    3:
        IF X2B THEN
            B_State := 4;
        END_IF
    4:
        IF X2A AND NOT X2B THEN
            B_State := 5;
        END_IF
    5:
        IF X2C AND X2E THEN
            B_State := 7;
        END_IF
    7:
        ; (* Ready to Unload *)
END_CASE

(* Inspection State Machine *)
CASE I_State OF
    0:
        ; (* Idle, Wait for Robot *)
    2:
        IF X14 AND NOT X15 AND X1C THEN
            I_State := 3;
        END_IF
    3:
        IF X15 THEN
            I_State := 4;
        END_IF
    4:
        IF NOT X15 AND X16 THEN
            I_State := 5;
        END_IF
    5:
        ; (* Ready to Unload *)
END_CASE

(* Equipment Outputs Management *)
IF A_State = 0 OR A_State = 5 OR A_State = 6 OR A_State = 7 THEN
    Y15 := TRUE; Y16 := FALSE;
    Y18 := TRUE; Y17 := FALSE;
ELSE
    Y15 := FALSE; Y16 := TRUE;
    Y18 := FALSE; Y17 := TRUE;
END_IF

IF B_State = 0 OR B_State = 5 OR B_State = 6 OR B_State = 7 THEN
    Y1A := TRUE; Y1B := FALSE;
    Y1D := TRUE; Y1C := FALSE;
ELSE
    Y1A := FALSE; Y1B := TRUE;
    Y1D := FALSE; Y1C := TRUE;
END_IF

Y19 := (A_State = 3);
Y1E := (B_State = 3);
Y12 := (I_State = 3);

(* Completion Condition *)
IF parts_delivered = 4 AND R_State = 0 AND A_State = 0 AND B_State = 0 AND I_State = 0 
   AND NOT X10 AND NOT X20 AND NOT X2B AND NOT X15 THEN
    Y14 := TRUE;
END_IF

END_PROGRAM