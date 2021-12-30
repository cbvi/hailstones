with Ada.Text_IO;

procedure Hailstones
is
   type Number is mod 2 ** 64;

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

   Longest : Number := 0;
   Current : Number := 0;
   Best    : Number;
begin
   for I in 1 .. 100000 loop
      Current := Count_Steps (Number (I));
      if Current > Longest then
         Longest := Current;
         Best := Number (I);
      end if;
   end loop;

   Ada.Text_IO.Put_Line (Number'Image (Best));
end Hailstones;

