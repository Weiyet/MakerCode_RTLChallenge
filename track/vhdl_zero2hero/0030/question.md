# Finite state machine (valid/ready handshake)

**Difficulty:** ⭐⭐⭐⭐ · **Topics:** ready/valid interface, backpressure

## Background
The **valid/ready handshake** is the universal way blocks pass data. The producer
asserts `valid` when it has data on `data`; the consumer asserts `ready` when it
can accept. A **transfer happens only when `valid = '1' and ready = '1'`**. `ready`
low is *backpressure*: the producer must **hold** its data until accepted — never
dropping or duplicating a beat.

## The task
Build `seq_src`: after reset it streams 0, 1, 2, 3, … one value per accepted beat.
Hold `valid` high, present the current count on `data`, and advance **only when
`valid and ready`**.

## Interface
| Port | Dir | Type | Description |
|------|-----|------|-------------|
| `clk`, `rst_n` | in | std_logic | clock, active-low reset |
| `ready` | in  | std_logic | consumer can accept |
| `valid` | out | std_logic | producer has data (always '1') |
| `data`  | out | std_logic_vector(7:0) | current value |

## How to approach it
```vhdl
valid <= '1';
process(clk, rst_n) begin
  if rst_n = '0' then
    cnt <= (others => '0');
  elsif rising_edge(clk) then
    if ready = '1' then cnt <= cnt + 1; end if;   -- valid is always '1'
  end if;
end process;
data <= std_logic_vector(cnt);
```

## Common mistakes
- Advancing every cycle (ignoring `ready`) — you drop beats under backpressure.
  Advance only when **both** `valid` and `ready` are asserted.
