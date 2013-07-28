#DEFINE tvwFirst	0
#DEFINE tvwLast	1
#DEFINE tvwNext	2
#DEFINE tvwPrevious	3
#DEFINE tvwChild	4

oForm = CREATEOBJECT('myForm')
WITH oForm
  .ADDOBJECT('Tree','myTreeView')
  .ADDOBJECT('Lister','Lister')
  WITH .Tree
    .Nodes.ADD(,0,"root1",'Main node 2')
    .Nodes.ADD(,0,"root2",'Main node 3')
    .Nodes.ADD('root1',4,"child11",'Child11')
    .Nodes.ADD('root1',4,"child12",'Child12')
    .Nodes.ADD('root2',4,"child21",'Child22')
    .Nodes.ADD('child21',3,"child20",'Child21')
    .Nodes.ADD('child11',4,"child111",'child113')
    .Nodes.ADD('child111',3,"child112",'child112')
    .Nodes.ADD('child112',3,"child113",'child111')
    .Nodes.ADD('root1',3,"root0",'Main node 1')
    .VISIBLE = .T.
  ENDWITH
  .Lister.LEFT = .WIDTH - .Lister.WIDTH
  .Lister.VISIBLE = .T.
  .SHOW()
ENDWITH
READ EVENTS

DEFINE CLASS myForm AS FORM
  AUTOCENTER = .T.
  HEIGHT = 640
  WIDTH = 800
  PROCEDURE QUERYUNLOAD
    CLEAR EVENTS
  ENDPROC
ENDDEFINE

DEFINE CLASS myTreeView AS OLECONTROL
  OLEDRAGMODE = 1
  OLEDROPMODE = 1
  NAME = "OleTreeView"
  OLECLASS = 'MSComCtlLib.TreeCtrl.2'
  HEIGHT = 600
  WIDTH = 700
  hottracking = .t.

  PROCEDURE INIT
    WITH THIS
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
    MESSAGEBOX(NODE.FULLPATH,TRANS(NODE.INDEX))
  ENDPROC

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
ENDDEFINE

DEFINE CLASS lister AS COMMANDBUTTON
  CAPTION = 'Listado'
  HEIGHT = 32
  WIDTH = 100

  PROCEDURE CLICK
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