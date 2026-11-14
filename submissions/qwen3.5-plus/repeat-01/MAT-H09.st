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
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
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
    D12 : INT;
    D13 : INT;
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
    Y1F : BOOL;
    
    (* Internal variables *)
    st_start : BOOL := FALSE;
    swap_edge : R_TRIG;
    cap_a_edge : R_TRIG;
    cap_b_edge : R_TRIG;
    
    (* Refill states: 0=idle, 1=opening, 2=refilling, 3=closing, 4=wait_swap *)
    refill_state : INT := 0;
    swap_pulse : BOOL := FALSE;
    
    (* Line A states *)
    state_a : INT := 0;
    completed_a : INT := 0;
    valve_a_open_time : REAL := 0.0;
    pump_a_stop_ml : INT := 0;
    pump_a_target : INT := 0;
    
    (* Line B states *)
    state_b : INT := 0;
    completed_b : INT := 0;
    valve_b_open_time : REAL := 0.0;
    pump_b_stop_ml : INT := 0;
    pump_b_target : INT := 0;
    
    (* Completion tracking *)
    total_completed : INT := 0;
    complete_active : BOOL := FALSE;
    complete_timer : TON;
    
    (* Hose residual estimation *)
    hose_residual : INT := 180; (* 18.0 mL in 0.1 mL units, approx 1.4s * 13mL/s *)
    
    (* Pump timing for 0.15s valve open delay *)
    valve_open_delay_a : TON;
    valve_open_delay_b : TON;
    
    (* Scan counter *)
    scan_count : DINT := 0;
END_VAR

BEGIN

scan_count := scan_count + 1;

(* Edge detection for swap *)
swap_edge(CLK := X2F);

(* ===================== REFILL LOGIC ===================== *)
(* Prevent violations: no refill without batch, no swap during refill with liquid *)
CASE refill_state OF
    0: (* Idle - check if refill needed *)
        Y10 := FALSE;
        Y11 := FALSE;
        IF X2F AND (DINT(D0) < 100) AND NOT swap_busy THEN
            refill_state := 1;
        END_IF;
    1: (* Opening valve *)
        Y10 := TRUE;
        IF D0 > DINT(D1) - 10 THEN
            (* Already near batch capacity *)
            refill_state := 3;
            Y10 := FALSE;
        END_IF;
    2: (* Refilling *)
        Y10 := TRUE;
        IF DINT(D0) >= 140 THEN
            refill_state := 3;
            Y10 := FALSE;
        END_IF;
    3: (* Closing valve *)
        Y10 := FALSE;
        refill_state := 4;
    4: (* Wait for swap cycle *)
        Y10 := FALSE;
        IF NOT X2F THEN
            (* Batch depleted - swap needed *)
            IF NOT swap_busy AND X31 THEN
                swap_pulse := TRUE;
                refill_state := 5;
            ELSIF NOT X31 THEN
                (* No more batches *)
                refill_state := 0;
            END_IF;
        ELSE
            refill_state := 0;
        END_IF;
    5: (* Issue swap pulse *)
        Y11 := TRUE;
        IF X30 THEN
            Y11 := FALSE;
            refill_state := 6;
        ELSIF NOT X2F AND NOT X30 THEN
            Y11 := FALSE;
            refill_state := 0;
        END_IF;
    6: (* Wait for swap to complete *)
        Y11 := FALSE;
        IF NOT X30 AND X2F THEN
            refill_state := 0;
        ELSIF NOT X31 AND NOT X30 THEN
            refill_state := 0;
        END_IF;
END_CASE;

(* Ensure refill is off during swap_busy or if no batch *)
IF X30 OR NOT X2F THEN
    Y10 := FALSE;
END_IF;

(* ===================== LINE A FILLING ===================== *)
CASE state_a OF
    0: (* Idle - wait for start *)
        Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE;
        Y18 := FALSE; Y19 := FALSE; Y1A := FALSE;
        IF X0 AND completed_a < 3 THEN
            state_a := 1;
        END_IF;
    1: (* Feed container to station *)
        Y14 := TRUE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE;
        Y18 := FALSE; Y19 := FALSE; Y1A := FALSE;
        IF X10 THEN
            Y14 := FALSE;
            state_a := 2;
        END_IF;
    2: (* Clamp container *)
        Y14 := FALSE; Y15 := TRUE; Y16 := FALSE; Y17 := FALSE;
        Y18 := FALSE; Y19 := FALSE; Y1A := FALSE;
        IF X14 THEN
            state_a := 3;
        END_IF;
    3: (* Lower nozzle *)
        Y14 := FALSE; Y15 := TRUE; Y16 := TRUE; Y17 := FALSE;
        Y18 := FALSE; Y19 := FALSE; Y1A := FALSE;
        IF X13 THEN
            state_a := 4;
        END_IF;
    4: (* Open valve *)
        Y14 := FALSE; Y15 := TRUE; Y16 := TRUE; Y17 := TRUE;
        Y18 := FALSE; Y19 := FALSE; Y1A := FALSE;
        IF X16 THEN
            valve_a_open_time := 0.0;
            state_a := 5;
        END_IF;
    5: (* Wait 0.15s after valve opens *)
        Y14 := FALSE; Y15 := TRUE; Y16 := TRUE; Y17 := TRUE;
        Y18 := FALSE; Y19 := FALSE; Y1A := FALSE;
        valve_a_open_time := valve_a_open_time + 0.01;
        IF valve_a_open_time >= 0.15 THEN
            state_a := 6;
        END_IF;
    6: (* Pump until near target *)
        Y14 := FALSE; Y15 := TRUE; Y16 := TRUE; Y17 := TRUE;
        Y18 := TRUE; Y19 := FALSE; Y1A := FALSE;
        pump_a_target := DINT(D5);
        pump_a_stop_ml := pump_a_target - hose_residual;
        IF pump_a_stop_ml < 300 THEN
            pump_a_stop_ml := 300;
        END_IF;
        IF DINT(D4) >= pump_a_stop_ml THEN
            Y18 := FALSE;
            state_a := 7;
        END_IF;
    7: (* Pump stopped, wait for residual to fill *)
        Y14 := FALSE; Y15 := TRUE; Y16 := TRUE; Y17 := TRUE;
        Y18 := FALSE; Y19 := FALSE; Y1A := FALSE;
        IF DINT(D4) >= pump_a_target THEN
            state_a := 8;
        END_IF;
    8: (* Close valve *)
        Y14 := FALSE; Y15 := TRUE; Y16 := TRUE; Y17 := FALSE;
        Y18 := FALSE; Y19 := FALSE; Y1A := FALSE;
        IF X17 THEN
            state_a := 9;
        END_IF;
    9: (* Raise nozzle *)
        Y14 := FALSE; Y15 := TRUE; Y16 := FALSE; Y17 := FALSE;
        Y18 := FALSE; Y19 := FALSE; Y1A := FALSE;
        IF X12 THEN
            state_a := 10;
        END_IF;
    10: (* Unclamp *)
        Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE;
        Y18 := FALSE; Y19 := FALSE; Y1A := FALSE;
        IF NOT X14 THEN
            state_a := 11;
        END_IF;
    11: (* Move to wait position *)
        Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE;
        Y18 := FALSE; Y19 := TRUE; Y1A := FALSE;
        IF X1A THEN
            Y19 := FALSE;
            state_a := 12;
        END_IF;
    12: (* Capping - request cap if capper not busy *)
        Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE;
        Y18 := FALSE; Y19 := FALSE; Y1A := FALSE;
        IF NOT X2C AND X1A AND NOT X1B THEN
            cap_a_edge(CLK := TRUE);
            IF cap_a_edge.Q THEN
                state_a := 13;
            END_IF;
        ELSIF X1B THEN
            state_a := 14;
        END_IF;
    13: (* Wait for capper arrival and completion *)
        Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE;
        Y18 := FALSE; Y19 := FALSE; Y1A := FALSE;
        cap_a_edge(CLK := FALSE);
        IF X1B THEN
            state_a := 14;
        END_IF;
    14: (* Release to exit accumulation *)
        Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE;
        Y18 := FALSE; Y19 := FALSE; Y1A := TRUE;
        IF X1C THEN
            Y1A := FALSE;
            completed_a := completed_a + 1;
            total_completed := completed_a + completed_b;
            IF completed_a < 3 THEN
                state_a := 0;
            ELSE
                state_a := 15;
            END_IF;
        END_IF;
    15: (* Done waiting *)
        Y14 := FALSE; Y15 := FALSE; Y16 := FALSE; Y17 := FALSE;
        Y18 := FALSE; Y19 := FALSE; Y1A := FALSE;
END_CASE;

(* ===================== LINE B FILLING ===================== *)
CASE state_b OF
    0: (* Idle - wait for start *)
        Y1B := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE;
        Y1F := FALSE; Y20 := FALSE; Y21 := FALSE;
        IF X0 AND completed_b < 3 THEN
            state_b := 1;
        END_IF;
    1: (* Feed container to station *)
        Y1B := TRUE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE;
        Y1F := FALSE; Y20 := FALSE; Y21 := FALSE;
        IF X1E THEN
            Y1B := FALSE;
            state_b := 2;
        END_IF;
    2: (* Clamp container *)
        Y1B := FALSE; Y1C := TRUE; Y1D := FALSE; Y1E := FALSE;
        Y1F := FALSE; Y20 := FALSE; Y21 := FALSE;
        IF X22 THEN
            state_b := 3;
        END_IF;
    3: (* Lower nozzle *)
        Y1B := FALSE; Y1C := TRUE; Y1D := TRUE; Y1E := FALSE;
        Y1F := FALSE; Y20 := FALSE; Y21 := FALSE;
        IF X21 THEN
            state_b := 4;
        END_IF;
    4: (* Open valve *)
        Y1B := FALSE; Y1C := TRUE; Y1D := TRUE; Y1E := TRUE;
        Y1F := FALSE; Y20 := FALSE; Y21 := FALSE;
        IF X24 THEN
            valve_b_open_time := 0.0;
            state_b := 5;
        END_IF;
    5: (* Wait 0.15s after valve opens *)
        Y1B := FALSE; Y1C := TRUE; Y1D := TRUE; Y1E := TRUE;
        Y1F := FALSE; Y20 := FALSE; Y21 := FALSE;
        valve_b_open_time := valve_b_open_time + 0.01;
        IF valve_b_open_time >= 0.15 THEN
            state_b := 6;
        END_IF;
    6: (* Pump until near target *)
        Y1B := FALSE; Y1C := TRUE; Y1D := TRUE; Y1E := TRUE;
        Y1F := TRUE; Y20 := FALSE; Y21 := FALSE;
        pump_b_target := DINT(D10);
        pump_b_stop_ml := pump_b_target - hose_residual;
        IF pump_b_stop_ml < 300 THEN
            pump_b_stop_ml := 300;
        END_IF;
        IF DINT(D9) >= pump_b_stop_ml THEN
            Y1F := FALSE;
            state_b := 7;
        END_IF;
    7: (* Pump stopped, wait for residual to fill *)
        Y1B := FALSE; Y1C := TRUE; Y1D := TRUE; Y1E := TRUE;
        Y1F := FALSE; Y20 := FALSE; Y21 := FALSE;
        IF DINT(D9) >= pump_b_target THEN
            state_b := 8;
        END_IF;
    8: (* Close valve *)
        Y1B := FALSE; Y1C := TRUE; Y1D := TRUE; Y1E := FALSE;
        Y1F := FALSE; Y20 := FALSE; Y21 := FALSE;
        IF X25 THEN
            state_b := 9;
        END_IF;
    9: (* Raise nozzle *)
        Y1B := FALSE; Y1C := TRUE; Y1D := FALSE; Y1E := FALSE;
        Y1F := FALSE; Y20 := FALSE; Y21 := FALSE;
        IF X20 THEN
            state_b := 10;
        END_IF;
    10: (* Unclamp *)
        Y1B := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE;
        Y1F := FALSE; Y20 := FALSE; Y21 := FALSE;
        IF NOT X22 THEN
            state_b := 11;
        END_IF;
    11: (* Move to wait position *)
        Y1B := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE;
        Y1F := FALSE; Y20 := TRUE; Y21 := FALSE;
        IF X28 THEN
            Y20 := FALSE;
            state_b := 12;
        END_IF;
    12: (* Capping - request cap if capper not busy *)
        Y1B := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE;
        Y1F := FALSE; Y20 := FALSE; Y21 := FALSE;
        IF NOT X2C AND X28 AND NOT X29 THEN
            cap_b_edge(CLK := TRUE);
            IF cap_b_edge.Q THEN
                state_b := 13;
            END_IF;
        ELSIF X29 THEN
            state_b := 14;
        END_IF;
    13: (* Wait for capper arrival and completion *)
        Y1B := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE;
        Y1F := FALSE; Y20 := FALSE; Y21 := FALSE;
        cap_b_edge(CLK := FALSE);
        IF X29 THEN
            state_b := 14;
        END_IF;
    14: (* Release to exit accumulation *)
        Y1B := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE;
        Y1F := FALSE; Y20 := FALSE; Y21 := TRUE;
        IF X2A THEN
            Y21 := FALSE;
            completed_b := completed_b + 1;
            total_completed := completed_a + completed_b;
            IF completed_b < 3 THEN
                state_b := 0;
            ELSE
                state_b := 15;
            END_IF;
        END_IF;
    15: (* Done waiting *)
        Y1B := FALSE; Y1C := FALSE; Y1D := FALSE; Y1E := FALSE;
        Y1F := FALSE; Y20 := FALSE; Y21 := FALSE;
END_CASE;

(* ===================== COMPLETION ===================== *)
total_completed := completed_a + completed_b;

IF total_completed >= 6 AND NOT X30 AND NOT Y10 AND NOT Y18 AND NOT Y1F 
   AND NOT Y17 AND NOT Y1E AND X12 AND X20 AND NOT X2C THEN
    complete_active := TRUE;
    complete_timer(IN := TRUE, PT := T#500ms);
ELSE
    complete_active := FALSE;
    complete_timer(IN := FALSE, PT := T#500ms);
END_IF;

Y22 := complete_timer.Q;

(* Ensure outputs are safe when complete *)
IF complete_timer.Q THEN
    Y10 := FALSE; Y11 := FALSE; Y18 := FALSE; Y1F := FALSE;
    Y17 := FALSE; Y1E := FALSE;
END_IF;

END_PROGRAM;