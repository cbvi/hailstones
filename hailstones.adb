with Ada.Text_IO;

procedure Hailstones
is
   N : Natural := 100000;
begin
   loop
      Ada.Text_IO.Put_Line (Natural'Image (N));
      exit when N = 1;
      if N mod 2 = 0 then
         N := N / 2;
      else
         N := (3 * N) + 1;
      end if;
   end loop;
end Hailstones;

