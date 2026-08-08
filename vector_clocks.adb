-- vector_clocks.adb
-- Implementation for the Vector Clocks algorithm variants and helpers.
package body Vector_Clocks is

   procedure Setup (P : in out Process_Node; ID : Positive) is
   begin
      if ID > P.Num_Processes then
         raise Invalid_Process_ID with "Process ID exceeds total system processes.";
      end if;
      P.ID := ID;
      P.Clock := (others => 0);
   end Setup;

   procedure Internal_Event (P : in out Process_Node) is
   begin
      -- Increment the clock belonging strictly to this process's ID
      P.Clock (P.ID) := P.Clock (P.ID) + 1;
   end Internal_Event;

   function Send_Message (P : in out Process_Node) return Vector_Clock is
   begin
      -- A send event is fundamentally an internal event that yields the clock state
      Internal_Event (P);
      return P.Clock;
   end Send_Message;

   procedure Receive_Message (P : in out Process_Node; Msg_Clock : Vector_Clock) is
   begin
      if P.Clock'Length /= Msg_Clock'Length then
         raise Mismatched_Dimensions with "Cannot merge vector clocks of different sizes.";
      end if;

      -- First: Update each element by taking the maximum of local and received values
      for I in P.Clock'Range loop
         P.Clock (I) := Natural'Max (P.Clock (I), Msg_Clock (I));
      end loop;

      -- Second: Increment its own logical clock as the act of receiving is an event itself
      P.Clock (P.ID) := P.Clock (P.ID) + 1;
   end Receive_Message;

   function "<=" (Left, Right : Vector_Clock) return Boolean is
   begin
      if Left'Length /= Right'Length then
         raise Mismatched_Dimensions with "Comparison requires identical clock sizes.";
      end if;
      for I in Left'Range loop
         if Left (I) > Right (I) then
            return False;
         end if;
      end loop;
      return True;
   end "<=";

   function "<" (Left, Right : Vector_Clock) return Boolean is
   begin
      if Left'Length /= Right'Length then
         raise Mismatched_Dimensions;
      end if;
      -- A strict happen-before relation
      return (Left <= Right) and then (Left /= Right);
   end "<";

   function Are_Concurrent (Left, Right : Vector_Clock) return Boolean is
   begin
      if Left'Length /= Right'Length then
         raise Mismatched_Dimensions;
      end if;
      -- Concurrent if there is no causal relationship (neither is <= the other)
      return not (Left <= Right) and then not (Right <= Left);
   end Are_Concurrent;

end Vector_Clocks;
