PUBLIC oXML  

oXML=CREATEOBJECT('msxml.domdocument')  && This creates the parser object

oXML.LOAD(GETFILE('xml'))  && This gets and loads the XML document. 

*** Select the XML document created from the XML code below.

*** The following gives the basename / RootElemant of the XML document
? oXml.DocumentElement.Basename 

*** The following gives the number of nodes (or records)           
? oXML.documentelement.childnodes.LENGTH  

*** REMEMBER that the object model is in base zero.
*** Therefore use the following in looping expressions  
? oXML.documentelement.childnodes.LENGTH - 1

*** The following returns the number of child nodes contained under the first Item
*** This is useful for looping through a childes elements
*** FOR ichild = 0 TO oXML.documentelement.childnodes.ITEM(0).childnodes.LENGTH - 1
? oXML.documentelement.childnodes.ITEM(0).childnodes.LENGTH - 1

*** The following returns the nodename of the childnode  
? oxml.documentelement.childnodes.item(0).childnodes(0).nodename

*** The following returns the data contained in the childnode
? oXML.documentelement.childnodes.ITEM(0).childnodes(0).TEXT

*** Returns a string of all the data contained in the second child / record
? oXml.documentelement.childnodes.item(1).nodetypedvalue
