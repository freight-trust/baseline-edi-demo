# Transformations for X12 211 & 810
Transformations for X12 211 (Motor Carrier Bill of Lading) and 810 (Invoice). Makes use of Fresno EDI server, example is running on `ec2-52-53-248-65.us-west-1.compute.amazonaws.com`, port `8080`.

Index:
* samples: test files
* src/edischema: X12 version 004010 schemas for transactions 211 (Motor Carrier Bill of Lading) and 810 (Invoice)
* src/xslt: XSL Transforms

Usage:

```bash
curl \
  --data-binary @samples/test211_freight_not_palletized.edi \
  -H 'Expect:' \
  -H 'Content-Type:application/EDI-X12' \
  -H 'Accept:application/xml'\
  ec2-52-53-248-65.us-west-1.compute.amazonaws.com:8080/transactions/translator \
  | xsltproc src/xslt/x211_to_saia_bill_of_lading.xslt -
```

Sample input to above command:
```
ISA*01*0000000000*01*0000000000*ZZ*ABCDEFGHIJKLMNO*ZZ*123456789012345*200902*0616*U*00401*000000002*0*T*>
GS*BL*99999999999*888888888888*20200902*0615*1*X*004010
ST*211*000010001
BOL*RDWY*PP*12345*19970501**1231234561
B2A*00
MS2*RDWY*123456
L11*STORE05*ST
L11*DEPT03*DP
N1*SH*SHIPPER NAME*93*123456789
N3*9999 SHIPPER STREET*ADDITIONAL ADDRESS LINE
N4*SHIPPER CITY*ST*00000
N1*CN*CONSIGNEE NAME
N3*9999 CONSIGNEE STREET*ADDITIONAL ADDRESS LINE
N4*CONSIGNEE CITY*ST*99999
G61*DC*DELIVERY CONTACT NAME*TE*(888)999-9999
AT1*1
L11*999*AE
AT4*COMMODITY 1
AT2*5*CTN*N*L*210****999999-01
MAN*GM*00000858050113093100
MAN*GM*00000858050113093101
MAN*GM*00000858050113093102
MAN*GM*00000858050113093103
MAN*GM*00000858050113093104
SPO*123*1144*CT*2*L*84
SPO*456*1144*CT*3*L*126
SE*23*000010001
GE*1*1
IEA*1*000000002
```
Result:
```xml
<BillOfLading>
  <TestMode>Y</TestMode>
  <ShipmentDate>1997-05-01</ShipmentDate>
  <BillingTerms>Prepaid</BillingTerms>
  <BLNumber>12345</BLNumber>
  <StoreNumber>STORE05</StoreNumber>
  <TrailerNumber>123456</TrailerNumber>
  <DepartmentNumber>DEPT03</DepartmentNumber>
  <WeightUnits>LBS</WeightUnits>
  <Shipper>
    <AccountNumber>123456789</AccountNumber>
    <ContactName>SHIPPER NAME</ContactName>
    <Address1>9999 SHIPPER STREET</Address1>
    <Address2>ADDITIONAL ADDRESS LINE</Address2>
    <City>SHIPPER CITY</City>
    <State>ST</State>
    <Zipcode>00000</Zipcode>
  </Shipper>
  <Consignee>
    <ContactName>DELIVERY CONTACT NAME</ContactName>
    <Address1>9999 CONSIGNEE STREET</Address1>
    <Address2>ADDITIONAL ADDRESS LINE</Address2>
    <City>CONSIGNEE CITY</City>
    <State>ST</State>
    <Zipcode>99999</Zipcode>
  </Consignee>
  <Details>
    <DetailItem>
      <PONumber>123</PONumber>
      <Package>CT</Package>
      <Pieces>2</Pieces>
      <Weight>84</Weight>
      <Hazardous>N</Hazardous>
      <Description>COMMODITY 1</Description>
    </DetailItem>
    <DetailItem>
      <PONumber>456</PONumber>
      <Package>CT</Package>
      <Pieces>3</Pieces>
      <Weight>126</Weight>
      <Hazardous>N</Hazardous>
      <Description>COMMODITY 1</Description>
    </DetailItem>
  </Details>
</BillOfLading>
```
Intermediate XML (output of X12-to-XML translation, input to XSLT):
```xml
<l:INTERCHANGE xmlns:l="urn:xlate.io:staedi:names:loops" xmlns:s="urn:xlate.io:staedi:names:segments" xmlns:c="urn:xlate.io:staedi:names:composites" xmlns:e="urn:xlate.io:staedi:names:elements">
  <s:ISA>
    <e:ISA01>01</e:ISA01>
    <e:ISA02>0000000000</e:ISA02>
    <e:ISA03>01</e:ISA03>
    <e:ISA04>0000000000</e:ISA04>
    <e:ISA05>ZZ</e:ISA05>
    <e:ISA06>ABCDEFGHIJKLMNO</e:ISA06>
    <e:ISA07>ZZ</e:ISA07>
    <e:ISA08>123456789012345</e:ISA08>
    <e:ISA09>200902</e:ISA09>
    <e:ISA10>0616</e:ISA10>
    <e:ISA11>U</e:ISA11>
    <e:ISA12>00401</e:ISA12>
    <e:ISA13>000000002</e:ISA13>
    <e:ISA14>0</e:ISA14>
    <e:ISA15>T</e:ISA15>
    <e:ISA16>&gt;</e:ISA16>
  </s:ISA>
  <l:GROUP>
    <s:GS>
      <e:GS01>BL</e:GS01>
      <e:GS02>99999999999</e:GS02>
      <e:GS03>888888888888</e:GS03>
      <e:GS04>20200902</e:GS04>
      <e:GS05>0615</e:GS05>
      <e:GS06>1</e:GS06>
      <e:GS07>X</e:GS07>
      <e:GS08>004010</e:GS08>
    </s:GS>
    <l:TRANSACTION>
      <s:ST>
        <e:ST01>211</e:ST01>
        <e:ST02>000010001</e:ST02>
      </s:ST>
      <s:BOL>
        <e:BOL01>RDWY</e:BOL01>
        <e:BOL02>PP</e:BOL02>
        <e:BOL03>12345</e:BOL03>
        <e:BOL04>19970501</e:BOL04>
        <e:BOL05/>
        <e:BOL06>1231234561</e:BOL06>
      </s:BOL>
      <s:B2A>
        <e:B2A01>00</e:B2A01>
      </s:B2A>
      <s:MS2>
        <e:MS201>RDWY</e:MS201>
        <e:MS202>123456</e:MS202>
      </s:MS2>
      <s:L11>
        <e:L1101>STORE05</e:L1101>
        <e:L1102>ST</e:L1102>
      </s:L11>
      <s:L11>
        <e:L1101>DEPT03</e:L1101>
        <e:L1102>DP</e:L1102>
      </s:L11>
      <l:_0100>
        <s:N1>
          <e:N101>SH</e:N101>
          <e:N102>SHIPPER NAME</e:N102>
          <e:N103>93</e:N103>
          <e:N104>123456789</e:N104>
        </s:N1>
        <s:N3>
          <e:N301>9999 SHIPPER STREET</e:N301>
          <e:N302>ADDITIONAL ADDRESS LINE</e:N302>
        </s:N3>
        <s:N4>
          <e:N401>SHIPPER CITY</e:N401>
          <e:N402>ST</e:N402>
          <e:N403>00000</e:N403>
        </s:N4>
      </l:_0100>
      <l:_0100>
        <s:N1>
          <e:N101>CN</e:N101>
          <e:N102>CONSIGNEE NAME</e:N102>
        </s:N1>
        <s:N3>
          <e:N301>9999 CONSIGNEE STREET</e:N301>
          <e:N302>ADDITIONAL ADDRESS LINE</e:N302>
        </s:N3>
        <s:N4>
          <e:N401>CONSIGNEE CITY</e:N401>
          <e:N402>ST</e:N402>
          <e:N403>99999</e:N403>
        </s:N4>
        <s:G61>
          <e:G6101>DC</e:G6101>
          <e:G6102>DELIVERY CONTACT NAME</e:G6102>
          <e:G6103>TE</e:G6103>
          <e:G6104>(888)999-9999</e:G6104>
        </s:G61>
      </l:_0100>
      <l:_0200>
        <s:AT1>
          <e:AT101>1</e:AT101>
        </s:AT1>
        <s:L11>
          <e:L1101>999</e:L1101>
          <e:L1102>AE</e:L1102>
        </s:L11>
        <s:AT4>
          <e:AT401>COMMODITY 1</e:AT401>
        </s:AT4>
        <l:_0210>
          <s:AT2>
            <e:AT201>5</e:AT201>
            <e:AT202>CTN</e:AT202>
            <e:AT203>N</e:AT203>
            <e:AT204>L</e:AT204>
            <e:AT205>210</e:AT205>
            <e:AT206/>
            <e:AT207/>
            <e:AT208/>
            <e:AT209>999999-01</e:AT209>
          </s:AT2>
          <s:MAN>
            <e:MAN01>GM</e:MAN01>
            <e:MAN02>00000858050113093100</e:MAN02>
          </s:MAN>
          <s:MAN>
            <e:MAN01>GM</e:MAN01>
            <e:MAN02>00000858050113093101</e:MAN02>
          </s:MAN>
          <s:MAN>
            <e:MAN01>GM</e:MAN01>
            <e:MAN02>00000858050113093102</e:MAN02>
          </s:MAN>
          <s:MAN>
            <e:MAN01>GM</e:MAN01>
            <e:MAN02>00000858050113093103</e:MAN02>
          </s:MAN>
          <s:MAN>
            <e:MAN01>GM</e:MAN01>
            <e:MAN02>00000858050113093104</e:MAN02>
          </s:MAN>
          <s:SPO>
            <e:SPO01>123</e:SPO01>
            <e:SPO02>1144</e:SPO02>
            <e:SPO03>CT</e:SPO03>
            <e:SPO04>2</e:SPO04>
            <e:SPO05>L</e:SPO05>
            <e:SPO06>84</e:SPO06>
          </s:SPO>
          <s:SPO>
            <e:SPO01>456</e:SPO01>
            <e:SPO02>1144</e:SPO02>
            <e:SPO03>CT</e:SPO03>
            <e:SPO04>3</e:SPO04>
            <e:SPO05>L</e:SPO05>
            <e:SPO06>126</e:SPO06>
          </s:SPO>
        </l:_0210>
      </l:_0200>
      <s:SE>
        <e:SE01>23</e:SE01>
        <e:SE02>000010001</e:SE02>
      </s:SE>
    </l:TRANSACTION>
    <s:GE>
      <e:GE01>1</e:GE01>
      <e:GE02>1</e:GE02>
    </s:GE>
  </l:GROUP>
  <s:IEA>
    <e:IEA01>1</e:IEA01>
    <e:IEA02>000000002</e:IEA02>
  </s:IEA>
</l:INTERCHANGE>
```