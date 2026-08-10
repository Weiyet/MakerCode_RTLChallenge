# Switch debouncer

**Difficulty:** ⭐⭐⭐⭐ · **Topics:** counter + FSM, glitch rejection

## Background
A mechanical switch "bounces" — it makes and breaks contact many times over a few
milliseconds before settling. Feeding that straight into logic causes dozens of
false events. A **debouncer** only accepts a new level after the input has stayed
at that new level for `STABLE` consecutive clocks; any change restarts the count.
It is a counter guarding a single state bit.

## The task
Track `noisy`; update `clean` only after `STABLE` stable clocks. Async active-low
reset clears `clean`.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `clk`, `rst_n` | input | 1 | clock / reset |
| `noisy` | input  | 1 | raw (bouncy) input |
| `clean` | output | 1 | debounced output |

**Parameter:** `STABLE` (default 4)

## How to approach it
```systemverilog
always_ff @(posedge clk or negedge rst_n)
    if (!rst_n) begin clean <= 0; cnt <= '0; end
    else if (noisy != clean) begin
        if (cnt == STABLE-1) begin clean <= noisy; cnt <= '0; end
        else cnt <= cnt + 1'b1;
    end else cnt <= '0;      // input matches output -> reset the timer
```

## Common mistakes
- Not clearing the counter when the input matches the output — bounces would still
  accumulate over time.
- Off-by-one on the threshold (`STABLE` vs `STABLE-1`).

## SystemVerilog notes
Real debouncers use a `STABLE` sized for milliseconds at the real clock rate
(e.g. tens of thousands of cycles); a small value keeps this exercise fast.

## Run it
```bash
iverilog -g2012 -s tb -o sim 0030/tb.sv 0030/solution.sv && vvp sim
```
