#DEFINE tvwFirst    0
#DEFINE tvwLast    1
#DEFINE tvwNext    2
#DEFINE tvwPrevious    3
#DEFINE tvwChild    4

#DEFINE cnLOG_PIXELS_X 88
#DEFINE cnLOG_PIXELS_Y 90
#DEFINE cnTWIPS_PER_INCH 1440

TEXT to myMenu noshow
Lparameters toNode,toForm

DEFINE POPUP shortcut SHORTCUT RELATIVE FROM MROW(),MCOL()
DEFINE BAR 1 OF shortcut PROMPT "Key"
DEFINE BAR 2 OF shortcut PROMPT "Text"
DEFINE BAR 3 OF shortcut PROMPT "Fullpath"
DEFINE BAR 4 OF shortcut PROMPT "Index"
DEFINE BAR 5 OF shortcut PROMPT "New Item"
ON SELECTION BAR 1 OF shortcut ;
    wait window toNode.Key timeout 2
ON SELECTION BAR 2 OF shortcut  ;
    wait window toNode.Text timeout 2
ON SELECTION BAR 3 OF shortcut  ;
    wait window toNode.Fullpath timeout 2
ON SELECTION BAR 4 OF shortcut  ;
    wait window Transform(toNode.Index) timeout 2
ON SELECTION BAR 5 OF shortcut toForm.ShowIt(toNode)
ACTIVATE POPUP shortcut

ENDTEXT

*StrToFile(m.myMenu,'myTVShcut.mpr')

oForm = CREATEOBJECT('myForm')
WITH oForm
  .ADDOBJECT('Tree','myTreeView')
  .ADDOBJECT('Lister','Lister')
  WITH .Tree
    .WIDTH = 700
    .HEIGHT = 600
    .Nodes.ADD(,0,"root0",'Main node 1')
    .Nodes.ADD(,0,"root1",'Main node 2')
    .Nodes.ADD(,0,"root2",'Main node 3')
    .Nodes.ADD('root1',4,"child11",'Child11')
    .Nodes.ADD('root1',4,"child12",'Child12')
    .Nodes.ADD('root2',4,"child21",'Child22')
    .Nodes.ADD('child21',3,"child20",'Child21')
    oNodx=.Nodes.ADD('child11',4,"child111",'child113')
    oNodx.Bold=.T.
    .Nodes.ADD('child111',3,"child112",'child112')
    .Nodes.ADD('child112',3,"child113",'child111')

    .Nodes.ADD('child12',4,"child121",'child121')
    .Nodes.ADD('child12',4,"child122",'child122')

    .Nodes.ADD('child112',4,"child1121",'child1121')
    .Nodes.ADD('child112',4,"child1122",'child1122')
    .Nodes.ADD('child112',4,"child1123",'child1123')
    .Nodes.ADD('child112',4,"child1124",'child1124')
    .Nodes.ADD('child112',4,"child1125",'child1125')

    .Nodes.ADD('child1121',4,"child11211",'child11211')
    .Nodes.ADD('child1121',4,"child11212",'child11212')

    .Nodes.ADD('child11211',4,"child112111",'child112111')
    .Nodes.ADD('child11212',4,"child112121",'child112121 last added')
    .VISIBLE = .T.
    .Nodes(.Nodes.COUNT).Ensurevisible
    WITH .FONT
      .SIZE = 12
      .NAME = 'Times New Roman'
      .Bold = .F.
      .Italic = .T.
    ENDWITH
  ENDWITH
  .Lister.LEFT = .WIDTH - .Lister.WIDTH
  .lister.VISIBLE = .T.
  .SHOW()
ENDWITH
READ EVENTS

FUNCTION TVLister
  LPARAMETERS toTV
  LOCAL lnIndex,lnLastIndex
  WITH toTV
    lnIndex     = .Nodes(1).Root.FirstSibling.INDEX
    lnLastIndex = .Nodes(1).Root.LastSibling.INDEX
    _GetSubNodes(lnIndex,toTV,lnIndex)
    DO WHILE lnIndex # lnLastIndex
      lnIndex = .Nodes(lnIndex).NEXT.INDEX
      _GetSubNodes(lnIndex,toTV,lnIndex)
    ENDDO
  ENDWITH

FUNCTION _GetSubNodes
  LPARAMETERS tnIndex, toTV, tnRootIndex
  LOCAL lnIndex, lnLastIndex
  WITH toTV
    WriteNode(tnIndex,toTV, tnRootIndex)
    IF .Nodes(tnIndex).Children > 0
      lnIndex  = .Nodes(tnIndex).CHILD.INDEX
      lnLastIndex = .Nodes(tnIndex).CHILD.LastSibling.INDEX
      _GetSubNodes(lnIndex,toTV,tnRootIndex)
      DO WHILE lnIndex # lnLastIndex
        lnIndex = .Nodes(lnIndex).NEXT.INDEX
        _GetSubNodes(lnIndex,toTV,tnRootIndex)
      ENDDO
    ENDIF
  ENDWITH

FUNCTION WriteNode
  LPARAMETERS tnCurIndex, toTV,tnRootIndex
  LOCAL lnRootIndex, lnIndex, lcPrefix, lcKey, lnLevel
  lnIndex = tnCurIndex

  WITH toTV
    lcPrefix = '+-' + .Nodes(lnIndex).TEXT
    lnLevel = 0
    DO WHILE lnIndex # tnRootIndex
      lnIndex = .Nodes(lnIndex).PARENT.INDEX
      lcPrefix = IIF(.Nodes(lnIndex).LastSibling.INDEX = lnIndex,' ','|')+SPACE(3)+lcPrefix
      lnLevel = lnLevel + 1
    ENDDO
    ? lcPrefix
  ENDWITH

FUNCTION WalkTree
  LPARAMETERS oNode,lnIndent,tlPlus
  ? IIF(tlPlus,'+','')+REPLICATE(CHR(9),lnIndent)+oNode.TEXT
  IF !ISNULL(oNode.CHILD)
    WalkTree(oNode.CHILD,lnIndent+1,.T.)
  ENDIF
  IF !ISNULL(oNode.NEXT)
    WalkTree(oNode.NEXT,lnIndent,.F.)
  ENDIF
  RETURN
ENDFUNC

DEFINE CLASS myForm AS FORM
  AUTOCENTER = .T.
  HEIGHT = 640
  WIDTH = 800

  nxtwips = .F.
  nytwips = .F.

  PROCEDURE QUERYUNLOAD
    CLEAR EVENTS
  ENDPROC

  PROCEDURE ShowIt
    LPARAMETERS toNode
    MESSAGEBOX("Form method called with " + toNode.FULLPATH)
  ENDPROC

  PROCEDURE INIT
    *-- Code for PixelToTwips method
    LOCAL liHWnd, liHDC, liPixelsPerInchX, liPixelsPerInchY

    * Declare some Windows API functions.
    DECLARE INTEGER GetActiveWindow IN WIN32API
    DECLARE INTEGER GetDC IN WIN32API INTEGER iHDC
    DECLARE INTEGER GetDeviceCaps IN WIN32API INTEGER iHDC, INTEGER iIndex

    * Get a device context for VFP.
    liHWnd = GetActiveWindow()
    liHDC = GetDC(liHWnd)

    * Get the pixels per inch.
    liPixelsPerInchX = GetDeviceCaps(liHDC, cnLOG_PIXELS_X)
    liPixelsPerInchY = GetDeviceCaps(liHDC, cnLOG_PIXELS_Y)

    * Get the twips per pixel.
    THIS.nxtwips = ( cnTWIPS_PER_INCH / liPixelsPerInchX )
    THIS.nytwips = ( cnTWIPS_PER_INCH / liPixelsPerInchY )
    RETURN
  ENDPROC


  PROCEDURE CheckRest
    LPARAMETERS tnIndex, tlCheck, toTreeView
    LOCAL lnIndex, lnLastIndex
    WITH toTreeView
      .Nodes(tnIndex).Checked = tlCheck
      IF .Nodes(tnIndex).Children > 0
        lnIndex  = .Nodes(tnIndex).CHILD.INDEX
        lnLastIndex = .Nodes(tnIndex).CHILD.LastSibling.INDEX
        THIS.CheckRest(lnIndex, tlCheck, toTreeView)
        DO WHILE lnIndex # lnLastIndex
          lnIndex = .Nodes(lnIndex).NEXT.INDEX
          THIS.CheckRest(lnIndex, tlCheck, toTreeView)
        ENDDO
      ENDIF
    ENDWITH
  ENDPROC

ENDDEFINE

DEFINE CLASS myTreeView AS OLECONTROL
  OLEDRAGMODE = 1
  OLEDROPMODE = 1
  NAME = "OleTreeView"
  OLECLASS = 'MSComCtlLib.TreeCtrl'

  PROCEDURE INIT
    WITH THIS
      .OBJECT.CheckBoxes = .T.
      .linestyle =1
      .labeledit =1
      .indentation = 5
      .PathSeparator = '\'
    ENDWITH
  ENDPROC
  PROCEDURE NodeClick
    *** ActiveX Control Event ***
    LPARAMETERS NODE
    NODE.ensurevisible
    MESSAGEBOX(NODE.FULLPATH + CHR(13) +TRANS(NODE.INDEX),0,"NodeClick",2000)
  ENDPROC

  PROCEDURE MOUSEDOWN
    LPARAMETERS BUTTON, SHIFT, x, Y
    IF BUTTON=2
      lcWhere = ''
      oNode = THIS.HitTest( x * THISFORM.nxtwips, Y * THISFORM.nytwips )
      IF TYPE("oNode")= "O" AND !ISNULL(oNode)
        *        DO myTVShcut.mpr with oNode
        EXECSCRIPT(m.MyMenu, oNode, THISFORM)
      ENDIF
    ENDIF
  ENDPROC

  PROCEDURE MOUSEUP
    LPARAMETERS BUTTON, SHIFT, x, Y
    *!*      if button=2
    *!*          nodefault
    *!*          Wait window 'Right click occured in Mup' timeout 2
    *!*      endif
    IF BUTTON=1
      oNode = THIS.HitTest( x * THISFORM.nxtwips, Y * THISFORM.nytwips )
      IF TYPE("oNode")= "O" AND !ISNULL(oNode)
        IF oNode.KEY # 'root1'
          oNode.Checked = .F.
        ELSE
          THISFORM.CheckRest(oNode.INDEX,oNode.Checked,THIS)
        ENDIF
      ENDIF
    ENDIF
  ENDPROC

  *!*      Procedure NodeCheck
  *!*    *** ActiveX Control Event ***
  *!*    Lparameters node,dummy
  *!*    IF node.Key = 'root1'
  *!*    thisform.CheckRest(node.Index,node.Checked,this)
  *!*    endif
  *!*    endproc

  PROCEDURE _SubNodes
    LPARAMETERS tnIndex, tnLevel
    LOCAL lnIndex
    lcFs = ''
    WITH THIS
      ? IIF(tnLevel=0,'',REPLICATE(CHR(9),tnLevel))+.Nodes(tnIndex).TEXT, "[Actual index :"+TRANS(tnIndex)+"]"
      IF .Nodes(tnIndex).Children > 0
        lnIndex  = .Nodes(tnIndex).CHILD.INDEX
        ._SubNodes(lnIndex,tnLevel+1)
        DO WHILE lnIndex # .Nodes(tnIndex).CHILD.LastSibling.INDEX
          lnIndex = .Nodes(lnIndex).NEXT.INDEX
          ._SubNodes(lnIndex,tnLevel+1)
        ENDDO
      ENDIF
    ENDWITH
  ENDPROC

  PROCEDURE ExpandAll
    LPARAMETERS tnIndex
    LOCAL lnIndex
    WITH THIS
      .Nodes(tnIndex).Expanded = .T.
      IF .Nodes(tnIndex).Children > 0
        lnIndex  = .Nodes(tnIndex).CHILD.INDEX
        .ExpandAll(lnIndex)
        DO WHILE lnIndex # .Nodes(tnIndex).CHILD.LastSibling.INDEX
          lnIndex = .Nodes(lnIndex).NEXT.INDEX
          .ExpandAll(lnIndex)
        ENDDO
      ENDIF
    ENDWITH
  ENDPROC
ENDDEFINE

DEFINE CLASS Lister AS COMMANDBUTTON
  CAPTION = 'Listado'
  HEIGHT = 32
  WIDTH = 100

  PROCEDURE CLICK
    ACTIVATE SCREEN
    TvLister(THISFORM.Tree)
    WITH THISFORM.Tree
      *  WalkTree(.Nodes(1),0)
      *    .ExpandAll(.SelectedItem.Index)
    ENDWITH
  ENDPROC

  PROCEDURE click1
    ACTIVATE SCREEN
    CLEAR
    LOCAL lnIndex
    WITH THISFORM.Tree
      lnIndex = .Nodes(1).Root.FirstSibling.INDEX
      ._SubNodes(lnIndex,0)
      DO WHILE lnIndex # .Nodes(1).Root.LastSibling.INDEX
        lnIndex = .Nodes(lnIndex).NEXT.INDEX
        ._SubNodes(lnIndex,0)
      ENDDO
    ENDWITH
  ENDPROC
ENDDEFINE