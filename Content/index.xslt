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

  <xsl:template name="substring-after-last">
    <xsl:param name="string1" select="''" />
    <xsl:param name="string2" select="''" />

    <xsl:if test="$string1 != '' and $string2 != ''">
      <xsl:variable name="tail" select="substring-after($string1, $string2)" />
      <xsl:choose>
        <xsl:when test="contains($tail, $string2)">
          <xsl:call-template name="substring-after-last">
            <xsl:with-param name="string1" select="$tail" />
            <xsl:with-param name="string2" select="$string2" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$tail"/>
        </xsl:otherwise>

      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="/">
    <!--<xsl:variable name="outputString" select="rdf:RDF/rdf:Description/c:document" />-->
    <div class="EntitiesBar">
      Entities:
      <br />
      <xsl:for-each select="rdf:RDF/rdf:Description">
        <xsl:if test="((rdf:type/@rdf:resource!='') and (c:name!=''))">
          <span class="EntityCategory">
              <xsl:call-template name="substring-after-last">
                <xsl:with-param name="string1" select="rdf:type/@rdf:resource"/>
                <xsl:with-param name="string2" select="'/'"/>
              </xsl:call-template>
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