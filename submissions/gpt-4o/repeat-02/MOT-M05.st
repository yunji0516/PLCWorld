PROGRAM Main
VAR
    X10 : BOOL;
    D11 : DINT;
    D12 : DINT;
    D10 : DINT;
    D13 : DINT;
    D14 : DINT;
    D17 : DINT;
    X11 : BOOL;
    D20 : DINT;
    D21 : DINT;
    D22 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y2 : BOOL;
    (* Add internal variables here. *)
    currentMoment : REAL;
    requestedAngle : REAL;
    requestedPosition : REAL;
    brakeTimer : TON;
    requestActive : BOOL;
END_VAR

(* Implement the control logic here. *)

(* Initial conditions and computations *)
requestedAngle := D10 / 100.0;
requestedPosition := -450.0 * SIN(REAL(requestedAngle));
currentMoment := 30.0 * 9.81 * 0.3 * SIN(REAL(D11 / 100.0)) + 20.0 * 9.81 * REAL(D13) / 1000.0;

(* Remember request *)
IF X10 THEN
    requestActive := TRUE;
END_IF

(* Control Head and Counterweight *)
IF requestActive THEN
    (* Maintain balance by sending counterweight to target position *)
    D21 := DINT(requestedPosition * 100.0);

    (* Check current moment to ensure it's within safe range *)
    IF ABS(currentMoment) <= 25.0 THEN
        (* Move head to the requested angle *)
        D20 := D10;
        Y20 := TRUE; (* Enable head torque *)

        (* Wait until head reaches requested position within tolerances *)
        IF ABS(D11 - D10) <= 20 AND ABS(D12) <= 1 THEN
            Y20 := FALSE; (* Disable head torque *)

            (* Engage brake after head stops *)
            IF X11 = FALSE THEN
                Y22 := TRUE;

                (* Start brake engagement timer *)
                brakeTimer(IN := TRUE, PT := T#80ms);
            END_IF

            (* Wait until brake is fully engaged *)
            IF brakeTimer.Q THEN
                Y22 := FALSE; (* Disable brake engagement command *)
                Y20 := FALSE; (* Ensure head torque is released *)

                (* Validate final position and speed *)
                IF ABS(D11 - D10) <= 20 AND 
                   ABS(D13 - D17) <= 20 AND 
                   ABS(D12) <= 1 AND 
                   ABS(D14) <= 1 AND 
                   ABS(currentMoment) <= 1.0 THEN

                    (* Maintain result retention *)
                    Y2 := TRUE;
                ELSE
                    Y2 := FALSE;
                END_IF
            END_IF
        END_IF
    ELSE
        (* If |M| > 25, we have a safety constraint issue *)
        (* Handle emergency stop or other safety action here *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y22 := FALSE;
        Y2 := FALSE;
    END_IF
END_IF

END_PROGRAM