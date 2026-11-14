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
    D18 : DINT;
    D19 : DINT;
    D101 : DINT;
    D102 : DINT;
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
    D36 : DINT;
    D37 : DINT;
    Y24 : BOOL;
    Y2 : BOOL;
    (* Add internal variables here. *)
    state : INT := 0;
    position_tolerance : REAL := 0.2;
    speed_tolerance : REAL := 1.0;
    prepared_target_c : DINT;
    prepared_target_e : DINT;
    request_target : DINT;
    request_stroke : DINT;
    time_since_start : TIME := T#0ms;
    duration_reach_target : TIME := T#0ms;
    timer_completion : TON;
    completion_trigger : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)

(* Enable logic *)
IF X0 THEN
    CASE state OF
        0: (* Initialization state *)
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := FALSE;
            Y24 := FALSE;
            Y2 := FALSE;
            time_since_start := T#0ms;
            IF D10 = 0 AND D12 = 0 AND D14 = 0 AND D16 = 0 AND D18 = 0 THEN
                request_target := D101;
                request_stroke := D102;
                prepared_target_c := request_target;
                prepared_target_e := request_stroke;
                state := 1;
            END_IF;

        1: (* Move A and B plates out of the way. *)
            Y20 := TRUE;
            Y21 := TRUE;
            D20 := 100 * 100;   (* Open A to absolute maximum *)
            D24 := 100 * 100;   (* Open B to absolute maximum *)
            D21 := 1000;        (* Max rate *)
            D25 := 1000;        (* Max rate *)
            IF (REAL(ABS(D10 - D20)) <= position_tolerance * 100 AND
                REAL(ABS(D12 - D24)) <= position_tolerance * 100) THEN
                state := 2;
            END_IF;

        2: (* Move C to target *)
            Y22 := TRUE;
            D28 := prepared_target_c;
            D29 := 1000;        (* Max rate to quickly reach target *)
            IF REAL(ABS(D14 - D28)) <= position_tolerance * 100 THEN
                state := 3;
            END_IF;

        3: (* Dock D at position 70 and move E to stroke *)
            Y23 := TRUE;
            D32 := 70 * 100;
            D33 := 1000;        (* Max rate *)
            Y24 := TRUE;
            D36 := prepared_target_e;
            D37 := 1000;        (* Max rate *)
            IF (REAL(ABS(D16 - D32)) <= position_tolerance * 100 AND
                REAL(ABS(D18 - D36)) <= position_tolerance * 100) THEN
                state := 4;
            END_IF;

        4: (* Retract E to initial position *)
            D36 := 0;
            IF REAL(ABS(D18 - D36)) <= position_tolerance * 100 THEN
                state := 5;
            END_IF;

        5: (* Completion condition *)
            Y24 := FALSE;  (* Disable E axis *)
            Y23 := FALSE;  (* Undock D *)
            Y22 := FALSE;  (* Disable C axis *)
            D36 := 0;
            D32 := 0;
            
            Y20 := TRUE;
            Y21 := TRUE;
            D20 := 0;
            D24 := 0;

            IF (D10 = 0 AND D12 = 0 AND D14 = 0 AND
                D16 = 0 AND D18 = 0) THEN
                timer_completion(IN := TRUE, PT := T#100ms);
                IF timer_completion.Q THEN
                    Y2 := TRUE;
                END_IF;
            END_IF;
    END_CASE;
ELSE
    state := 0;
END_IF;

END_PROGRAM