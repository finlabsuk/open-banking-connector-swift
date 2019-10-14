# Open Banking Payment Initiation (OBPI) Api V3.1.1 Types

This module contains API types generated from [UK Open Banking Payment Initiation API v3.1.2](https://raw.githubusercontent.com/OpenBankingUK/read-write-api-specs/v3.1.1/dist/payment-initiation-swagger.json) and conformances to ensure they meet requirements specified in [OBPI Type Requirements]()

## Steps to follow to generate this module:

### 1. Generate client code using Swagger Codegen

```bash
curl -X POST -H "content-type:application/json" -d '{"swaggerUrl": "https://raw.githubusercontent.com/OpenBankingUK/read-write-api-specs/v3.1.1/dist/payment-initiation-swagger.json"}' https://generator.swagger.io/api/gen/clients/swift4
```

This should produce a link you can use to download the resulting client code.
