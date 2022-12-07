{%RunFlags MESSAGES+}
program day5p2;


var
  fh: text;
  QUEUES: integer;
  MAXLEN: integer;
  line: string;
  boxes: array of array of char;
  lengths: array of integer;
  i: integer;
  j: integer;
  q: integer;


  procedure Move(n, from, dest: integer);
  var
    i: integer;
    f_ct: integer;
    d_ct: integer;
    f: integer;
    d: integer;
  begin
    f := from - 1;
    d := dest - 1;

     FOR i := 0 TO n-1 do
     begin
       f_ct := lengths[f] - n + i;
       d_ct := lengths[d] + i;
       boxes[d][d_ct] := boxes[f][f_ct];
       boxes[f][f_ct] := '_';
     end;
     lengths[f] := lengths[f] - n;
     lengths[d] := lengths[d] + n;
  end;

  Function IsNumber(c: char) : boolean;
  begin
       IsNumber := ('0' <= c) AND (c <= '9');
  end;

  Function CountNums(str: string; start: integer) : integer;
  var
    len: integer;
  begin
       len := 0;
       while ((start + len <= length(str)) AND IsNumber(str[start+len])) do
       begin
         len := len + 1;
       end;
       CountNums := len;
  end;

  function ss_to_i(str: string; start, length: integer) : integer;
  var
    i: integer;
  begin
       ss_to_i := 0;
       FOR i := start TO start+length-1 do
       begin
         ss_to_i := ss_to_i * 10 + (Ord(str[i]) - Ord('0'));
       end;
  end;

  procedure ParseAndMove(str: string);
  var
    n: integer;
    from: integer;
    dest: integer;
    i: integer;
    l: integer;
  begin
    i := 6;
    l := CountNums(str, i);
    n := ss_to_i(str, i, l);
    i := i + l + 6;
    l := CountNums(str, i);
    from := ss_to_i(str, i, l);
    i := i + l + 4;
    l := CountNums(str, i);
    dest := ss_to_i(str, i, l);

    Move(n,from,dest);
  end;

begin

  QUEUES := 9;
  MAXLEN := 8;

  SetLength(boxes, QUEUES, 99);   {if we allocate MAXLEN then it'll crash when
                                  something's moved to it}
  SetLength(lengths, QUEUES);
  FOR i := 0 TO QUEUES-1 do
  begin
    lengths[i] := 0;
    for j := 0 to 98 do
    begin
      boxes[i][j] := '_';
    end;
  end;

  AssignFile(fh, 'day5.txt');
  Reset(fh);

  for i := 1 to MAXLEN do
  begin
    q := 0;
    Readln(fh, line);
    for j := 0 to MAXLEN do
    begin
      q := j * 4 + 2;
      if (q < length(line)) then
        if (('A' <= line[q]) and (line[q] <= 'Z')) then
        begin
          boxes[j][MAXLEN-i] := line[q];
          if (0 = lengths[j]) then
             lengths[j] := MAXLEN-i+1;
        end;
    end;
  end;
  Readln(fh, line); {queue numbers, unused}
  Readln(fh, line); {empty}

  {Move instruction lines}
  while not Eof(fh) do
  begin
    Readln(fh, line);
    ParseAndMove(line);
  end;

  {example moves
  Move(1, 2, 1);
  Move(3, 1, 3);
  Move(2, 2, 1);
  Move(1, 1, 2);
  }

  {output last items}
  FOR i := 0 TO QUEUES-1 do
  begin
    Write(boxes[i][lengths[i]-1]);
  end;
end.

