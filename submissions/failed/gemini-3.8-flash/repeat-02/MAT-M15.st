clear→A→A+B→B→clear *)
            pe_state := 0;
            net_count := net_count + 1;
        ELSIF X20 AND X21 THEN
            (* Retreated back into both *)
            pe_state := 2;
        END_IF;

    4: (* REV B only: A=0, B=1 *)
        IF X20 AND X21 THEN
            pe_state := 5; (* REV covering both *)
        ELSIF NOT X20 AND NOT X21 THEN
            pe_state := 0;
        END_IF;

    5: (* REV both: A=1, B=1 *)
        IF X20 AND NOT X21 THEN
            pe_state := 6; (* REV exit B, A only *)
        ELSIF NOT X20 AND X21 THEN
            pe_state := 4;
        END_IF;

    6: (* REV A only: A=1, B=0 *)
        IF NOT X20 AND NOT X21 THEN
            (* Reverse passage complete: clear→B→B+A→A→clear *)
            pe_state := 0;
            net_count := net_count - 1;
        ELSIF X20 AND X21 THEN
            pe_state := 5;
        END_IF;
ELSE
    pe_state := 0;
END_CASE;
```

Wait! Look at state 1:
`ELSIF NOT X20 AND NOT X21 THEN`
`pe_state := 0;`
`IF X22 THEN reversing := TRUE; END_IF;`
Wait, what if it was in state 2, and retreated to 1, then to 0?
In state 2: retreated to 1: `pe_state := 1;`
Then from 1 to 0: `pe_state := 0; IF X22 THEN reversing := TRUE; END_IF;`
It also sets `reversing := TRUE`!
Now, what clears `reversing`?
```pascal
IF NOT X22 THEN
    reversing := FALSE;
END_IF;
```
When the disturbance finishes at x <= -220 mm, X22 becomes FALSE!
So `reversing` becomes FALSE!

Wait! What if X22 was TRUE from scan 0, but no disturbance has started yet?
`reversing` starts as FALSE.
`IF NOT X22 THEN reversing := FALSE; END_IF;` does not touch it if X22 is TRUE.
So `reversing` remains FALSE until one of the disturbance triggers sets it to TRUE!
And once the disturbance finishes, X22 becomes FALSE, which resets `reversing` to FALSE!
What if there is no disturbance? X22 is FALSE from scan 0, so `reversing` stays FALSE forever!

Now let's check:
What if `net_count` goes below 0?
Can `net_count` go below 0?
In our logic, a reverse passage only happens after a forward passage (net_count was 1, becomes 1 - 1 = 0).
So `net_count` never goes below 0. But just in case, `IF net_count < 0 THEN net_count := 0; END_IF;` is harmless.

Now let's examine the main sequence:
What are the operating states of our controller?
Let's define:
```pascal
VAR
    (* ... interface vars ... *)
    step : INT := 0;
    target_count : INT := 0;
    net_count : INT := 0;
    pe_state : INT := 0;
    reversing : BOOL := FALSE;
    start_latched : BOOL := FALSE;
    r_trig_start : R_TRIG;
    ton_settle : TON;
END_VAR
```

Let's trace `step`:
Step 0: IDLE
- Y20 := FALSE;
- Y21 := FALSE;
- Y2 := FALSE;
- Wait for start request.
  `r_trig_start(CLK := X10);`
  `IF r_trig_start.Q THEN`
      `start_latched := TRUE;`
      `target_count := D10;`
      `step := 10; (* FEEDING *)`
  `END_IF;`

Step 10: FEEDING
In Step 10:
Can we dispatch? No.
Actuator outputs:
`Y21 := FALSE;` // dispatch OFF
`Y2 := FALSE;` // completion claim FALSE

What about feed (Y20)?
`IF reversing THEN`
    `Y20 := FALSE;`
`ELSIF net_count < target_count THEN`
    `Y20 := TRUE;`
`ELSE`
    `Y20 := FALSE;`
`END_IF;`

Wait! Look at:
`ELSIF net_count < target_count THEN`
`Y20 := TRUE;`
Wait, what if `net_count < target_count`, but product has cleared B and X22 is FALSE?
Does Y20 stay TRUE?
Yes! Feed stays TRUE to feed the next product!
Wait! What if `net_count == target_count`?
Then `net_count < target_count` is FALSE, so `Y20 := FALSE`!
Feed turns OFF!
AND we transition to Step 20 (SETTLING)!
`IF (net_count >= target_count) AND NOT reversing AND NOT X22 THEN`
    `step := 20;`
