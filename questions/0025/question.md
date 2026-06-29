# Parameterizable Synchronous FIFO

## Problem Statement

First-In-First-Out (FIFO) buffers are essential components in digital systems for managing data flow between producers and consumers operating at different rates. Synchronous FIFOs operate on a single clock domain and provide temporary storage with proper flow control to prevent overflow and underflow conditions.

Design a parameterizable synchronous FIFO that supports configurable depth and data width. The FIFO should implement proper push/pop operations with full and empty status flags, and maintain data integrity while providing optimal storage utilization.

### Module Interface

**Module Name**: `sync_fifo`

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| `clk` | Input | 1 | Clock signal |
| `reset` | Input | 1 | Asynchronous reset signal |
| `push_i` | Input | 1 | Push enable signal |
| `push_data_i` | Input | `[DATA_W-1:0]` | Data to push into FIFO |
| `pop_i` | Input | 1 | Pop enable signal |
| `pop_data_o` | Output | `[DATA_W-1:0]` | Data popped from FIFO |
| `full_o` | Output | 1 | FIFO full flag |
| `empty_o` | Output | 1 | FIFO empty flag |

**Parameters**:
| Parameter | Default Value | Description |
|-----------|---------------|-------------|
| `DEPTH` | 4 | Number of FIFO entries |
| `DATA_W` | 1 | Width of data in bits |

### Functional Requirements

1. **Push Operation**: Store data when push_i=1 and FIFO not full
2. **Pop Operation**: Retrieve data when pop_i=1 and FIFO not empty
3. **Status Flags**: Provide accurate full and empty indicators
4. **Overflow Protection**: Ignore push when full, maintain data integrity
5. **Underflow Protection**: Provide stable output when empty
6. **Simultaneous Operations**: Handle concurrent push and pop correctly

### Example Operation

**FIFO Push and Pop Sequence:**

```
Clock:      ___/‾‾‾\___/‾‾‾\___/‾‾‾\___/‾‾‾\___/‾‾‾\___
push_i:     ________/‾‾‾\___/‾‾‾\_______________
push_data_i: -------< A ><B >-----------------
pop_i:      ________________________/‾‾‾\___
pop_data_o: ________________________< A >___
full_o:     ______________________________
empty_o:    ‾‾‾‾\___________________/‾‾‾‾___
FIFO State: Empty  A    AB   A     Empty
```

**Detailed Operation:**
- Clock 1: Push A, empty_o goes low
- Clock 2: Push B, FIFO contains [A,B]
- Clock 3: No operation, FIFO remains [A,B]
- Clock 4: Pop A, FIFO contains [B], pop_data_o = A
- Clock 5: Pop B (if pop continues), FIFO empty

**Pointer Management:**
- Use read and write pointers to track FIFO head and tail
- Increment pointers on successful operations
- Compare pointers to determine full/empty status

## Constraints
- DEPTH must be a power of 2 for optimal pointer arithmetic
- Push when full should be ignored (no overflow)
- Pop when empty should maintain last valid data output
- Simultaneous push and pop when full should allow the operation