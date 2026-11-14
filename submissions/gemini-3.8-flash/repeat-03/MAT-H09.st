```iecst
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

    started : BOOL;
    all_finished : BOOL;
    complete_timer : TON;

    (* Refill and Swap control *)
    swap_pulse : BOOL;
    swap_req : BOOL;
    prev_swap_busy : BOOL;

    (* Line A state machine *)
    a_state : INT; (* 0: Idle/Wait Source, 1: Feeding, 2: Clamping, 3: Lowering, 4: Valve Opening, 5: Filling, 6: Draining Line, 7: Valve Closing, 8: Raising Nozzle, 9: Unclamping, 10: Transfer Out, 11: Done *)
    a_valve_timer : TON;
    a_feed_pulse : BOOL;
    a_out_pulse : BOOL;
    a_release_pulse : BOOL;

    (* Line B state machine *)
    b_state : INT;
    b_valve_timer : TON;
    b_feed_pulse : BOOL;
    b_out_pulse : BOOL;
    b_release_pulse : BOOL;

    (* Capping coordination *)
    cap_a_req : BOOL;
    cap_b_req : BOOL;
    capper_turn : INT; (* 0: Line A priority, 1: Line B priority *)

END_VAR

IF X0 THEN
    started := TRUE;
END_IF;

IF NOT started THEN
    RETURN;
END_IF;

(* ---------------------------------------------------------
   1. REFILL AND SWAP MANAGEMENT
   Tank Capacity: 160 mL (1600 in 0.1 mL)
   Refill flows at 14 mL/s when Y10 is ON and batch_ready is TRUE.
   Keep tank level safe (depletion/overflow prohibited).
   Target tank level between 40 mL and 130 mL (400 to 1300).
   --------------------------------------------------------- *)

(* Refill control *)
IF X2F AND (D1 > 0) AND (D0 <= 1200) AND NOT X30 AND NOT swap_req THEN
    Y10 := TRUE;
ELSIF (D0 >= 1400) OR NOT X2F OR (D1 <= 0) OR swap_req THEN
    Y10 := FALSE;
END_IF;

(* Swap request when current batch is exhausted *)
IF NOT Y10 AND (D1 <= 0) AND X31 AND NOT X30 AND NOT swap_req THEN
    swap_req := TRUE;
END_IF;

IF swap_req THEN
    IF NOT prev_swap_busy AND NOT X30 THEN
        Y11 := TRUE;
    ELSE
        Y11 := FALSE;
    END_IF;
    IF X30 THEN
        swap_req := FALSE;
        Y11 := FALSE;
    END_IF;
ELSE
    Y11 := FALSE;
END_IF;
prev_swap_busy := X30;

(* ---------------------------------------------------------
   2. LINE A CONTROL
   --------------------------------------------------------- *)
CASE a_state OF
    0: (* Wait for container at source and station empty *)
        IF X11 AND NOT X10 AND NOT a_feed_pulse THEN
            a_feed_pulse := TRUE;
            a_state := 1;
        END_IF;

    1: (* Feeding *)
        IF X10 THEN
            a_feed_pulse := FALSE;
            a_state := 2;
        END_IF;

    2: (* Clamp container *)
        IF X14 THEN
            a_state := 3;
        END_IF;

    3: (* Lower nozzle *)
        IF X13 THEN
            a_state := 4;
        END_IF;

    4: (* Open valve and wait >= 0.15s (150ms) *)
        IF X16 AND a_valve_timer.Q THEN
            (* Wait for sufficient liquid in common tank before starting pump to avoid depletion *)
            IF D0 >= 300 THEN
                a_state := 5;
            END_IF;
        END_IF;

    5: (* Filling: pump runs until received + line reaches goal *)
        IF (D4 + D6) >= D5 THEN
            a_state := 6;
        END_IF;

    6: (* Wait for residual fluid in line to drain into container *)
        IF (D6 <= 0) AND X18 THEN
            a_state := 7;
        END_IF;

    7: (* Close valve *)
        IF X17 THEN
            a_state := 8;
        END_IF;

    8: (* Raise nozzle *)
        IF X12 THEN
            a_state := 9;
        END_IF;

    9: (* Unclamp *)
        IF X15 THEN
            (* Check if waiting cap station is clear *)
            IF NOT X1A AND NOT X19 THEN
                a_out_pulse := TRUE;
                a_state := 10;
            END_IF;
        END_IF;

    10: (* Transfer out *)
        IF X1A OR NOT X10 THEN
            a_out_pulse := FALSE;
            IF X1D THEN
                a_state := 11;
            ELSE
                a_state := 0;
            END_IF;
        END_IF;

    11: (* Line A completely finished all containers *)
        a_out_pulse := FALSE;
END_CASE;

(* Line A Actuator assignments *)
Y14 := a_feed_pulse;
Y15 := (a_state >= 2) AND (a_state <= 8);
Y16 := (a_state >= 3) AND (a_state <= 7);
Y17 := (a_state >= 4) AND (a_state <= 6);
Y18 := (a_state = 5) AND (D0 > 100);
Y19 := a_out_pulse;

(* Line A Valve open timer *)
a_valve_timer(IN := (a_state = 4) AND X16, PT := T#200ms);

(* ---------------------------------------------------------
   3. LINE B CONTROL
   --------------------------------------------------------- *)
CASE b_state OF
    0: (* Wait for container at source and station empty *)
        IF X1F AND NOT X1E AND NOT b_feed_pulse THEN
            b_feed_pulse := TRUE;
            b_state := 1;
        END_IF;

    1: (* Feeding *)
        IF X1E THEN
            b_feed_pulse := FALSE;
            b_state := 2;
        END_IF;

    2: (* Clamp container *)
        IF X22 THEN
            b_state := 3;
        END_IF;

    3: (* Lower nozzle *)
        IF X21 THEN
            b_state := 4;
        END_IF;

    4: (* Open valve and wait >= 0.15s (150ms) *)
        IF X24 AND b_valve_timer.Q THEN
            (* Wait for sufficient liquid in common tank before starting pump *)
            IF D0 >= 300 THEN
                b_state := 5;
            END_IF;
        END_IF;

    5: (* Filling: pump runs until received + line reaches goal *)
        IF (D9 + D11) >= D10 THEN
            b_state := 6;
        END_IF;

    6: (* Wait for residual fluid in line to drain into container *)
        IF (D11 <= 0) AND X26 THEN
            b_state := 7;
        END_IF;

    7: (* Close valve *)
        IF X25 THEN
            b_state := 8;
        END_IF;

    8: (* Raise nozzle *)
        IF X20 THEN
            b_state := 9;
        END_IF;

    9: (* Unclamp *)
        IF X23 THEN
            (* Check if waiting cap station is clear *)
            IF NOT X28 AND NOT X27 THEN
                b_out_pulse := TRUE;
                b_state := 10;
            END_IF;
        END_IF;

    10: (* Transfer out *)
        IF X28 OR NOT X1E THEN
            b_out_pulse := FALSE;
            IF X2B THEN
                b_state := 11;
            ELSE
                b_state := 0;
            END_IF;
        END_IF;

    11: (* Line B completely finished all containers *)
        b_out_pulse := FALSE;
END_CASE;

(* Line B Actuator assignments *)
Y1B := b_feed_pulse;
Y1C := (b_state >= 2) AND (b_state <= 8);
Y1D := (b_state >= 3) AND (b_state <= 7);
Y1E := (b_state >= 4) AND (b_state <= 6);
Y1F := (b_state = 5) AND (D0 > 100);
Y20 := b_out_pulse;

(* Line B Valve open timer *)
b_valve_timer(IN := (b_state = 4) AND X24, PT := T#200ms);

(* ---------------------------------------------------------
   4. CAPPING COORDINATION
   One common capping head serves both lines.
   Requests can be sent only when capper is NOT busy, container is
   present at wait position, and container is NOT yet capped.
   --------------------------------------------------------- *)
cap_a_req := X1A AND NOT X1B;
cap_b_req := X28 AND NOT X29;

Y12 := FALSE;
Y13 := FALSE;

IF NOT X2C THEN
    IF capper_turn = 0 THEN
        IF cap_a_req THEN
            Y12 := TRUE;
            capper_turn := 1;
        ELSIF cap_b_req THEN
            Y13 := TRUE;
            capper_turn := 0;
        END_IF;
    ELSE
        IF cap_b_req THEN
            Y13 := TRUE;
            capper_turn := 0;
        ELSIF cap_a_req THEN
            Y12 := TRUE;
            capper_turn := 1;
        END_IF;
    END_IF;
END_IF;

(* ---------------------------------------------------------
   5. RELEASE TO EXIT ACCUMULATION
   Release only when capped and exit is clear.
   --------------------------------------------------------- *)
IF X1A AND X1B AND X1C THEN
    Y1A := TRUE;
ELSE
    Y1A := FALSE;
END_IF;

IF X28 AND X29 AND X2A THEN
    Y21 := TRUE;
ELSE
    Y21 := FALSE;
END_IF;

(* ---------------------------------------------------------
   6. COMPLETION MONITORING
   Condition: all 6 capped and taken over, pump/replenishment stopped,
   valves closed, nozzles at top, capping head stopped, no exchange.
   Maintain complete for at least 0.5s (500 ms).
   --------------------------------------------------------- *)
all_finished := X32 AND (D3 >= 6)
                AND NOT Y10 AND NOT Y11 AND NOT X30
                AND NOT Y18 AND NOT Y1F
                AND NOT Y17 AND NOT Y1E AND X17 AND X25
                AND NOT Y16 AND NOT Y1D AND X12 AND X20
                AND NOT X2C AND NOT Y12 AND NOT Y13
                AND NOT Y19 AND NOT Y20 AND NOT Y1A AND NOT Y21;

complete_timer(IN := all_finished, PT := T#500ms);

IF complete_timer.Q THEN
    Y22 := TRUE;
END_IF;

END_PROGRAM
```