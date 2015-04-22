<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:c="http://s.opencalais.com/1/pred/">
  <xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="popup_text"/>
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:choose>
          <xsl:when test="contains($popup_text, 'Person')">
            <xsl:value-of select="'&lt;span class=&quot;mark&quot; style=&quot;border-bottom: double #8000FF;&quot;&gt;'"/>
          </xsl:when>
          <xsl:when test="contains($popup_text, 'Country')">
            <xsl:value-of select="'&lt;span class=&quot;mark&quot; style=&quot;border-bottom: double #AEFE00;&quot;&gt;'"/>
          </xsl:when>
          <xsl:when test="contains($popup_text, 'Continent')">
            <xsl:value-of select="'&lt;span class=&quot;mark&quot; style=&quot;border-bottom: double #FF0000;&quot;&gt;'"/>
          </xsl:when>
          <xsl:when test="contains($popup_text, 'Organization') or contains($popup_text, 'Company')">
            <xsl:value-of select="'&lt;span class=&quot;mark&quot; style=&quot;border-bottom: double #FE00D6;&quot;&gt;'"/>
          </xsl:when>
          <xsl:when test="contains($popup_text, 'Province Or State') or contains($popup_text, 'City')">
            <xsl:value-of select="'&lt;span class=&quot;mark&quot; style=&quot;border-bottom: double #00FE64;&quot;&gt;'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'&lt;span class=&quot;mark&quot;&gt;'"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="concat(concat(concat(concat(
                      $replace, '&lt;span&gt;&lt;img class=&quot;callout&quot; src=&quot;Content/callout.gif&quot; /&gt;&lt;strong&gt;'), 
                      $popup_text), 
                      '&lt;/strong&gt;&lt;/span&gt;'),
                      '&lt;/span&gt;')"/>
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text"
          select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="popup_text" select="$popup_text"/>
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

  <xsl:template name="replace-cnames-with-underscore">
    <xsl:param name="text" select="''" />
    <xsl:param name="cnames" select="''" />
    <xsl:param name="beforeRes" select="''"/>
    <xsl:param name="resources" select="''"/>
    <xsl:if test="$text != '' and $cnames != ''">
      <xsl:choose>
        <xsl:when test="contains($cnames, '.') and contains(substring-after($cnames, '.'), '.')">
          <xsl:variable name="currName" select="substring-before($cnames, '.')"/>
          <xsl:variable name="currRes" select="substring-before($resources, '.')"/>
          <xsl:choose>
            <xsl:when test="contains($beforeRes, $currName)">
              <xsl:call-template name="replace-cnames-with-underscore">
                <xsl:with-param name="text" select="$text"/>
                <xsl:with-param name="cnames" select="substring-after($cnames, '.')"/>
                <xsl:with-param name="beforeRes" select="$beforeRes"/>
                <xsl:with-param name="resources" select="substring-after($resources, '.')"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="result">
                <xsl:call-template name="string-replace-all">
                  <xsl:with-param name="text" select="$text"/>
                  <xsl:with-param name="replace" select="$currName"/>
                  <xsl:with-param name="popup_text" select="$currRes"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:call-template name="replace-cnames-with-underscore">
                <xsl:with-param name="text" select="$result"/>
                <xsl:with-param name="cnames" select="substring-after($cnames, '.')"/>
                <xsl:with-param name="beforeRes" select="concat($beforeRes, $currName)"/>
                <xsl:with-param name="resources" select="substring-after($resources, '.')"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="currName" select="substring-before($cnames, '.')"/>
          <xsl:variable name="currRes" select="substring-before($resources, '.')"/>
          <xsl:choose>
            <xsl:when test="contains($beforeRes, $currName)">
              <xsl:value-of select="$text" disable-output-escaping="yes"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="final">
                <xsl:call-template name="string-replace-all">
                  <xsl:with-param name="text" select="$text"/>
                  <xsl:with-param name="replace" select="$currName"/>
                  <xsl:with-param name="popup_text" select="$currRes"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:value-of select="$final" disable-output-escaping="yes"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="/">
    <div class="EntitiesBar">
      Entities:
      <br />
      <xsl:for-each select="rdf:RDF/rdf:Description">
        <xsl:if test="((rdf:type/@rdf:resource!='') and (c:name!=''))">
          <xsl:variable name="res_substring">
            <xsl:call-template name="substring-after-last">
              <xsl:with-param name="string1" select="rdf:type/@rdf:resource"/>
              <xsl:with-param name="string2" select="'/'"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="contains($res_substring, 'Person')">
              <span class="EntityCategory" style="border-bottom: double #8000FF;">
                <xsl:value-of select="$res_substring"/>
              </span>
            </xsl:when>
            <xsl:when test="contains($res_substring, 'Country')">
              <span class="EntityCategory" style="border-bottom: double #AEFE00;">
                <xsl:value-of select="$res_substring"/>
              </span>
            </xsl:when>
            <xsl:when test="contains($res_substring, 'Continent')">
              <span class="EntityCategory" style="border-bottom: double #FF0000;">
                <xsl:value-of select="$res_substring"/>
              </span>
            </xsl:when>
            <xsl:when test="contains($res_substring, 'Organization') or contains($res_substring, 'Company')">
              <span class="EntityCategory" style="border-bottom: double #FE00D6;">
                <xsl:value-of select="$res_substring"/>
              </span>
            </xsl:when>
            <xsl:when test="contains($res_substring, 'Province Or State') or contains($res_substring, 'City')">
              <span class="EntityCategory" style="border-bottom: double #00FE64;">
                <xsl:value-of select="$res_substring"/>
              </span>
            </xsl:when>
            <xsl:otherwise>
              <span class="EntityCategory">
                <xsl:value-of select="$res_substring"/>
              </span>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:value-of select="c:name"/>
          <br/>
        </xsl:if>
      </xsl:for-each>
    </div>
    <div id="results">
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
      <xsl:variable name="cnames">
        <xsl:for-each select="rdf:RDF/rdf:Description">
          <xsl:if test="((rdf:type/@rdf:resource!='') and (c:name!=''))">
            <xsl:value-of select="c:name"/>
            <xsl:value-of select="'.'"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="resources">
        <xsl:for-each select="rdf:RDF/rdf:Description">
          <xsl:if test="((rdf:type/@rdf:resource!='') and (c:name!=''))">
            <xsl:call-template name="substring-after-last">
              <xsl:with-param name="string1" select="rdf:type/@rdf:resource"/>
              <xsl:with-param name="string2" select="'/'"/>
            </xsl:call-template>
            <xsl:value-of select="'.'"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:call-template name="replace-cnames-with-underscore">
        <xsl:with-param name="text" select="rdf:RDF/rdf:Description/c:document"/>
        <xsl:with-param name="cnames" select="$cnames"/>
        <xsl:with-param name="beforeRes" select="''"/>
        <xsl:with-param name="resources" select="$resources"/>
      </xsl:call-template>
    </div>
  </xsl:template>
</xsl:stylesheet>