# Procedural programming (fork family: join / join_any / join_none)

**Difficulty:** ⭐⭐⭐ · **Topics:** `fork`/`join`, concurrency, simulation time

> ⚠️ **Simulation only — not synthesizable.** `fork`/`join` spawn concurrent
> processes; you use them in **testbenches / verification**, never inside a
> synthesizable design. This problem teaches the construct in a self-checking way.

## Background
Statements in a `begin ... end` run **one after another**. Inside a
`fork ... join` the branches run **concurrently** — all start at the same time —
and `join` waits until **every** branch has finished before continuing.

So three branches that each wait 10, 20, and 30 ns finish after **30 ns total**
(the longest), not 60 ns (the sum).

```
fork
  begin ... end   // branch 1
  begin ... end   // branch 2
join                // continue after BOTH branches finish
```

## The task
Build `parallel_join`. When `start` rises, launch **three parallel branches**:
after 10 ns set `flag[0]`, after 20 ns set `flag[1]`, after 30 ns set `flag[2]`.
When all three have completed, set `done = 1`. Because they run in parallel,
`flag[1]` must be set at **+20 ns** (not +30) and `done` at **+30 ns** (not +60).

## Interface
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| `start` | input  | 1 | rising edge launches the branches |
| `flag`  | output | 3 | `flag[k]` set by branch k |
| `done`  | output | 1 | high once all branches finished |

## How to approach it
```systemverilog
initial begin
    flag = '0; done = 0;
    @(posedge start);
    fork
        begin #10 flag[0] = 1; end
        begin #20 flag[1] = 1; end
        begin #30 flag[2] = 1; end
    join
    done = 1;
end
```

## The three join modes
`fork` has three terminators — same branches, different "when do we continue":

| Terminator | Continues when… | Typical use |
|------------|-----------------|-------------|
| `join`      | **all** branches finish (here: +30 ns) | wait for everything |
| `join_any`  | the **first** branch finishes (here: +10 ns); the rest run on | build a **timeout** (race real event vs `#TIMEOUT`) |
| `join_none` | **immediately** — none are waited for; all run in background | launch background **monitors/drivers**, keep going |

This problem checks `join`; keep the other two in mind — they are one keyword away.

## Common mistakes
- Writing the branches sequentially (no `fork`) — then `flag[1]` lands at +30 and
  `done` at +60, and the test fails.
- Using `join_any`/`join_none` here — those do not wait for *all* branches, so
  `done` would assert too early.
