<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output omit-xml-declaration="yes" />

<xsl:template match="//season">
<xsl:text># Season </xsl:text><xsl:value-of select="name" /> <xsl:text>&#10;</xsl:text>
<xsl:text>### Competition: </xsl:text><xsl:value-of select="competition/name" /><xsl:text>&#10;</xsl:text>
<xsl:text>Gender: </xsl:text><xsl:value-of select="competition/gender" /><xsl:text>&#10;</xsl:text>
<xsl:text>#### Year: </xsl:text><xsl:value-of select="date/year"/><xsl:text>. From: </xsl:text><xsl:value-of select="date/start" /><xsl:text> to </xsl:text><xsl:value-of select="date/end" /><xsl:text>&#10;</xsl:text>
<xsl:text>---</xsl:text> <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="//stage">
<xsl:for-each select=".">
<xsl:text>---</xsl:text><xsl:text>&#10;</xsl:text>
<xsl:text>#### </xsl:text><xsl:value-of select="@phase" /><xsl:text>. From: </xsl:text><xsl:value-of select="@start_date" /><xsl:text> to: </xsl:text><xsl:value-of select="@end_date" /><xsl:text>&#10;</xsl:text>
<xsl:text>---</xsl:text><xsl:text>&#10;</xsl:text>
<xsl:text>#### Competitors:</xsl:text><xsl:text>&#10;</xsl:text>
<xsl:for-each select=".//competitor">
<xsl:text>- </xsl:text><xsl:value-of select="name" /><xsl:text> (</xsl:text><xsl:value-of select="abbreviation" /><xsl:text>)</xsl:text><xsl:text>&#10;</xsl:text>
</xsl:for-each>
</xsl:for-each>
<xsl:text>---</xsl:text><xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="//competitors">
<xsl:text>#### Teams</xsl:text><xsl:text>&#10;</xsl:text>
<xsl:for-each select="competitor">
<xsl:text>#### </xsl:text><xsl:value-of select="name" /><xsl:text>&#10;</xsl:text>  
<xsl:text>##### Players</xsl:text><xsl:text>&#10;</xsl:text>
<xsl:text>| Name | Type | Date of birth | Nationality | Events played |</xsl:text><xsl:text>&#10;</xsl:text>
<xsl:text>|---|---|---|---|---|</xsl:text><xsl:text>&#10;</xsl:text>
<xsl:for-each select="players/player">
<xsl:sort select="events_played" order="descending" data-type="number"></xsl:sort>
<xsl:text>|</xsl:text><xsl:value-of select="name" /><xsl:text>|</xsl:text><xsl:value-of select="type" /><xsl:text>|</xsl:text><xsl:value-of select="date_of_birth" /><xsl:text>|</xsl:text><xsl:value-of select="nationality" /><xsl:text>|</xsl:text><xsl:value-of select="events_played" /><xsl:text>|</xsl:text><xsl:text>&#10;</xsl:text>
</xsl:for-each>
</xsl:for-each>
</xsl:template>
<xsl:template match="//error">
<xsl:value-of select="."/>
</xsl:template>
</xsl:stylesheet>