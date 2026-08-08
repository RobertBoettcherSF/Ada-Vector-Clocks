-- vector_clocks.ads
-- Specification for the Vector Clocks algorithm in a distributed system.
package Vector_Clocks is

   -- A logical vector clock representing the state of events.
   type Vector_Clock is array (Positive range <>) of Natural;

   -- Node representing a single process in the distributed system.
   -- Uses discriminant to define the fixed size of the vector clock dynamically at runtime.
   type Process_Node (Num_Processes : Positive) is record
      ID    : Positive := 1;
      Clock : Vector_Clock (1 .. Num_Processes) := (others => 0);
   end record;

   -- Custom Exceptions for invalid configurations or states
   Mismatched_Dimensions : exception;
   Invalid_Process_ID    : exception;

   -- =========================================================================
   -- Core Algorithm Variants / Operations
   -- =========================================================================

   -- 1. Setup/Initialization: Zeros out the clock and assigns a valid ID
   procedure Setup (P : in out Process_Node; ID : Positive);

   -- 2. Internal Event: Process experiences an internal event and increments its own clock
   procedure Internal_Event (P : in out Process_Node);

   -- 3. Send Message: Process increments its clock and returns a copy to append to the payload
   function Send_Message (P : in out Process_Node) return Vector_Clock;

   -- 4. Receive Message: Process takes max of its vector and msg vector, then increments its own clock
   procedure Receive_Message (P : in out Process_Node; Msg_Clock : Vector_Clock);

   -- =========================================================================
   -- Helper Functions: Partial Ordering
   -- =========================================================================

   -- Less-than or equal (<=): True if all elements of Left are <= corresponding elements of Right
   function "<=" (Left, Right : Vector_Clock) return Boolean;

   -- Happens-before (<): True if Left <= Right AND Left != Right
   function "<" (Left, Right : Vector_Clock) return Boolean;

   -- Concurrent (||): True if neither happens before the other
   function Are_Concurrent (Left, Right : Vector_Clock) return Boolean;

end Vector_Clocks;
