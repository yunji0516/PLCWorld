PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y2 : BOOL;

    (* Internal variables *)
    edge_req    : R_TRIG;
    requested   : BOOL := FALSE;
    extend_cmd  : BOOL := FALSE;
    completed   : BOOL := FALSE;

    pos_err     : DINT := 0;
    spd_err     : DINT := 0;
    align_ok    : BOOL := FALSE;
    result_ok   : BOOL := FALSE;

    pos_tol     : DINT := 20;   (* 0.20 mm * 100 *)
    spd_tol     : DINT := 100;  (* 1 mm/s * 100 *)

    stab_timer  : TON;
END_VAR

(* Latch the request - the request pulse may only be present briefly (retained at scan 5) *)
edge_req(CLK := X10);
IF edge_req.Q THEN
    requested := TRUE;
END_IF;

(* Compute relative alignment between S (actual) and U (actual) *)
pos_err := D13 - D11;
spd_err := D14 - D12;

align_ok := (ABS(pos_err) <= pos_tol) AND (ABS(spd_err) <= spd_tol);

(* Movement reference following: keep active once requested, and continue
   even after fork insertion since carrier and fork must move together *)
Y20 := requested;

IF requested THEN
    (* Position+velocity feedforward: track the moving reference U directly *)
    D20 := D13;
    D21 := D14;
ELSE
    D20 := 0;
    D21 := 0;
END_IF;

(* Extend fork only once aligned; once commanded, retain (hold) the insertion command *)
IF requested AND align_ok THEN
    extend_cmd := TRUE;
END_IF;

Y21 := extend_cmd;

(* Actual physical result: fork physically at insertion endpoint and alignment
   still maintained (moving together with fork inserted) *)
result_ok := extend_cmd AND X11 AND align_ok;

(* Require the actual result to be continuously true for the completion
   observation window before declaring completion *)
stab_timer(IN := result_ok, PT := T#100ms);

IF stab_timer.Q THEN
    completed := TRUE;
END_IF;

(* Completion output is retained once claimed *)
Y2 := completed;

END_PROGRAM