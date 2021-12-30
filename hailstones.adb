with Ada.Text_IO;

procedure Hailstones
is

   type Number is mod 2 ** 64;

   Longest : Number := 0;
   Current : Number := 0;
begin
   for I in 1 .. 1000000 loop
      declare
         N : Number := Number (I);
      begin
         while N /= 1 loop
            if N mod 2 = 0 then
               N := N / 2;
            else
               N := (3 * N) + 1;
            end if;
            Current := Current + 1;
         end loop;
         if Current > Longest then
            Longest := Current;
         end if;
      end;
   end loop;

   Ada.Text_IO.Put_Line (Number'Image (Longest));
end Hailstones;

