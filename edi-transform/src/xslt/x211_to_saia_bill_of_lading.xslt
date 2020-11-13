<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:l="urn:xlate.io:staedi:names:loops"
  xmlns:s="urn:xlate.io:staedi:names:segments" xmlns:c="urn:xlate.io:staedi:names:composites" xmlns:e="urn:xlate.io:staedi:names:elements"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  exclude-result-prefixes="l s c e fn">

  <xsl:output omit-xml-declaration="yes" indent="yes"/>

  <!-- See https://www.saiasecure.com/webservice/bol/Create.asp for documentation of output format. -->

  <xsl:template match="/">
    <xsl:apply-templates select="l:INTERCHANGE/l:GROUP/l:TRANSACTION[s:ST/e:ST01 = '211']"/>
  </xsl:template>

  <xsl:template match="l:INTERCHANGE/l:GROUP/l:TRANSACTION">
    <BillOfLading>
      <TestMode>
        <xsl:choose>
          <xsl:when test="../../s:ISA/e:ISA15 = 'P'">
            <xsl:text>N</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Y</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </TestMode>

      <ShipmentDate>
        <xsl:value-of select="substring(s:BOL/e:BOL04, 1, 4)"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="substring(s:BOL/e:BOL04, 5, 2)"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="substring(s:BOL/e:BOL04, 7, 2)"/>
      </ShipmentDate>

      <BillingTerms>
        <xsl:choose>
          <xsl:when test="s:BOL/e:BOL02 = 'CC'">
            <xsl:text>Collect</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Prepaid</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </BillingTerms>

      <BLNumber>
        <xsl:value-of select="s:BOL/e:BOL03"/>
      </BLNumber>

      <StoreNumber>
        <xsl:value-of select="s:L11[e:L1102 = 'ST']/e:L1101"/>
      </StoreNumber>

      <TrailerNumber>
        <xsl:value-of select="s:MS2/e:MS202"/>
      </TrailerNumber>

      <DepartmentNumber>
        <xsl:value-of select="s:L11[e:L1102 = 'DP']/e:L1101"/>
      </DepartmentNumber>

      <xsl:if test="l:_0200/l:_0230/s:G61[e:G6103 = 'TE']/e:G6104[1] != ''">
        <EmergencyPhone>
          <xsl:value-of select="l:_0200/l:_0230/s:G61[e:G6103 = 'TE']/e:G6104[1]"/>
        </EmergencyPhone>
      </xsl:if>

      <WeightUnits>
        <xsl:choose>
          <xsl:when test="//e:AT204[1] = 'K'">
            <xsl:text>KGS</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>LBS</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </WeightUnits>

      <Shipper>
        <xsl:apply-templates select="l:_0100[s:N1/e:N101 = 'SH']"/>
      </Shipper>

      <xsl:if test="l:_0100[s:N1/e:N101 = 'CN']/s:N1/e:N101 != ''">
        <Consignee>
          <xsl:apply-templates select="l:_0100[s:N1/e:N101 = 'CN']"/>
        </Consignee>
      </xsl:if>

      <xsl:if test="l:_0100[s:N1/e:N101 = 'BT']/s:N1/e:N101 != ''">
        <BillTo>
          <xsl:apply-templates select="l:_0100[s:N1/e:N101 = 'BT']"/>
        </BillTo>
      </xsl:if>

      <Details>
        <xsl:apply-templates select="l:_0200"/>
      </Details>
    </BillOfLading>
  </xsl:template>

  <!-- Loop 0100: Name/Contact Information -->
  <xsl:template match="l:_0100">
    <xsl:if test="s:N1/e:N104 != ''">
      <AccountNumber>
        <xsl:value-of select="s:N1/e:N104"/>
      </AccountNumber>
    </xsl:if>

    <ContactName>
      <xsl:choose>
        <xsl:when test="s:G61/e:G6102 != ''">
          <xsl:value-of select="s:G61/e:G6102"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="s:N1/e:N102"/>
        </xsl:otherwise>
      </xsl:choose>
    </ContactName>

    <Address1>
      <xsl:value-of select="s:N3/e:N301"/>
    </Address1>

    <xsl:if test="s:N3/e:N302 != ''">
      <Address2>
        <xsl:value-of select="s:N3/e:N302"/>
      </Address2>
    </xsl:if>

    <City>
      <xsl:value-of select="s:N4/e:N401"/>
    </City>

    <State>
      <xsl:value-of select="s:N4/e:N402"/>
    </State>

    <Zipcode>
      <xsl:value-of select="s:N4/e:N403"/>
    </Zipcode>
  </xsl:template>

  <!-- Loop 0200: Bill of Lading Line Items -->
  <xsl:template match="l:_0200">
    <xsl:for-each select="l:_0210/s:SPO[e:SPO01 != ''] | l:_0220/s:SPO[e:SPO01 != '']">
      <DetailItem>
        <PONumber>
          <xsl:value-of select="e:SPO01"/>
        </PONumber>
        <Package>
          <xsl:choose>
            <xsl:when test="e:SPO03 = 'PL'">
              <xsl:text>PT</xsl:text>
            </xsl:when>
            <xsl:when test="e:SPO03 = 'SV'">
              <xsl:text>SK</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="e:SPO03"/>
            </xsl:otherwise>
          </xsl:choose>
        </Package>
        <Pieces>
          <xsl:value-of select="e:SPO04"/>
        </Pieces>
        <Weight>
          <xsl:value-of select="e:SPO06"/>
        </Weight>

        <xsl:choose>
          <xsl:when test="../../l:_0230/s:G61/e:G6101[1] = 'HM'">
            <xsl:apply-templates select="../../l:_0230"/>
          </xsl:when>
          <xsl:otherwise>
            <Hazardous>N</Hazardous>
          </xsl:otherwise>
        </xsl:choose>

        <Description>
          <xsl:choose>
            <xsl:when test="../../l:_0230/l:_0231/s:LH3/e:LH301 != ''">
              <xsl:value-of select="../../l:_0230/l:_0231/s:LH3/e:LH301"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="../../s:AT4/e:AT401"/>
            </xsl:otherwise>
          </xsl:choose>
        </Description>
      </DetailItem>
    </xsl:for-each>
  </xsl:template>

  <!-- Loop 0230: Hazardous Materials -->
  <xsl:template match="l:_0230">
    <Hazardous>Y</Hazardous>
    <UNHazmatID>
      <xsl:value-of select="l:_0231/s:LH1/e:LH103"/>
    </UNHazmatID>

    <xsl:if test="l:_0231/s:LH1/e:LH110 != ''">
      <UNPackageGroup>
        <xsl:value-of select="l:_0231/s:LH1/e:LH110"/>
      </UNPackageGroup>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
