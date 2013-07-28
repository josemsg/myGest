<?xml version='1.0'?>
	<xsl:stylesheet xmlns:xsl='http://www.w3.org/TR/WD-xsl'>
		<xsl:template match='/'>
			<HTML>
			<HEAD>
			<TITLE>CUSTOMER</TITLE>
			<H2>CUSTOMER Information</H2>
			</HEAD>
				<BODY BGCOLOR = 'white'>
					<TABLE BORDER= '1' bgcolor='#FFFFF0'>
						<TR>
						<TD><b>CUST_ID</b></TD>
						<TD><b>COMPANY</b></TD>
						<TD><b>CONTACT</b></TD>
						<TD><b>TITLE</b></TD>
						<TD><b>ADDRESS</b></TD>
						<TD><b>CITY</b></TD>
						<TD><b>REGION</b></TD>
						<TD><b>POSTALCODE</b></TD>
						<TD><b>COUNTRY</b></TD>
						<TD><b>PHONE</b></TD>
						<TD><b>FAX</b></TD>
						<TD><b>MAXORDAMT</b></TD>
						</TR>
						<xsl:for-each select='CUSTOMER_table/CUSTOMER'>
						<TR>
							<TD><xsl:value-of select='CUST_ID'/></TD>
							<TD><xsl:value-of select='COMPANY'/></TD>
							<TD><xsl:value-of select='CONTACT'/></TD>
							<TD><xsl:value-of select='TITLE'/></TD>
							<TD><xsl:value-of select='ADDRESS'/></TD>
							<TD><xsl:value-of select='CITY'/></TD>
							<TD><xsl:value-of select='REGION'/></TD>
							<TD><xsl:value-of select='POSTALCODE'/></TD>
							<TD><xsl:value-of select='COUNTRY'/></TD>
							<TD><xsl:value-of select='PHONE'/></TD>
							<TD><xsl:value-of select='FAX'/></TD>
							<TD><xsl:value-of select='MAXORDAMT'/></TD>
						</TR>
						</xsl:for-each>
					</TABLE>
				</BODY>
			</HTML>
		</xsl:template>
	</xsl:stylesheet>