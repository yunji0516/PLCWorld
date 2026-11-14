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
    Y22 : BOOL;
    Y2 : BOOL;
    (* Internal variables *)
    sync_started : BOOL := FALSE;
    gear_in_edge : BOOL := FALSE;
    gear_out_edge : BOOL := FALSE;
    origin_u : DINT := 0;
    origin_s : DINT := 0;
    span_complete : BOOL := FALSE;
    timer : TON;
END_VAR

(* Rising edge detection for gear_in *)
gear_in_edge := X12 AND NOT gear_in_edge;

(* Rising edge detection for gear_out *)
gear_out_edge := NOT X12 AND gear_out_edge;

(* Handle Gear In operation *)
IF gear_in_edge THEN
    IF D15 >= 500 AND D15 <= 2500 THEN
        D20 := D15; (* Set gear ratio command *)
        origin_u := D10;
        origin_s := D11;
        Y20 := TRUE; (* Signal Gear coupling *)
        sync_started := TRUE;
    END_IF;
ELSIF sync_started THEN
    IF X12 THEN
        Y20 := FALSE;
    END_IF;
    IF X11 THEN
        (* Synchronization confirmed, monitoring phase and speed errors *)
        IF ABS(D11 - origin_s - (D10 - origin_u) * DINT(D20) / 1000) <= 40 AND
           ABS(D12 - D16 * DINT(D20) / 1000) <= 200 THEN
            IF (D10 - origin_u) >= D14 THEN
                span_complete := TRUE;
            END_IF;
        ELSE
            (* Violation of errors, reset synchronization *)
            sync_started := FALSE;
            Y21 := TRUE; (* Signal Gear separation *)
        END_IF;
    END_IF;
ENDIF;

(* Handle Gear Out operation *)
IF gear_out_edge THEN
    Y21 := TRUE;
    sync_started := FALSE;
END_IF;

(* Independent positioning after separation and Completion check *)
IF NOT sync_started AND span_complete THEN
    D21 := D13 MOD 360000; (* Set Park target *)
    Y22 := TRUE; (* Start independent position operation *)
    IF ABS(D11 - D21) <= 20 AND ABS(D12) <= 100 THEN
        Y2 := TRUE;
        (* Start a timer to retain Y2 for an additional 30 ms after result *)
        timer(IN := TRUE, PT := T#30ms);
    ELSE
        Y2 := FALSE;
    END_IF;
END_IF;

IF timer.Q THEN
    Y2 := FALSE; (* Reset completion retention signal after retention period *)
    timer(IN := FALSE, PT := T#30ms);
END_IF;

END_PROGRAM