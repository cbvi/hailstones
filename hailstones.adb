with Ada.Text_IO;

procedure Hailstones
is
   type Number is mod 2 ** 64;

   Total_Tasks : constant Number := 12;
   Upper_Limit : constant Number := 1_000_000_000;

   function Count_Steps (Initial : Number) return Number;

   protected Calculated_Object is
      procedure Propose (Steps : Number; N : Number);
      procedure Finished;

      entry Get_Steps (V : out Number);
      entry Get_Best  (V : out Number);
   private
      Count : Number := 0;
      Best  : Number := 0;
      Busy  : Number := Total_Tasks;
   end Calculated_Object;

   protected body Calculated_Object is
      procedure Propose (Steps : Number; N : Number) is
      begin
         if Steps > Count then
            Count := Steps;
            Best  := N;
         end if;
      end Propose;

      procedure Finished is
      begin
         Busy := Busy - 1;
      end Finished;

      entry Get_Steps (V : out Number) when Busy = 0
      is
      begin
         V := Count;
      end Get_Steps;

      entry Get_Best (V : out Number) when Busy = 0
      is
      begin
         V := Best;
      end Get_Best;
   end Calculated_Object;

   task type Calculate_Task is
      entry Start (Initial : Number);
   end Calculate_Task;

   task body Calculate_Task is
      N       : Number;
      Current : Number := 0;
      Longest : Number := 0;
      Best    : Number;
   begin
      accept Start (Initial : Number) do
         N := Initial;
      end Start;
      loop
         exit when N >= Upper_Limit;
         Current := Count_Steps (N);
         if Current > Longest then
            Longest := Current;
            Best := N;
         end if;

         N := N + Total_Tasks;
      end loop;
      Calculated_Object.Propose (Longest, Best);
      Calculated_Object.Finished;
   end Calculate_Task;

   function Count_Steps (Initial : Number) return Number
   is
      Steps : Number := 0;
      N     : Number := Initial;
   begin
      while N /= 1 loop
         if N mod 2 = 0 then
            N := N / 2;
         else
            N := (3 * N) + 1;
         end if;
         Steps := Steps + 1;
      end loop;

      return Steps;
   end Count_Steps;

   Longest_Steps : Number;
   Best_Instigator : Number;
begin
   declare
      Tasks : array (1 .. Total_Tasks) of Calculate_Task;
   begin
      for I in Tasks'range loop
         Tasks (I).Start (I);
         Ada.Text_IO.Put_Line ("Started task");
      end loop;
   end;

   Calculated_Object.Get_Steps (Longest_Steps);
   Calculated_Object.Get_Best  (Best_Instigator);
   Ada.Text_IO.Put_Line (Number'Image (Longest_Steps));
   Ada.Text_IO.Put_Line (Number'Image (Best_Instigator));
end Hailstones;
