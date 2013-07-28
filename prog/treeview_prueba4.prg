* Define some constant
#DEFINE tvwFirst     0
#DEFINE tvwLast      1
#DEFINE tvwNext      2
#DEFINE tvwPrevious  3
#DEFINE tvwChild     4
#DEFINE cnLOG_PIXELS_X 88
#DEFINE cnLOG_PIXELS_Y 90
* 1440 twips por pulgadas
#DEFINE cnTWIPS_PER_INCH 1440

oForm = CREATEOBJECT('myForm')
oForm.SHOW
READ EVENTS

DEFINE CLASS myForm AS FORM
  HEIGHT = 640
  WIDTH = 800
  AUTOCENTER = .T.
  CAPTION = "TreeView - TestPad"
  NAME = "myForm"

  *-- Node object reference
  nodx = .F.
  nxtwips = .F.
  nytwips = .F.

  ADD OBJECT oletreeview AS OLECONTROL WITH ;
    TOP = 0, LEFT = 0, HEIGHT = 600, WIDTH = 750, ;
    ANCHOR = 15, NAME = "OleTreeView", ;
    OLECLASS = 'MSComCtlLib.TreeCtrl'

  ADD OBJECT oleimageslist AS OLECONTROL WITH ;
    TOP = 0, LEFT = 0, HEIGHT = 100, WIDTH = 100, ;
    NAME = "oleImagesList",;
    OLECLASS = 'MSComCtlLib.ImageListCtrl'

  *-- Fill the tree values
  PROCEDURE filltree
    LPARAMETERS tcDirectory, tcImage
    THIS.SHOW
    CREATE CURSOR crsNodes (NodeKey c(15), ParentKey c(15), NodeText m, NewParent c(15))
    LOCAL oNode
    WITH THIS.oletreeview.nodes
      oNode=.ADD(,tvwFirst,"root"+PADL(.COUNT,3,'0'),tcDirectory,tcImage)
    ENDWITH
    INSERT INTO crsNodes (NodeKey, ParentKey, NodeText) VALUES (oNode.KEY, '',oNode.TEXT)
    THIS._SubFolders(oNode)

  ENDPROC

  PROCEDURE pixeltotwips

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
    THISFORM.nxtwips = ( cnTWIPS_PER_INCH / liPixelsPerInchX )
    THISFORM.nytwips = ( cnTWIPS_PER_INCH / liPixelsPerInchY )
    RETURN

  ENDPROC

  *-- Collect subfolders
  PROCEDURE _SubFolders
    LPARAMETERS oNode
    LOCAL nChild, oNodex
    lcFolder = oNode.FULLPATH
    lcFolder = STRTRAN(lcFolder,":\\",":\")
    oFS = CREATEOBJECT('Scripting.FileSystemObject')
    oFolder = oFS.GetFolder(lcFolder)
    WITH THISFORM.oletreeview
      lnIndent = 0
      lnIndex = oNode.INDEX
      DO WHILE lnIndex # oNode.Root.INDEX ;
          AND TYPE('.nodes(lnIndex).Parent')='O' ;
          AND !ISNULL(.nodes(lnIndex).PARENT)
        lnIndex = .nodes(lnIndex).PARENT.INDEX
        lnIndent = lnIndent + 1
      ENDDO
      lcChildKeyPrefix = 'L'+PADL(lnIndent,3,'0')+'_'
    ENDWITH
    WITH THISFORM.oletreeview.nodes
      IF oNode.Children > 0
        IF oNode.CHILD.KEY = oNode.KEY+"dummy"
          .REMOVE(oNode.CHILD.INDEX)
          FOR EACH oSubFolder IN oFolder.Subfolders
            INSERT INTO crsNodes ;
              (NodeKey, ParentKey, NodeText) ;
              VALUES ;
              (lcChildKeyPrefix+' '+PADL(RECCOUNT('crsNodes')+1,5,'0'), ;
              oNode.KEY, oSubFolder.PATH)
            oNodex = .ADD(oNode.KEY, tvwChild, ;
              crsNodes.NodeKey, oSubFolder.NAME, "ClosedFolder","OpenFolder" )
            oNodex.ExpandedImage = "OpenFolder"
            IF oSubFolder.NAME # "System Volume Information" AND oSubFolder.Subfolders.COUNT > 0
              oNodex = .ADD(crsNodes.NodeKey, tvwChild, ;
                crsNodes.NodeKey+"dummy", "dummy", "ClosedFolder","OpenFolder" )
            ENDIF
          ENDFOR
        ENDIF
      ELSE
        IF oFolder.Subfolders.COUNT > 0
          oNodex = .ADD(oNode.KEY, tvwChild, ;
            oNode.KEY+"dummy", "dummy", "ClosedFolder","OpenFolder" )
        ENDIF
      ENDIF
    ENDWITH
  ENDPROC

  PROCEDURE QUERYUNLOAD
    THISFORM.nodx = .NULL.
    CLEAR EVENTS
  ENDPROC

  PROCEDURE INIT
    THIS.pixeltotwips()
    SET TALK OFF
    * Check to see if OCX installed and loaded.
    IF TYPE("THIS.oleTreeView") # "O" OR ISNULL(THIS.oletreeview)
      RETURN .F.
    ENDIF
    IF TYPE("THIS.oleImagesList") # "O" OR ISNULL(THIS.oleimageslist)
      RETURN .F.
    ENDIF
    lcIconPath = HOME(0) + "Graphics\Icons\"
    WITH THIS.oleimageslist
      .ImageHeight = 32
      .ImageWidth = 32
      .ListImages.ADD(,"OpenFolder",LOADPICTURE(lcIconPath+"Win95\openfold.ico"))
      .ListImages.ADD(,"ClosedFolder",LOADPICTURE(lcIconPath+"Win95\clsdfold.ico"))
      .ListImages.ADD(,"Drive",LOADPICTURE(lcIconPath+"Computer\drive01.ico"))
      .ListImages.ADD(,"Floppy",LOADPICTURE(lcIconPath+"Win95\35floppy.ico"))
      .ListImages.ADD(,"NetDrive",LOADPICTURE(lcIconPath+"Win95\drivenet.ico"))
      .ListImages.ADD(,"CDDrive",LOADPICTURE(lcIconPath+"Win95\CDdrive.ico"))
      .ListImages.ADD(,"RAMDrive",LOADPICTURE(lcIconPath+"Win95\desktop.ico"))
      .ListImages.ADD(,"Unknown",LOADPICTURE(lcIconPath+"Misc\question.ico"))
    ENDWITH

    WITH THIS.oletreeview
      .linestyle =1
      .labeledit =1
      .indentation = 5
      .imagelist = THIS.oleimageslist.OBJECT
      .PathSeparator = '\'
      .OLEDRAGMODE = 1
      .OLEDROPMODE = 1
    ENDWITH

    oFS = CREATEOBJECT('Scripting.FileSystemObject')
    LOCAL ARRAY aDrvTypes[7]
    aDrvTypes[1]="Unknown"
    aDrvTypes[2]="Floppy"
    aDrvTypes[3]="Drive"
    aDrvTypes[4]="NetDrive"
    aDrvTypes[5]="CDDrive"
    aDrvTypes[6]="RAMDrive"

    FOR EACH oDrive IN oFS.Drives
      IF oDrive.IsReady
        THIS.filltree(oDrive.Rootfolder.PATH, aDrvTypes[oDrive.DriveType+1])
      ENDIF
    ENDFOR
  ENDPROC

  PROCEDURE oletreeview.Expand
    *** ActiveX Control Event ***
    LPARAMETERS NODE
    THISFORM._SubFolders(NODE)
    NODE.ensurevisible
  ENDPROC

  PROCEDURE oletreeview.NodeClick
    *** ActiveX Control Event ***
    LPARAMETERS NODE
    NODE.ensurevisible
    THIS.DropHighlight = .NULL.
  ENDPROC

  PROCEDURE oletreeview.MOUSEDOWN
    *** ActiveX Control Event ***
    LPARAMETERS BUTTON, SHIFT, x, Y
    WITH THISFORM
      oHitTest = THIS.HitTest( x * .nxtwips, Y * .nytwips )
      IF TYPE("oHitTest")= "O" AND !ISNULL(oHitTest)
        THIS.SELECTEDITEM = oHitTest
      ENDIF
      .nodx = THIS.SELECTEDITEM
    ENDWITH
    oHitTest = .NULL.
  ENDPROC

  PROCEDURE oletreeview.OLEDRAGOVER
    *** ActiveX Control Event ***
    LPARAMETERS DATA, effect, BUTTON, SHIFT, x, Y, state
    oHitTest = THIS.HitTest( x * THISFORM.nxtwips, Y * THISFORM.nytwips )
    IF TYPE("oHitTest")= "O"
      THIS.DropHighlight = oHitTest
    ENDIF
  ENDPROC

  PROCEDURE oletreeview.OLEDRAGDROP
    *** ActiveX Control Event ***
    LPARAMETERS DATA, effect, BUTTON, SHIFT, x, Y
    IF DATA.GETFORMAT(1)     &&CF_TEXT
      WITH THIS
        IF !ISNULL(THISFORM.nodx) AND TYPE(".DropHighLight") = "O" AND !ISNULL(.DropHighlight)
          loSource = THISFORM.nodx
          loTarget = .DropHighlight
          IF loSource.KEY # loTarget.KEY AND TYPE('loSource.Parent') = 'O'
            lcSourceParentKey = loSource.PARENT.KEY
            lcTargetParentKey = loTarget.PARENT.KEY
            IF SUBSTR(lcSourceParentKey,1,AT('_',lcSourceParentKey)-1) == ;
                SUBSTR(lcTargetParentKey,1,AT('_',lcTargetParentKey)-1)
              lcSourceKey = IIF(lcSourceParentKey == lcTargetParentKey,'',;
                IIF(SHIFT=1,'mv','cp'))+loSource.KEY
              lcSourceText = loSource.TEXT
              llRemoveSource = (lcSourceParentKey == lcTargetParentKey OR SHIFT=1)

              * Check here for children repopulation since we're simulating with existing directories
              * llGetChildren should be false for copy-move from another parent dir
              llGetChildren  = (lcSourceParentKey == lcTargetParentKey)

              IF llRemoveSource
                .nodes.REMOVE(loSource.INDEX)
              ENDIF
              * Check if node exists already
              IF TYPE('.Nodes(lcSourceKey)') # 'O'
                oNode=.nodes.ADD(loTarget.KEY,tvwPrevious,lcSourceKey,lcSourceText,;
                  "ClosedFolder","OpenFolder")
                .SELECTEDITEM = oNode
                IF llGetChildren
                  THISFORM._SubFolders(oNode)
                ENDIF
              ENDIF
            ENDIF
          ENDIF
        ENDIF
      ENDWITH
    ENDIF
    THIS.DropHighlight = .NULL.
  ENDPROC

ENDDEFINE
