Public Class Day7Frm

    Private Function TraverseNodeSizes(ByRef node As TreeNode, ByVal limit As Integer, ByRef list As List(Of KeyValuePair(Of Integer, String))) As Integer
        Dim rv As Integer = 0
        For Each n As TreeNode In node.Nodes
            If n.Tag = 0 Then
                rv += TraverseNodeSizes(n, limit, list)
            Else
                rv += n.Tag
            End If
        Next
        If limit = 0 Or rv <= limit Then
            list.Add(New KeyValuePair(Of Integer, String)(rv, node.Text))
        End If
        Return rv
    End Function

    Private Sub ParseLine(ByVal line As String)
        Static CurNode As TreeNode = Nothing

        Dim tokens = line.Split()

        Select Case tokens(0)
            Case "$"
                'Commands
                Select Case tokens(1)
                    Case "cd"
                        If "/" = tokens(2) Then
                            'root directory
                            DirectoryTV.Nodes.Clear()
                            CurNode = DirectoryTV.Nodes.Add("/", "/")
                            CurNode.Tag = 0
                        ElseIf ".." = tokens(2) Then
                            CurNode = CurNode.Parent
                        Else
                            CurNode = CurNode.Nodes.Find(tokens(2), False)(0)
                        End If
                    Case "ls"
                        'List, don't care
                End Select
            Case "dir"
                'New directory, tokens(1) -> name
                Dim tmpNode = CurNode.Nodes.Add(tokens(1), tokens(1))
                tmpNode.Tag = 0
            Case Else
                'New file, tokens(0) -> size, tokens(1) -> name
                Dim tmpNode = CurNode.Nodes.Add(tokens(1), tokens(1) + " (" + tokens(0) + ")")
                Integer.TryParse(tokens(0), tmpNode.Tag)
        End Select
    End Sub

    Private Sub LoadBtn_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LoadBtn.Click
        Dim sr As System.IO.StreamReader = New System.IO.StreamReader(FileNameTxt.Text)

        Do While sr.Peek() > -1
            ParseLine(sr.ReadLine())
        Loop
        sr.Close()
    End Sub

    Private Function SortBySizeAscending(ByVal a As KeyValuePair(Of Integer, String), ByVal b As KeyValuePair(Of Integer, String)) As Integer
        Return a.Key - b.Key
    End Function

    Private Function SortBySizeDescending(ByVal a As KeyValuePair(Of Integer, String), ByVal b As KeyValuePair(Of Integer, String)) As Integer
        Return b.Key - a.Key
    End Function

    Private Sub Part1Btn_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Part1Btn.Click
        Dim list As New List(Of KeyValuePair(Of Integer, String))
        TraverseNodeSizes(DirectoryTV.Nodes.Find("/", False)(0), 100000, list)
        Dim total As Integer = 0

        For Each kvp In list
            total += kvp.Key
        Next
        Part1OutTxt.Text = total.ToString()

    End Sub

    Private Sub Part2Btn_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Part2Btn.Click
        Dim list As New List(Of KeyValuePair(Of Integer, String))
        Dim used = TraverseNodeSizes(DirectoryTV.Nodes.Find("/", False)(0), 0, list)
        list.Sort(AddressOf SortBySizeAscending)

        Dim required As Integer = 30000000 - (70000000 - used)

        Dim index As Integer = 0
        While index < list.Count AndAlso list(index).Key < required
            index += 1
        End While

        Part2OutTxt.Text = list(index).Key.ToString() + "  (" + list(index).Value + ")"

    End Sub
End Class
