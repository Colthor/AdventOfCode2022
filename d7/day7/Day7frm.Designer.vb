<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Day7Frm
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.DirectoryTV = New System.Windows.Forms.TreeView
        Me.FileNameTxt = New System.Windows.Forms.TextBox
        Me.LoadBtn = New System.Windows.Forms.Button
        Me.Part1OutTxt = New System.Windows.Forms.TextBox
        Me.Part1Btn = New System.Windows.Forms.Button
        Me.Part2Btn = New System.Windows.Forms.Button
        Me.Part2OutTxt = New System.Windows.Forms.TextBox
        Me.SuspendLayout()
        '
        'DirectoryTV
        '
        Me.DirectoryTV.Location = New System.Drawing.Point(11, 38)
        Me.DirectoryTV.Name = "DirectoryTV"
        Me.DirectoryTV.Size = New System.Drawing.Size(394, 511)
        Me.DirectoryTV.TabIndex = 0
        '
        'FileNameTxt
        '
        Me.FileNameTxt.Location = New System.Drawing.Point(11, 12)
        Me.FileNameTxt.Name = "FileNameTxt"
        Me.FileNameTxt.Size = New System.Drawing.Size(394, 20)
        Me.FileNameTxt.TabIndex = 1
        Me.FileNameTxt.Text = "day7test.txt"
        '
        'LoadBtn
        '
        Me.LoadBtn.Location = New System.Drawing.Point(11, 555)
        Me.LoadBtn.Name = "LoadBtn"
        Me.LoadBtn.Size = New System.Drawing.Size(394, 23)
        Me.LoadBtn.TabIndex = 2
        Me.LoadBtn.Text = "Load"
        Me.LoadBtn.UseVisualStyleBackColor = True
        '
        'Part1OutTxt
        '
        Me.Part1OutTxt.Location = New System.Drawing.Point(11, 584)
        Me.Part1OutTxt.Name = "Part1OutTxt"
        Me.Part1OutTxt.Size = New System.Drawing.Size(394, 20)
        Me.Part1OutTxt.TabIndex = 3
        '
        'Part1Btn
        '
        Me.Part1Btn.Location = New System.Drawing.Point(11, 610)
        Me.Part1Btn.Name = "Part1Btn"
        Me.Part1Btn.Size = New System.Drawing.Size(394, 23)
        Me.Part1Btn.TabIndex = 4
        Me.Part1Btn.Text = "Part 1 (<= 100k)"
        Me.Part1Btn.UseVisualStyleBackColor = True
        '
        'Part2Btn
        '
        Me.Part2Btn.Location = New System.Drawing.Point(12, 665)
        Me.Part2Btn.Name = "Part2Btn"
        Me.Part2Btn.Size = New System.Drawing.Size(394, 23)
        Me.Part2Btn.TabIndex = 6
        Me.Part2Btn.Text = "Part 2 (size of dir to delete)"
        Me.Part2Btn.UseVisualStyleBackColor = True
        '
        'Part2OutTxt
        '
        Me.Part2OutTxt.Location = New System.Drawing.Point(12, 639)
        Me.Part2OutTxt.Name = "Part2OutTxt"
        Me.Part2OutTxt.Size = New System.Drawing.Size(394, 20)
        Me.Part2OutTxt.TabIndex = 5
        '
        'Day7Frm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(417, 700)
        Me.Controls.Add(Me.Part2Btn)
        Me.Controls.Add(Me.Part2OutTxt)
        Me.Controls.Add(Me.Part1Btn)
        Me.Controls.Add(Me.Part1OutTxt)
        Me.Controls.Add(Me.LoadBtn)
        Me.Controls.Add(Me.FileNameTxt)
        Me.Controls.Add(Me.DirectoryTV)
        Me.Name = "Day7Frm"
        Me.Text = "AoC Day 7"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents DirectoryTV As System.Windows.Forms.TreeView
    Friend WithEvents FileNameTxt As System.Windows.Forms.TextBox
    Friend WithEvents LoadBtn As System.Windows.Forms.Button
    Friend WithEvents Part1OutTxt As System.Windows.Forms.TextBox
    Friend WithEvents Part1Btn As System.Windows.Forms.Button
    Friend WithEvents Part2Btn As System.Windows.Forms.Button
    Friend WithEvents Part2OutTxt As System.Windows.Forms.TextBox

End Class
