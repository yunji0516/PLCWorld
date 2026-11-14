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
    D20 : DINT;
    D21 : DINT;
    Y2 : BOOL;
    accepted : BOOL;
    done : BOOL;
    target_mm : REAL;
    x_mm : REAL;
    vx_mm_s : REAL;
    z_mm : REAL;
    vz_mm_s : REAL;
    heading_deg : REAL;
    heading_rate_deg_s : REAL;
    ex : REAL;
    absEx : REAL;
    signEx : REAL;
    vStop : REAL;
    vRef : REAL;
    baseCmd : REAL;
    dirMotion : REAL;
    headingRef : REAL;
    headingErr : REAL;
    yawRateCmd : REAL;
    yawInt : REAL;
    turnCmd : REAL;
    leftCmd : REAL;
    rightCmd : REAL;
    completeCond : BOOL;
    stableTimer : TON;
END_VAR

x_mm := REAL(D11) / 100.0;
vx_mm_s := REAL(D12) / 100.0;
z_mm := REAL(D13) / 100.0;
vz_mm_s := REAL(D14) / 100.0;
heading_deg := REAL(D15) / 100.0;
heading_rate_deg_s := REAL(D16) / 100.0;

IF X10 AND NOT accepted THEN
    accepted := TRUE;
    target_mm := REAL(D10) / 100.0;
END_IF;

ex := target_mm - x_mm;
absEx := ABS(ex);

completeCond := FALSE;
IF accepted THEN
    IF (ABS(ex) <= 0.90) AND (ABS(z_mm) <= 1.80) AND (ABS(heading_deg) <= 0.25) AND (ABS(vx_mm_s) <= 1.50) AND (ABS(heading_rate_deg_s) <= 0.80) THEN
        completeCond := TRUE;
    END_IF;
END_IF;

stableTimer(IN := completeCond AND accepted AND NOT done, PT := T#30ms);

IF stableTimer.Q THEN
    done := TRUE;
END_IF;

Y2 := done;

IF NOT accepted THEN
    D20 := 0;
    D21 := 0;
    yawInt := 0.0;
ELSE
    IF done OR completeCond THEN
        D20 := 0;
        D21 := 0;
        yawInt := yawInt * 0.50;
    ELSE
        IF ex >= 0.0 THEN
            signEx := 1.0;
        ELSE
            signEx := -1.0;
        END_IF;

        IF absEx > 12.0 THEN
            vStop := SQRT(3600.0 * absEx);
            IF vStop > 900.0 THEN
                vStop := 900.0;
            END_IF;
            vRef := signEx * vStop;
            baseCmd := vRef + 1.20 * (vRef - vx_mm_s);
            IF baseCmd > 1500.0 THEN
                baseCmd := 1500.0;
            END_IF;
            IF baseCmd < -1500.0 THEN
                baseCmd := -1500.0;
            END_IF;
        ELSE
            baseCmd := 4.0 * ex - 4.0 * vx_mm_s;
            IF baseCmd > 140.0 THEN
                baseCmd := 140.0;
            END_IF;
            IF baseCmd < -140.0 THEN
                baseCmd := -140.0;
            END_IF;
        END_IF;

        IF baseCmd >= 0.0 THEN
            dirMotion := 1.0;
        ELSE
            dirMotion := -1.0;
        END_IF;

        headingRef := -dirMotion * ((0.24 * z_mm) + (0.035 * vz_mm_s));
        IF headingRef > 12.0 THEN
            headingRef := 12.0;
        END_IF;
        IF headingRef < -12.0 THEN
            headingRef := -12.0;
        END_IF;

        headingErr := headingRef - heading_deg;

        IF ABS(baseCmd) > 50.0 THEN
            yawInt := yawInt + 0.05 * headingErr;
            IF yawInt > 25.0 THEN
                yawInt := 25.0;
            END_IF;
            IF yawInt < -25.0 THEN
                yawInt := -25.0;
            END_IF;
        ELSE
            yawInt := yawInt * 0.80;
        END_IF;

        yawRateCmd := (7.0 * headingErr) - (1.5 * heading_rate_deg_s) + yawInt;
        IF yawRateCmd > 120.0 THEN
            yawRateCmd := 120.0;
        END_IF;
        IF yawRateCmd < -120.0 THEN
            yawRateCmd := -120.0;
        END_IF;

        turnCmd := yawRateCmd * 5.23599;

        leftCmd := baseCmd - turnCmd;
        rightCmd := baseCmd + turnCmd;

        IF leftCmd > 1900.0 THEN
            leftCmd := 1900.0;
        END_IF;
        IF leftCmd < -1900.0 THEN
            leftCmd := -1900.0;
        END_IF;
        IF rightCmd > 1900.0 THEN
            rightCmd := 1900.0;
        END_IF;
        IF rightCmd < -1900.0 THEN
            rightCmd := -1900.0;
        END_IF;

        D20 := DINT(leftCmd * 100.0);
        D21 := DINT(rightCmd * 100.0);
    END_IF;
END_IF;

END_PROGRAM