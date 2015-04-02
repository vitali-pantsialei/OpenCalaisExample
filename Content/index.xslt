﻿<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
                xmlns:c="http://s.opencalais.com/1/pred/">
    <xsl:template match="/">
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