<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:foo="http://whatever">

  <xsl:output method="text"/>

  <xsl:variable name="delimiters"> ,."!?()</xsl:variable>

  <xsl:function name="foo:substrWordBoundary">
    <xsl:param name="inString"/>
    <xsl:param name="length"/>
    <xsl:choose>
      <xsl:when test="$length <= 0">
        <xsl:value-of select="$inString"/>
      </xsl:when>
      <xsl:when test="string-length($inString) <= $length">
        <xsl:value-of select="$inString"/>
      </xsl:when>
      <xsl:when test="contains($delimiters,substring($inString,$length + 1,1))">
        <xsl:value-of select="substring($inString,1,$length)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="foo:substrWordBoundary($inString,$length - 1)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:template match="/">
20 chars: <xsl:value-of select="foo:substrWordBoundary('This is a test.Right? Yes.',20)"/>
10 chars: <xsl:value-of select="foo:substrWordBoundary('This is a test.Right? Yes.',19)"/>
already short enough: <xsl:value-of select="foo:substrWordBoundary('catatonic',15)"/>
no boundaries: <xsl:value-of select="foo:substrWordBoundary('catatonic',5)"/>
  </xsl:template>

</xsl:stylesheet>
