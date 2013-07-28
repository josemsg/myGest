VERSION 5.00
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "vigon@wanadoo.es"
   ClientHeight    =   2715
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4680
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2715
   ScaleWidth      =   4680
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton Command2 
      Caption         =   "Insertar registros en Customers leyendo de XML"
      Height          =   495
      Left            =   360
      TabIndex        =   1
      Top             =   1440
      Width           =   3975
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Generar archivo XML basado en la tabla Customers"
      Height          =   495
      Left            =   360
      TabIndex        =   0
      Top             =   600
      Width           =   3975
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
Dim Doc As MSXML2.DOMDocument, Nod(2) As MSXML2.IXMLDOMNode
Dim Cnn As ADODB.Connection, Rst As ADODB.Recordset, Fld As ADODB.Field
   Screen.MousePointer = vbHourglass
   Set Doc = New MSXML2.DOMDocument       'Iniciar documento XML y nodo raíz
   Set Nod(0) = Doc.createElement("Customers")
   Set Cnn = New ADODB.Connection         'Instanciar y abrir conexión con la base de datos y la tabla «Customers»
   Set Rst = New ADODB.Recordset
   Cnn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & App.Path & "\Nwind.mdb;Persist Security Info=False"
   Rst.Open "Customers", Cnn, adOpenForwardOnly, adLockReadOnly, adCmdTable
   While Not Rst.EOF                      'Recorrer la tabla, creando un nodo <Registro> para cada registro
      Set Nod(1) = Doc.createElement("Registro")
      For Each Fld In Rst.Fields          'Para cada campo, crear un nodo <Campo> al nodo <Registro>
         Set Nod(2) = Doc.createElement(Fld.Name)
         If Not IsNull(Fld.Value) Then Nod(2).Text = Fld.Value
         Nod(1).appendChild Nod(2)        'Agregar el nodo <Campo> al nodo <Registro>
      Next Fld
      Nod(0).appendChild Nod(1)           'Agregar el nodo <Registro> al nodo <Customers>
      Rst.MoveNext
   Wend
   Doc.appendChild Nod(0)                 'Agregar el nodo <Customers> al documento XML
   Doc.Save App.Path & "\customers.xml"   'Guardar el documento XML en disco
   Rst.Close                              'Cerrar recordset y conexión a la base de datos
   Cnn.Close
   Screen.MousePointer = vbDefault
End Sub

Private Sub Command2_Click()
Dim Doc As MSXML2.DOMDocument, Nod As MSXML2.IXMLDOMNode
Dim Cnn As ADODB.Connection, Rst As ADODB.Recordset, Fld As ADODB.Field
   Set Doc = New MSXML2.DOMDocument
   If Doc.Load(App.Path & "\customers.xml") Then
      Screen.MousePointer = vbHourglass
      Set Cnn = New ADODB.Connection 'Instanciar y abrir conexión con la base de datos y la tabla «Customers»
      Set Rst = New ADODB.Recordset
      Cnn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & App.Path & "\Nwind_vacia.mdb;Persist Security Info=False"
      Rst.Open "Customers", Cnn, adOpenStatic, adLockOptimistic, adCmdTable
      For Each Nod In Doc.getElementsByTagName("Registro") 'Recorrer todos los nodos <Registro> del documento XML
         Rst.AddNew
         For Each Fld In Rst.Fields 'Recorrer todos los campos y asignar el valor de <Campo>
            If Len(Nod.selectSingleNode(Fld.Name).Text) Then _
               Rst.Collect(Fld.Name) = Nod.selectSingleNode(Fld.Name).Text
         Next Fld
         Rst.Update
      Next Nod
      Rst.Close 'Cerrar recordset y conexión a la base de datos
      Cnn.Close
      Screen.MousePointer = vbDefault
   Else
      MsgBox "No se puede abrir el archivo " & App.Path & "\customers.xml", vbCritical, "Error"
   End If
End Sub
