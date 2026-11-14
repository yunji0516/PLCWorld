PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    X20 : BOOL;
    D20 : INT;
    (* Add internal variables here. *)
    start_edge : R_TRIG;
    withdrawal_timer : TON;
    buffer_check : BOOL := FALSE;
    external_done_edge : R_TRIG;
    scan_count : INT := 0;
    initial_inventory : INT := 0;
END_VAR

(* Implement the control logic here. *)

(* Initialize rising edge detection for Start and external_done signals *)
start_edge(CLK := X10);
external_done_edge(CLK := X20);

(* Operation starts on rising edge of Start request *)
IF start_edge.Q THEN
    initial_inventory := D20;  (* Store the initial buffer level *)
    withdrawal_timer(IN := TRUE, PT := T#4000ms);
    buffer_check := TRUE;
END_IF

(* While external withdrawal is active, ensure buffer stays within band *)
IF buffer_check THEN
    IF D20 < 200 THEN
        Y20 := TRUE;  (* Start supplying material if inventory is below minimum *)
    ELSIF D20 > 700 THEN
        Y20 := FALSE;  (* Stop supplying material if inventory is above maximum *)
    END_IF

    (* Ensure to stop unwinding as soon as external withdrawal ends *)
    IF external_done_edge.Q THEN
        Y20 := FALSE;
        buffer_check := FALSE;
        Y2 := TRUE;  (* Completion claim once external withdrawal ends and conditions met *)
    END_IF 

    (* Maintain stop condition and holding claims when timer and completion checks are fulfilled *)
    IF withdrawal_timer.Q AND external_done_edge.Q THEN
        Y20 := FALSE;
        buffer_check := FALSE;
        Y2 := TRUE;
    END_IF
END_IF

(* Check result holding requirement over remaining scans after completion claim *)
IF Y2 THEN
    scan_count := scan_count + 1;
    IF scan_count >= 1550 THEN
        Y2 := FALSE;  (* Reset completion claim after holding period checks *)
    END_IF
END_IF

END_PROGRAM