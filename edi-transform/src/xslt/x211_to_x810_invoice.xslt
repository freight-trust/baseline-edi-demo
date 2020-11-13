<?xml version="1.0" encoding="UTF-8"?>
<!--

  Requires XSLT 2.0! See saxonb-xslt command

 -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:l="urn:xlate.io:staedi:names:loops"
  xmlns:s="urn:xlate.io:staedi:names:segments" xmlns:c="urn:xlate.io:staedi:names:composites" xmlns:e="urn:xlate.io:staedi:names:elements"
  xmlns:fn="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="fn">

  <xsl:output omit-xml-declaration="yes" indent="yes"/>

  <xsl:template match="/">
    <l:INTERCHANGE>
      <s:ISA>
        <e:ISA01/>
        <e:ISA02/>
        <e:ISA03/>
        <e:ISA04/>
        <e:ISA05>
          <xsl:value-of select="l:INTERCHANGE/s:ISA/e:ISA05"/>
        </e:ISA05>
        <e:ISA06>
          <xsl:value-of select="l:INTERCHANGE/s:ISA/e:ISA06"/>
        </e:ISA06>
        <e:ISA07>
          <xsl:value-of select="l:INTERCHANGE/s:ISA/e:ISA07"/>
        </e:ISA07>
        <e:ISA08>
          <xsl:value-of select="l:INTERCHANGE/s:ISA/e:ISA08"/>
        </e:ISA08>
      </s:ISA>
      <l:GROUP>
        <s:GS>
          <e:GS01>IN</e:GS01>
          <e:GS02>
            <xsl:value-of select="l:INTERCHANGE/l:GROUP/s:GS/e:GS02"/>
          </e:GS02>
          <e:GS03>
            <xsl:value-of select="l:INTERCHANGE/l:GROUP/s:GS/e:GS03"/>
          </e:GS03>
        </s:GS>
        <xsl:apply-templates select="l:INTERCHANGE/l:GROUP/l:TRANSACTION[s:ST/e:ST01 = '211']"/>
        <s:GE/>
      </l:GROUP>
      <s:IEA/>
    </l:INTERCHANGE>
  </xsl:template>

  <xsl:template match="l:INTERCHANGE/l:GROUP/l:TRANSACTION">
    <xsl:variable name="current-date">
      <xsl:value-of select="current-date()"/>
    </xsl:variable>

    <l:TRANSACTION>
      <s:ST>
        <e:ST01>810</e:ST01>
      </s:ST>
      <s:BIG>
        <!-- Invoice Date -->
        <e:BIG01>
          <xsl:value-of select="substring($current-date, 1, 4)"/>
          <xsl:value-of select="substring($current-date, 6, 2)"/>
          <xsl:value-of select="substring($current-date, 9, 2)"/>
        </e:BIG01>
        <!-- Invoice Number -->
        <e:BIG02>
          <!-- Unknown (Mandatory) -->
          <xsl:text>0</xsl:text>
        </e:BIG02>
        <!-- Date -->
        <e:BIG03>
          <xsl:value-of select="substring($current-date, 1, 4)"/>
          <xsl:value-of select="substring($current-date, 6, 2)"/>
          <xsl:value-of select="substring($current-date, 9, 2)"/>
        </e:BIG03>
        <!-- Purchase Order Number -->
        <e:BIG04><!-- Unknown -->
        </e:BIG04>
        <e:BIG07><!-- Transaction Type Code (FB Final Bill)-->
          <xsl:text>FB</xsl:text>
        </e:BIG07>
        <e:BIG08><!-- Transaction Set Purpose Code (00 Original) -->
          <xsl:text>00</xsl:text>
        </e:BIG08>
      </s:BIG>

      <s:REF>
        <!-- Bill of Lading Number -->
        <e:REF01>BM</e:REF01>
        <e:REF02>
          <xsl:value-of select="s:BOL/e:BOL03"/>
        </e:REF02>
      </s:REF>

      <xsl:if test="l:_0100[s:N1/e:N101 = 'SH']/s:N1/e:N101 != ''">
        <!-- Map Shipper to Remit-To -->
        <xsl:apply-templates select="l:_0100[s:N1/e:N101 = 'SH']">
          <xsl:with-param name="N101">
            <xsl:text>RI</xsl:text>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:if>

      <xsl:choose>
        <!-- Map Bill-To to Bill-To -->
        <xsl:when test="l:_0100[s:N1/e:N101 = 'BT']/s:N1/e:N101 != ''">
          <xsl:apply-templates select="l:_0100[s:N1/e:N101 = 'BT']">
            <xsl:with-param name="N101">
              <xsl:text>BT</xsl:text>
            </xsl:with-param>
          </xsl:apply-templates>
        </xsl:when>

        <!-- Map Consignee to Bill-To -->
        <xsl:when test="l:_0100[s:N1/e:N101 = 'CN']/s:N1/e:N101 != ''">
          <xsl:apply-templates select="l:_0100[s:N1/e:N101 = 'CN']">
            <xsl:with-param name="N101">
              <xsl:text>BT</xsl:text>
            </xsl:with-param>
          </xsl:apply-templates>
        </xsl:when>
      </xsl:choose>

      <xsl:if test="s:G62[e:G6201 = '86']/e:G6202 != ''">
        <s:DTM>
          <!-- Map 211/'Actual Pickup Date' to 810/'Shipment Date' -->
          <e:DTM01>011</e:DTM01>
          <e:DTM02>
            <xsl:value-of select="s:G62/s:G6202"/>
          </e:DTM02>
          <e:DTM03>
            <xsl:value-of select="s:G62/s:G6203"/>
          </e:DTM03>
        </s:DTM>
      </xsl:if>

      <xsl:apply-templates select="l:_0200"/>

      <s:TDS>
        <!-- Total Monetary Value Summary -->
        <e:TDS01>0</e:TDS01>
      </s:TDS>

      <s:CAD>
        <!-- Carrier Details -->
        <e:CAD01>0</e:CAD01>
      </s:CAD>

      <s:CTT>
        <!-- Transaction Totals -->
        <e:CTT01>
          <!-- Count of IT1 segments -->
          <xsl:value-of select="count(l:_0200/l:_0210/s:SPO | l:_0200/l:_0220/s:SPO)"/>
        </e:CTT01>
        <e:CTT02>
          <!-- Total quantity (sum of IT102) -->
          <xsl:value-of select="sum(l:_0200/l:_0210/s:SPO/e:SPO04) + sum(l:_0200/l:_0220/s:SPO/e:SPO04)"/>
        </e:CTT02>
        <!-- Total weight -->
        <e:CTT03></e:CTT03>
        <!-- Weight units -->
        <e:CTT04></e:CTT04>
      </s:CTT>

      <s:SE/>
    </l:TRANSACTION>
  </xsl:template>

  <!-- Loop 0100: Name/Contact Information -->
  <xsl:template match="l:_0100">
    <xsl:param name="N101"/>

    <l:L0001>
      <s:N1>
        <e:N101>
          <xsl:value-of select="$N101"/>
        </e:N101>
        <e:N102>
          <xsl:value-of select="s:N1/e:N102"/>
        </e:N102>
        <e:N103>
          <xsl:value-of select="s:N1/e:N103"/>
        </e:N103>
        <e:N104>
          <xsl:value-of select="s:N1/e:N104"/>
        </e:N104>
      </s:N1>

      <xsl:if test="s:N3/e:N301 != ''">
        <s:N3>
          <e:N301>
            <xsl:value-of select="s:N3/e:N301"/>
          </e:N301>
          <e:N302>
            <xsl:value-of select="s:N3/e:N302"/>
          </e:N302>
        </s:N3>
      </xsl:if>

      <xsl:if test="s:N4/e:N401 != ''">
        <s:N4>
          <e:N401>
            <xsl:value-of select="s:N4/e:N401"/>
          </e:N401>
          <e:N402>
            <xsl:value-of select="s:N4/e:N402"/>
          </e:N402>
          <e:N403>
            <xsl:value-of select="s:N4/e:N403"/>
          </e:N403>
          <e:N404>
            <xsl:value-of select="s:N4/e:N404"/>
          </e:N404>
        </s:N4>
      </xsl:if>
    </l:L0001>
  </xsl:template>

  <!-- Loop 0200: Bill of Lading Line Items -->
  <xsl:template match="l:_0200">
    <xsl:for-each select="l:_0210/s:SPO | l:_0220/s:SPO">
      <l:L0006>
        <s:IT1>
          <e:IT101>
            <!-- Assigned identification -->
            <xsl:value-of select="position()"/>
          </e:IT101>
          <e:IT102>
            <!-- Quantity Invoiced -->
            <xsl:value-of select="e:SPO04"/>
          </e:IT102>
          <e:IT103>
            <!-- Units -->
            <xsl:value-of select="e:SPO03"/>
          </e:IT103>
          <e:IT104>
            <!-- Unit Price -->
            <xsl:text>0</xsl:text>
          </e:IT104>
        </s:IT1>

        <s:PID>
          <e:PID01>F</e:PID01>
          <e:PID05>
            <xsl:choose>
              <xsl:when test="../../l:_0230/l:_0231/s:LH3/e:LH301 != ''">
                <xsl:value-of select="../../l:_0230/l:_0231/s:LH3/e:LH301"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="../../s:AT4/e:AT401"/>
              </xsl:otherwise>
            </xsl:choose>
          </e:PID05>
        </s:PID>
      </l:L0006>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
