with Ada.Text_IO;    use Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.Command_Line;
with Ada.Containers; use Ada.Containers;
with Ada.Containers.Ordered_Sets;

procedure Day9 is
   package SU renames Ada.Strings.Unbounded;

   type Pos is record
      x : Integer;
      y : Integer;
   end record;

   function "<" (Left, Right : Pos) return Boolean is
   begin
      if (Left.x = Right.x) then
         return Left.y < Right.y;
      else
         return Left.x < Right.x;
      end if;
   end "<";

   package PosSet is new Ada.Containers.Ordered_Sets (Element_Type => Pos);
   use PosSet;

   type PosArray is array (Positive range <>) of Pos;

   procedure Move_Head (instruction : Character; H : in out Pos) is
   begin
      case instruction is
         when 'L' =>
            H.x := H.x - 1;
         when 'U' =>
            H.y := H.y + 1;
         when 'R' =>
            H.x := H.x + 1;
         when 'D' =>
            H.y := H.y - 1;
         when others =>
            null;
      end case;
   end Move_Head;

   procedure Tail_Follow (H : Pos; T : in out Pos) is
      diff : Pos;
   begin
      diff.x := H.x - T.x;
      diff.y := H.y - T.y;
      Put_Line ("Diff: (" & diff.x'Image & ", " & diff.y'Image & ")");
      if abs (diff.x) > 1 or else abs (diff.y) > 1 then

         if diff.x = 0 then
            T.y := T.y + diff.y / abs (diff.y);
         elsif diff.y = 0 then
            T.x := T.x + diff.x / abs (diff.x);
         else
            T.y := T.y + diff.y / abs (diff.y);
            T.x := T.x + diff.x / abs (diff.x);
         end if;

      end if;
   end Tail_Follow;

   procedure Follow_Instruction
     (instruction :        Character; count : Integer; H : in out Pos;
      T           : in out PosArray; TailPosns : in out PosSet.Set)
   is
      tmp : Pos;
   begin
      for i in 1 .. count loop
         Put_Line
           (instruction'Image & ", H: " & "(" & H.x'Image & ", " & H.y'Image &
            "), T:(" & T (9).x'Image & ", " & T (9).y'Image & ")");
         Move_Head (instruction, H);
         Put_Line ("new H: " & "(" & H.x'Image & ", " & H.y'Image & ")");
         --tmp := T (1); -- This can't be necessary?
         Tail_Follow (H, T (1));
         --T (1) := tmp;
         for n in 2 .. 9 loop
            Tail_Follow (T (n - 1), T (n));
         end loop;
         Put_Line ("new T9:(" & T (9).x'Image & ", " & T (9).y'Image & ")");
         if not TailPosns.Contains (T (9)) then
            TailPosns.Insert (T (9));
         end if;
      end loop;
   end Follow_Instruction;

   file        : File_Type;
   in_line     : SU.Unbounded_String;
   instruction : Character;
   count       : Integer;
   H           : Pos;
   T           : PosArray (1 .. 9);
   TailPosns   : PosSet.Set;
begin
   if Ada.Command_Line.Argument_Count < 1 then
      Put_Line ("File name required!");
      return;
   end if;
   Put_Line (Ada.Command_Line.Argument (1));

   H.x := 0;
   H.y := 0;
   for n in 1 .. 9 loop
      T (n) := H;
   end loop;

   Open (file, In_File, Ada.Command_Line.Argument (1));
   while not End_Of_File (file) loop
      in_line := SU.To_Unbounded_String (Get_Line (file));

      instruction := SU.Element (in_line, 1);
      count := Integer'Value (SU.Slice (in_line, 3, SU.Length (in_line)));

      Follow_Instruction (instruction, count, H, T, TailPosns);
   end loop;

   for E of TailPosns loop
      Put_Line ("(" & E.x'Image & ", " & E.y'Image & ")");
   end loop;

   Put_Line ("Tail positions: " & Count_Type'Image (TailPosns.Length));

end Day9;
