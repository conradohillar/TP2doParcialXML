<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="//clients">
    <xsl:for-each select="client">
      <xsl:sort select="./name" order="ascending" />
      <xsl:value-of select="." />
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="/data/projects" />
  <xsl:template match="/data/persons" />
</xsl:stylesheet>
