# Finite state machine (valid/ready handshake)

**Difficulty:** ⭐⭐⭐⭐ · **Topics:** ready/valid interface, backpressure

## Background
The **valid/ready handshake** is the universal way blocks pass data. The producer
asserts `valid` when it has data on `data`; the consumer asserts `ready` when it
can accept. A **transfer happens only on a cycle where `valid && ready`** — that
is the one rule. `ready` low is *backpressure*: the producer must **hold** its
data until accepted, never dropping or duplicating a beat.

## The task
Build `seq_src`: after reset it streams the sequence 0, 1, 2, 3, … one value per
accepted beat. Keep `valid` asserted, present the current count on `data`, and
advance to the next value **only when `valid && ready`**.

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `clk`, `rst_n` | input | 1 | clock, active-low reset |
| `ready` | input  | 1 | consumer can accept |
| `valid` | output | 1 | producer has data (always 1 here) |
| `data`  | output | 8 | current value |

## How to approach it
```systemverilog
assign valid = 1'b1;
always_ff @(posedge clk or negedge rst_n)
    if (!rst_n)            data <= 8'd0;
    else if (valid && ready) data <= data + 8'd1;   // advance only on a transfer
```

## Common mistakes
- Advancing on `ready` alone (or every cycle) — you drop/duplicate beats when
  `ready` toggles. Advance only when **both** `valid` and `ready` are high.
