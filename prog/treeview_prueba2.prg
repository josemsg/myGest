SELECT PADR('Customer_'+cust_id,20) AS NodeID, ;
  PADR('',20) AS ParentID, ;
  PADR(Company,100) AS NodeText, ;
  0 AS LEVEL ;
  FROM (HOME(2)+'data\customer') ;
  UNION ;
  SELECT PADR('Orders_'+order_id,20) AS NodeID, ;
  PADR('Customer_'+c.cust_id,20) AS ParentID, ;
  PADR(ALLTRIM(TRANSFORM(order_id))+":"+TRANSFORM(Order_Date),100) AS NodeText, ;
  1 AS LEVEL ;
  FROM (HOME(2)+'data\Orders') o ;
  INNER JOIN (HOME(2)+'data\customer') c ON o.cust_id == c.cust_id ;
  UNION ;
  SELECT 'OrdItems_'+oi.order_id+'_'+PADL(line_no,3,'0') AS NodeID, ;
  'Orders_'+o.order_id AS ParentID, ;
  TRANSFORM(oi.line_no)+':'+p.Prod_Name-(' ['+TRANSFORM(oi.Quantity)+']') AS NodeText, ;
  2 AS LEVEL ;
  FROM (HOME(2)+'data\OrdItems') oi ;
  INNER JOIN (HOME(2)+'data\Orders') o ON oi.order_id == o.order_id ;
  INNER JOIN (HOME(2)+'data\customer') c ON o.cust_id == c.cust_id ;
  INNER JOIN (HOME(2)+'data\products') p ON oi.product_id == p.product_id ;
  ORDER BY LEVEL ;
  INTO CURSOR myTree ;
  nofilter
  BROWSE last
  

#DEFINE tvwFirst	0
#DEFINE tvwLast	1
#DEFINE tvwNext	2
#DEFINE tvwPrevious	3
#DEFINE tvwChild	4

PUBLIC oForm
oForm = CREATEOBJECT('myTreeForm','myTree')
oForm.SHOW

DEFINE CLASS myTreeForm AS FORM
  HEIGHT = 640
  WIDTH = 800
  Autocenter = .T.
  CAPTION = "TreeView - TestPad"

  nxtwips = 0
  nytwips = 0
  cursorbehind = ''

  ADD OBJECT TreeView AS OLECONTROL WITH ;
    HEIGHT = 640, WIDTH = 800, ;
    anchor = 15, OLECLASS = 'MSComCtlLib.TreeCtrl'

  PROCEDURE INIT
    LPARAMETERS tcCursorName
    WITH THIS.TreeView
      .linestyle =1
      .labeledit =1
      .indentation = 5
      .PathSeparator = '\'
      .SCROLL = .T.
      .OLEDRAGMODE = 0
      .OLEDROPMODE = 0
    ENDWITH
    THIS.cursorbehind = m.tcCursorName
    THIS.PixelToTwips()
    THIS.Populate()
  ENDPROC

  PROCEDURE Populate
    SELECT (THIS.cursorbehind)
    WITH THIS.TreeView.Nodes
      SCAN
        IF EMPTY(ParentID)
          oNode = .ADD(,tvwFirst,TRIM(NodeID),TRIM(NodeText))
          oNode.Bold = .T.
        ELSE
          oNode = .ADD(TRIM(ParentID),tvwChild,TRIM(NodeID) ,TRIM(NodeText))
          IF OCCURS('\',oNode.FULLPATH)=1
            oNode.BACKCOLOR = 0x00FFFF
            oNode.FORECOLOR = 0xFF0000
          ENDIF
          IF OCCURS('\',oNode.FULLPATH)=2
            oNode.FORECOLOR = 0x0000FF
          ENDIF
        ENDIF
      ENDSCAN
    ENDWITH
  ENDPROC

  PROCEDURE PixelToTwips
    LOCAL liHDC, liPixelsPerInchX, liPixelsPerInchY
    #DEFINE cnLOG_PIXELS_X 88
    #DEFINE cnLOG_PIXELS_Y 90
    #DEFINE cnTWIPS_PER_INCH 1440

    DECLARE INTEGER GetActiveWindow IN WIN32API
    DECLARE INTEGER GetDC IN WIN32API INTEGER iHDC
    DECLARE INTEGER GetDeviceCaps IN WIN32API INTEGER iHDC, INTEGER iIndex

    liHDC = GetDC(GetActiveWindow())

    liPixelsPerInchX = GetDeviceCaps(liHDC, cnLOG_PIXELS_X)
    liPixelsPerInchY = GetDeviceCaps(liHDC, cnLOG_PIXELS_Y)

    THIS.nxtwips = ( cnTWIPS_PER_INCH / liPixelsPerInchX )
    THIS.nytwips = ( cnTWIPS_PER_INCH / liPixelsPerInchY )
  ENDPROC

  PROCEDURE TreeView.MOUSEMOVE
    LPARAMETERS BUTTON, SHIFT, x, Y
    WITH THISFORM
      oHitTest = THIS.HitTest( x * .nxtwips, Y * .nytwips )
      IF TYPE("oHitTest")= "O" AND !ISNULL(oHitTest)
        WAIT WINDOW NOWAIT oHitTest.FULLPATH
      ENDIF
    ENDWITH
    oHitTest = .NULL.
  ENDPROC

  PROCEDURE TreeView.NodeClick
    LPARAMETERS oNode
    LOCAL aNodeInfo[1]
    IF ALINES(aNodeInfo,oNode.KEY,1,'_') = 2 && Customer or orders
      IF LOWER(aNodeInfo[1]) == 'customer'
        SELECT * FROM customer WHERE cust_id = aNodeInfo[2]
      ELSE
        SELECT * FROM orders WHERE VAL(order_id) = VAL(aNodeInfo[2])
      ENDIF
    ELSE
      SELECT * FROM orditems ;
        WHERE VAL(order_id) = VAL(aNodeInfo[2]) AND line_no = VAL(aNodeInfo[3])
    ENDIF
  ENDPROC
ENDDEFINE