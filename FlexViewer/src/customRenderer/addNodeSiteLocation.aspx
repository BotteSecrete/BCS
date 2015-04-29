<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web.HttpUtility" %>
<%@ Page Language="vb" Strict="True" ValidateRequest="False" %>
<%Response.ContentType = "text/xml" %>

<SCRIPT language="vb" runat="server">
  'example urls: 
    'http://localhost/Sample/GetOrPutFile.aspx?getorput=get&fullfilespec=C:\Temp\RoomStatus.xml
    'http://localhost/Sample/GetOrPutFile.aspx?getorput=put&fullfilespec=C:\Temp\GetOrPuttestFile.xml&content=<roottest><testnode/></roottest>
  Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs)
    Response.Buffer = True
    Response.BufferOutput = True
    dim sGetOrPut as string = nullHandler(Request("getorput"))  'handle missing request arg

    If Len(sGetOrPut) = 0 Then
      Response.Write("<lt_status status='error' statusdescription='Request argument: getorput not provided. Must be get or put' " _
			                & "exceptionmessage='' " _
			                & "exceptionstring='' " _
			                & "/>")
    Else
      Select Case sGetOrPut
        Case "get"
          retrieveFileText()
        Case "put"
          saveFileText()          
      End Select
    End If

  End Sub  'Page_Load  
  
  Public Sub retrieveFileText()
    dim sFileSpec as string = nullHandler(Request("fullfilespec"))
    If sFileSpec.length > 0 Then
      Dim sContents As String
      Dim sr As StreamReader
      Try
          sr = New StreamReader(sFileSpec)
          sContents = sr.ReadToEnd()
          sr.Close()
          Response.Write(sContents)
      Catch Ex As System.IO.FileNotFoundException
			    Response.Write("<lt_status status='error' statusdescription='FileNotFound' " _
			    & "exceptionmessage='" 	& HTMLEncode(Ex.Message()) &  "' " _
			    & "exceptionstring='" 	& HTMLEncode(Ex.toString()) &  "' " _
			    & "/>")
      Catch Ex as Exception
			    Response.Write("<lt_status status='error' statusdescription='Unknown error' " _
			    & "exceptionmessage='" 	& HTMLEncode(Ex.Message()) &  "' " _
			    & "exceptionstring='" 	& HTMLEncode(Ex.toString()) &  "' " _
			    & "/>")			    
      End Try
    Else
      Response.Write("<error action=""get"" description=""'fullfilespec' request parameter not submitted"" />")
    End If

  End Sub  'retrieveFileText

  Public Sub saveFileText()
    dim sFileSpec as string = nullHandler(Request("fullfilespec"))
    If sFileSpec.length > 0 Then 
      Dim sContents As String = nullHandler(Request("content"))
      Dim sw As StreamWriter
      Try
          sw = New StreamWriter(sFileSpec)
          sw.Write(sContents)
          sw.Close()
          response.write("<lt_status status='success' statusdescription='output written' filespec='" + sFileSpec + "'/>")
      Catch Ex As System.IO.FileNotFoundException
			    Response.Write("<lt_status status='error' statusdescription='FileNotFound' " _
			    & "exceptionmessage='" 	& HTMLEncode(Ex.Message()) &  "' " _
			    & "exceptionstring='" 	& HTMLEncode(Ex.toString()) &  "' " _
			    & "/>")  
      Catch Ex as Exception
			    Response.Write("<lt_status status='error' statusdescription='Unknown error' " _
			    & "exceptionmessage='" 	& HTMLEncode(Ex.Message()) &  "' " _
			    & "exceptionstring='" 	& HTMLEncode(Ex.toString()) &  "' " _
			    & "/>")      
      End Try
    Else
        Response.Write("<error action=""put"" description=""fullfilespec parameter not submitted"" />")
    End If
  End Sub  'saveFileText  
  
  Private Function nullHandler(ByVal vValue As Object) As String
    If vValue Is Nothing Or IsDBNull(vValue) Then
        Return ""
    Else
        Return vValue.ToString()
    End If
  End Function  'nullHandler     
</SCRIPT>