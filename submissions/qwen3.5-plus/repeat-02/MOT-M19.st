PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    D32 : DINT;
    D33 : DINT;
    Y23 : BOOL;
    Y2 : BOOL;
    start_edge : R_TRIG;
    state : INT := 0;
    stored_first : DINT := 0;
    stored_second : DINT := 0;
    stored_lane : DINT := 0;
    start_time : DINT := 0;
    pos_tol : DINT := 20;
    vel_tol : DINT := 100;
    stability_count : DINT := 0;
END_VAR

// State constants
// 0=STANDBY, 1=CAPTURE_REQ, 2=BASE_PREP, 3=ENGAGE, 4=A1_MOVE, 5=A2_MOVE, 6=CHECK, 7=RETRACT, 8=RETURN_C_A, 9=RETURN_D, 10=DONE

start_edge(CLK := X0);

// Safety timeout - reset to standby if taking too long
IF (state <> 0) AND (DINT(start_time) > 15000) THEN
    state := 0;
    stability_count := 0;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2 := FALSE;
END_IF;

CASE state OF

// STANDBY - wait for start request
0:
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2 := FALSE;
    IF start_edge.Q THEN
        start_time := 0;
        state := 1;
    END_IF;

// CAPTURE_REQ - store request values, move B to avoid lane
1:
    stored_first := D101;
    stored_second := D102;
    stored_lane := D103;
    
    D24 := 7000;
    D25 := 1000;
    Y21 := TRUE;
    
    Y20 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    
    IF (abs(D12 - 7000) <= pos_tol) AND (abs(D13) <= vel_tol) THEN
        state := 2;
    END_IF;

// BASE_PREP - move C to work position 0 and D to lane alignment (parallel)
2:
    D28 := 0;
    D29 := 1000;
    Y22 := TRUE;
    D32 := stored_lane;
    D33 := 1000;
    Y23 := TRUE;
    
    Y20 := FALSE;
    
    IF (abs(D14) <= pos_tol) AND (abs(D15) <= vel_tol) AND
       (abs(D16 - stored_lane) <= pos_tol) AND (abs(D17) <= vel_tol) THEN
        state := 3;
    END_IF;

// ENGAGE - move B to 70 for guide engagement
3:
    D24 := 7000;
    D25 := 1000;
    Y21 := TRUE;
    
    D28 := 0;
    D29 := 1000;
    Y22 := TRUE;
    D32 := stored_lane;
    D33 := 1000;
    Y23 := TRUE;
    
    Y20 := FALSE;
    
    IF (abs(D12 - 7000) <= pos_tol) AND (abs(D13) <= vel_tol) THEN
        state := 4;
    END_IF;

// A1_MOVE - move A to first position
4:
    D20 := stored_first;
    D21 := 1000;
    Y20 := TRUE;
    
    D28 := 0;
    D29 := 1000;
    Y22 := TRUE;
    D32 := stored_lane;
    D33 := 1000;
    Y23 := TRUE;
    D24 := 7000;
    D25 := 1000;
    Y21 := TRUE;
    
    IF (abs(D10 - stored_first) <= pos_tol) AND (abs(D11) <= vel_tol) THEN
        state := 5;
    END_IF;

// A2_MOVE - move A to second position, must not break C=0 or D=lane
5:
    D20 := stored_second;
    D21 := 1000;
    Y20 := TRUE;
    
    D28 := 0;
    D29 := 1000;
    Y22 := TRUE;
    D32 := stored_lane;
    D33 := 1000;
    Y23 := TRUE;
    D24 := 7000;
    D25 := 1000;
    Y21 := TRUE;
    
    IF (abs(D10 - stored_second) <= pos_tol) AND (abs(D11) <= vel_tol) THEN
        state := 6;
    END_IF;

// CHECK - verify engagement and alignment, then assert completion
6:
    D20 := stored_second;
    D21 := 1000;
    Y20 := TRUE;
    
    D28 := 0;
    D29 := 1000;
    Y22 := TRUE;
    D32 := stored_lane;
    D33 := 1000;
    Y23 := TRUE;
    D24 := 7000;
    D25 := 1000;
    Y21 := TRUE;
    
    // Check guide engagement: B must be at 70
    // Check work position: C must be at 0
    // Check lane alignment: D must be at lane value
    IF (abs(D12 - 7000) <= pos_tol) AND (abs(D13) <= vel_tol) AND
       (abs(D14) <= pos_tol) AND (abs(D15) <= vel_tol) AND
       (abs(D16 - stored_lane) <= pos_tol) AND (abs(D17) <= vel_tol) THEN
        stability_count := stability_count + 1;
    ELSE
        stability_count := 0;
    END_IF;
    
    // 10 scans at 10ms = 100ms stability duration
    IF stability_count >= 10 THEN
        Y2 := TRUE;
        state := 7;
        stability_count := 0;
    END_IF;

// RETRACT - retract B back to 0
7:
    D24 := 0;
    D25 := 1000;
    Y21 := TRUE;
    Y2 := TRUE;
    
    D20 := stored_second;
    D21 := 1000;
    Y20 := TRUE;
    D28 := 0;
    D29 := 1000;
    Y22 := TRUE;
    D32 := stored_lane;
    D33 := 1000;
    Y23 := TRUE;
    
    IF (abs(D12) <= pos_tol) AND (abs(D13) <= vel_tol) THEN
        state := 8;
    END_IF;

// RETURN_C_A - return C to standby 80 and A to standby 60
8:
    D28 := 8000;
    D29 := 1000;
    Y22 := TRUE;
    D20 := 6000;
    D21 := 1000;
    Y20 := TRUE;
    Y2 := TRUE;
    
    Y21 := FALSE;
    D32 := stored_lane;
    D33 := 1000;
    Y23 := TRUE;
    
    IF (abs(D14 - 8000) <= pos_tol) AND (abs(D15) <= vel_tol) THEN
        state := 9;
    END_IF;

// RETURN_D - return D to 0
9:
    D32 := 0;
    D33 := 1000;
    Y23 := TRUE;
    Y2 := TRUE;
    
    D20 := 6000;
    D21 := 1000;
    Y20 := TRUE;
    D28 := 8000;
    D29 := 1000;
    Y22 := TRUE;
    
    IF (abs(D16) <= pos_tol) AND (abs(D17) <= vel_tol) THEN
        state := 10;
    END_IF;

// DONE - disable all axes and reset
10:
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2 := FALSE;
    state := 0;

END_CASE;

// Update elapsed time
start_time := start_time + 10;

END_PROGRAM