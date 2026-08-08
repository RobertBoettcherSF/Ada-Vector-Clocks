# Vector Clocks Algorithm

## Project Overview
This project provides a robust, strongly-typed Ada implementation of the **Vector Clocks** algorithm. Vector clocks are used in distributed systems to determine the partial ordering of events and detect causality violations. They overcome the limitations of Lamport timestamps by ensuring that if `Clock(A) < Clock(B)`, then event A definitively happened before event B.

## Features
This implementation includes all operational variants and partial ordering comparisons defined for the Vector Clocks algorithm:
*   **Initialization:** Zeroes out local vector state and enforces safe bounds on Process IDs.
*   **Internal Event:** Increments a process's local logical time.
*   **Send Message:** Triggers a local event increment and produces an outbound vector payload.
*   **Receive Message:** Absorbs an incoming message, synchronizes elements via `Max()`, and increments local time.
*   **Happens-Before (`<` and `<=`):** Determines definitive causal priority between two vectors.
*   **Concurrency (`||`):** Accurately identifies when two vectors experienced disjoint timelines without causal relationships.

## Testing (Verification & Validation)
A critical systems approach was taken using **pessimistic V&V testing**. The test suite fundamentally assumes the code is *incorrect/broken* and passes only when assertions definitively disprove this assumption.

**Test Categories:**
1.  **Functional Correctness (Tests 3, 4, 5, 13):** Proves that mathematical operations (max, increments) accurately target only the correct elements.
2.  **Partial Ordering Logic (Tests 6, 7, 8, 9, 10):** Validates the algorithm's capability to detect causality (`<`, `<=`) and concurrency (`||`) exactly as the literature defines.
3.  **Edge Cases & Error Handling (Tests 2, 11, 12):** Validates strict typing robustness by intentionally injecting invalid bounds and mismatched array sizes to guarantee the system safely traps errors via exceptions instead of suffering from out-of-bounds corruption.

These tests prove the module meets reliability and safety standards required by mission-critical Ada specifications.

## Usage
### Compilation
Ensure you have `gnatmake` (part of the GNAT Ada toolchain) installed.

To compile both the main executable and the test suite:
```bash
make all
