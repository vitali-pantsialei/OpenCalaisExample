<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:c="http://s.opencalais.com/1/pred/">
  <xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:value-of select="$by" />
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text"
          select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="by" select="$by" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/">
    <!--<xsl:variable name="outputString" select="rdf:RDF/rdf:Description/c:document" />-->
    <div class="EntitiesBar">
      Entities:
      <br />
      <xsl:for-each select="rdf:RDF/rdf:Description">
        <xsl:if test="((rdf:type/@rdf:resource!='') and (c:name!=''))">

          <!--<xsl:analyze-string select="rdf:type/@rdf:resource" regex="([A-Z])\w+">
            <xsl:matching-substring>
              <span class="EntityCategory">
                <xsl:value-of select="regex-group(1)" />
                <br />
              </span>
            </xsl:matching-substring>
          </xsl:analyze-string>-->
          
          <span class="EntityCategory">
            <xsl:value-of select="rdf:type/@rdf:resource" />
            <br />
          </span>
          <xsl:value-of select="c:name"/>
          <br/>
        </xsl:if>
      </xsl:for-each>
    </div>
    <hr/>
    <h2>Title</h2>
    <br/>
    <xsl:value-of select="rdf:RDF/rdf:Description/c:docTitle"/>
    <hr/>
    <h2>Date</h2>
    <br/>
    <xsl:value-of select="rdf:RDF/rdf:Description/c:docDate"/>
    <hr/>
    <h2>Body</h2>
    <br/>
    <xsl:value-of select="rdf:RDF/rdf:Description/c:document"/>
  </xsl:template>
</xsl:stylesheet>