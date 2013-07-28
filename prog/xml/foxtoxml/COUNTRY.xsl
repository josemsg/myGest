<?xml version='1.0'?>
	<xsl:stylesheet xmlns:xsl='http://www.w3.org/TR/WD-xsl'>
		<xsl:template match='/'>
			<HTML>
			<HEAD>
			<TITLE>COUNTRY</TITLE>
			<H2>COUNTRY Information</H2>
			</HEAD>
				<BODY BGCOLOR = 'white'>
					<TABLE BORDER= '1' bgcolor='#FFFFF0'>
						<TR>
						<TD><b>PAISES</b></TD>
						</TR>
						<xsl:for-each select='COUNTRY_table/COUNTRY'>
						<TR>
							<TD><xsl:value-of select='COUNTRY'/></TD>
						</TR>
						</xsl:for-each>
					</TABLE>
				</BODY>
			</HTML>
		</xsl:template>
	</xsl:stylesheet>
