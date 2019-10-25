Sub SaveOLFolderAttachments()
  'path of where to save attachments
  Dim myPath As String
  myPath = "C:\Users\nathan.curtis\Desktop\Working"
  
  'outlook folder where scans are
  Dim Ns As Outlook.NameSpace
  Set Ns = Application.GetNamespace("MAPI")
  Set olPurgeFolder = Ns.GetDefaultFolder(olFolderInbox).Parent.Folders("scans")
  If olPurgeFolder Is Nothing Then Exit Sub
   
  ' Iteration variables
  Dim msg As Outlook.MailItem
  Dim att As Outlook.Attachment
  Dim sSavePathFS As String
  Dim sDelAtts

  For Each msg In olPurgeFolder.Items

    sDelAtts = ""
    If msg.Attachments.Count > 0 Then
      While msg.Attachments.Count > 0
        ' Save the file
        sSavePathFS = myPath & "\" & msg.Attachments(1).FileName
        msg.Attachments(1).SaveAsFile sSavePathFS

        ' Build up a string to denote the file system save path(s)
        ' Format the string according to the msg.BodyFormat.
        If msg.BodyFormat <> olFormatHTML Then
            sDelAtts = sDelAtts & vbCrLf & "<file://" & sSavePathFS & ">"
        Else
            sDelAtts = sDelAtts & "<br>" & "<a href='file://" & sSavePathFS & "'>" & sSavePathFS & "</a>"
        End If

        ' Delete the current attachment.  We use a "1" here instead of an "i"
        ' because the .Delete method will shrink the size of the msg.Attachments
        ' collection for us.  Use some well placed Debug.Print statements to see
        ' the behavior.
         msg.Attachments(1).Delete

      Wend

      ' Modify the body of the msg to show the file system location of
      ' the deleted attachments.
      If msg.BodyFormat <> olFormatHTML Then
        msg.Body = msg.Body & vbCrLf & vbCrLf & "Attachments Deleted:  " & Date & " " & Time & vbCrLf & vbCrLf & "Saved To:  " & vbCrLf & sDelAtts
      Else
        msg.HTMLBody = msg.HTMLBody & "<p></p><p>" & "Attachments Deleted:  " & Date & " " & Time & vbCrLf & vbCrLf & "Saved To:  " & vbCrLf & sDelAtts & "</p>"
      End If

      ' Save the edits to the msg.  If you forget this line, the attachments will not be deleted.
      msg.Save

    End If
s
  Next
