# Finite state machine (edge detector)

**Difficulty:** ⭐⭐⭐ · **Topics:** registering history, one-cycle pulse

## Background
To react to a *change* in a signal (a button press, a flag going high) you compare
its current value with its value one clock ago. Store the previous value in a
flip-flop, then a rising edge is "now 1 AND was 0" and a falling edge is "now 0
AND was 1". The result is a clean **one-cycle pulse** per edge — the standard way
to turn a level into an event.

## The task
Register `sig` into `prev`; output registered `rise` and `fall` pulses. Async
active-low reset.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `clk`, `rst_n` | input | 1 | clock / reset |
| `sig`  | input  | 1 | monitored signal |
| `rise` | output | 1 | rising-edge pulse |
| `fall` | output | 1 | falling-edge pulse |

```wavedrom
{ "signal": [
  {"name":"clk","wave":"p......"},
  {"name":"sig","wave":"0.1..0."},
  {"name":"rise","wave":"0..10.."},
  {"name":"fall","wave":"0....10"}
]}
```

## How to approach it
```systemverilog
always_ff @(posedge clk or negedge rst_n)
    if (!rst_n) begin prev <= 0; rise <= 0; fall <= 0; end
    else begin
        prev <= sig;
        rise <=  sig & ~prev;
        fall <= ~sig &  prev;
    end
```

## Common mistakes
- Comparing `sig` against itself (forgetting the registered `prev`).
- A wider pulse than one cycle — that means `prev` is not updating each clock.

## SystemVerilog notes
Registering the outputs (as here) gives a glitch-free one-cycle pulse. A purely
combinational `rise = sig & ~prev` also works but can glitch as `sig` changes
between edges.
