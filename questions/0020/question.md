# Parameterizable Priority Arbiter

## Problem Statement

Priority arbiters are essential components in digital systems for managing access to shared resources. They resolve conflicts when multiple requesters simultaneously attempt to access a resource by granting access to only one requester based on a predefined priority scheme. This ensures fair and deterministic resource allocation while preventing conflicts.

Design a parameterizable priority arbiter that grants access to the highest priority requester when multiple requests are active simultaneously. The arbiter should implement a fixed priority scheme where lower-indexed ports have higher priority, and output a one-hot grant signal indicating which requester receives access.

### Module Interface

**Module Name**: `priority_arbiter`

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| `req_i` | Input | `[NUM_PORTS-1:0]` | Request signals from all requesters |
| `gnt_o` | Output | `[NUM_PORTS-1:0]` | One-hot grant signal |

**Parameters**:
| Parameter | Default Value | Description |
|-----------|---------------|-------------|
| `NUM_PORTS` | 4 | Number of requesters/ports |

### Functional Requirements

1. **Priority-Based Arbitration**: Lower-indexed ports have higher priority (port[0] > port[1] > port[2] > ...)
2. **One-Hot Grant**: Only one grant signal can be asserted at any time
3. **Immediate Response**: Combinational logic providing immediate grant based on current requests
4. **Parameterizable Width**: Support different numbers of ports through parameter
5. **No Grant When No Request**: When no requests are active, no grants should be asserted

### Example Operation

**Arbitration Behavior:**
- When multiple requests are active, grant to the lowest-indexed (highest priority) requester
- When only one request is active, grant to that requester
- When no requests are active, no grants are asserted

For NUM_PORTS = 4:

| req_i | gnt_o | Description |
|-------|-------|-------------|
| 0000 | 0000 | No requests, no grants |
| 0001 | 0001 | Only port 0 requests, grant to port 0 |
| 0010 | 0010 | Only port 1 requests, grant to port 1 |
| 0011 | 0001 | Ports 0&1 request, grant to port 0 (higher priority) |
| 0100 | 0100 | Only port 2 requests, grant to port 2 |
| 0101 | 0001 | Ports 0&2 request, grant to port 0 (higher priority) |
| 1000 | 1000 | Only port 3 requests, grant to port 3 |
| 1111 | 0001 | All ports request, grant to port 0 (highest priority) |

**Priority Order:**
- Port[0]: Highest Priority
- Port[1]: Second Priority
- Port[2]: Third Priority
- Port[3]: Lowest Priority

## Constraints
- `NUM_PORTS` should be at least 2 for meaningful arbitration
- Only one bit in `gnt_o` can be asserted at any time
- Lower port indices always have higher priority
- Grant signals must be purely combinational (no clock dependency)