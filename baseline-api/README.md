# Attestation API



## Overivew

Merkle-tree appending for attestation purposes smart contract API

## Usage

**API Documents** [freight-trust.github.io/attestation-api/](https://freight-trust.github.io/attestation-api/)

$ openssl rand -hex 20
> 140206669a273fd4b80bc3b71273e262e511b1e7

```bash
curl -X POST "http://35.162.43.79:3000/document" -H  \
"accept: application/json" -H \
"Content-Type: application/json" -d "{  \"hash\": \"140206669a273fd4b80bc3b71273e262e511b1e7\",  \"description\": \"This is first version of the document\"}"
```

> POST /document 200 7921.092 ms - 204

> {"referenceId":"0xac319ad74fde0355987cc91da9d8dd9c76ff6e804230d84e053ba732cb7bcf4d","documentId":"136","versionId":"0","transactionId":"0xdf4f7497ec5212571df2b65b3830e035977c96a81e0305edd3bdabe3f5baf80b"}

## License 

Copyright 2020 FreightTrust and Clearing
