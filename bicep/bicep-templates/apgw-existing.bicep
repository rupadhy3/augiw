$ cat appgw.bicep
param applicationGateways_IWAZUNPDAGW001_name string = 'IWAZUNPDAGW001'
param virtualNetworks_IWAZUNPD_MIP_NET_NPD_001_externalid string = '/subscriptions/00fe6969-c451-4979-b280-e4387d5ac43a/resourceGroups/IWAZU-MIP-NPD-SHARED-001/providers/Microsoft.Network/virtualNetworks/IWAZUNPD-MIP-NET-NPD-001'
param publicIPAddresses_IWAZUNPDAGW001_IP001_externalid string = '/subscriptions/00fe6969-c451-4979-b280-e4387d5ac43a/resourceGroups/IWAZU-MIP-NPD-SHARED-001/providers/Microsoft.Network/publicIPAddresses/IWAZUNPDAGW001-IP001'

resource applicationGateways_IWAZUNPDAGW001_name_resource 'Microsoft.Network/applicationGateways@2020-11-01' = {
  name: applicationGateways_IWAZUNPDAGW001_name
  location: 'northeurope'
  properties: {
    sku: {
      name: 'WAF_v2'
      tier: 'WAF_v2'
      capacity: 2
    }
    gatewayIPConfigurations: [
      {
        name: 'appGatewayFrontendIP'
        properties: {
          subnet: {
            id: '${virtualNetworks_IWAZUNPD_MIP_NET_NPD_001_externalid}/subnets/IWAZUNPD-MIP-SUB-005'
          }
        }
      }
    ]
    sslCertificates: [
      {
        name: 'Test'
        properties: {}
      }
      {
        name: 'test1'
        properties: {}
      }
      {
        name: 'mip-cert-test'
        properties: {}
      }
      {
        name: 'MIP-Custom-Cert'
        properties: {}
      }
      {
        name: 'MIP-Cert-SA'
        properties: {}
      }
      {
        name: 'gw-bundle'
        properties: {}
      }
      {
        name: 'starmiptest'
        properties: {}
      }
      {
        name: 'mikecert'
        properties: {}
      }
      {
        name: 'mikecert1'
        properties: {}
      }
    ]
    trustedRootCertificates: [
      {
        name: 'testcer'
        properties: {
          data: 'MIIDhjCCAm4CCQCzFjmS0xjHCzANBgkqhkiG9w0BAQsFADCBhDELMAkGA1UEBhMCRXUxEDAOBgNVBAgMB0lyZWxhbmQxDzANBgNVBAcMBkR1YmxpbjELMAkGA1UECgwCSVcxCzAJBgNVBAsMAklXMQswCQYDVQQDDAJJVzErMCkGCSqGSIb3DQEJARYcc3JhdmFuaS5kYXB1bGxhcHVkaUB3YXRlci5pZTAeFw0yMjAxMjAwOTU3MTFaFw0yMzAxMjAwOTU3MTFaMIGEMQswCQYDVQQGEwJFdTEQMA4GA1UECAwHSXJlbGFuZDEPMA0GA1UEBwwGRHVibGluMQswCQYDVQQKDAJJVzELMAkGA1UECwwCSVcxCzAJBgNVBAMMAklXMSswKQYJKoZIhvcNAQkBFhxzcmF2YW5pLmRhcHVsbGFwdWRpQHdhdGVyLmllMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArOljBJ5vWl4cWtw0RXq/avZHtGBuCdGr1DaPLEeWxGBgbja3owNXFjbFzgYg68kHkXEPC5WbFB6lqk4BJ/9modfeREG0sXM7usXQwyB/lXNtXBj6vn6bu7ZLgKNjrBTqjscFubEU+tF3BzJrz9f0hAwqkR05uRcM0HRZLGyBcCA3jGqtVE+PnRoq2y3vSgxPEdwZCowYapjy6ZEA5k9uSjtZHmwmjphkFzss55a/nMklyY/xVY2KRRaargmbstisPKA5mMRLbSM7/pnmO+n9Trbfh0+vteXntTJ7HPNn8brFwRlZG/itj7VLaqb2sUvN/CZNJ/Xa3IMLfwqLHWcpNQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQABzPwRPdWJidQb/aD9RLTHCM3k+pv24o7OEnXC8USQv26f3mpxyX3vxto/nvjbovAt/BFx3IZ3N+SKKZMTt+s0fnVhUd2kOB5xwErwrBQKiztEcDdix0aTyl4Yvao3v50KjZTVs6h8vT6RDhaoHiCC2sG5c6De+cUYz2qS05ls6l+ac2EI/S+cadi7Yq0XY0X9sjt9nZJQusA6g8htUGNKjxzCFATqTrtoYCIC6MV4N414XzlLXyk+zMMFkILtJlEKLh204i4bZ2Rh86FmXgxjoVk5lrZ7th99x95p3B2JSMaq0xtc/fPfelUiq5i/2j0VBD0+24IRP3+MYVatBSnB'
        }
      }
      {
        name: 'test1'
        properties: {
          data: 'MIID0DCCArgCCQDmYwnxGrIAQjANBgkqhkiG9w0BAQsFADCBqTELMAkGA1UEBhMCSU4xCzAJBgNVBAgMAktBMRIwEAYDVQQHDAlCZW5nYWx1cnUxDDAKBgNVBAoMA0lCTTELMAkGA1UECwwCR0IxLzAtBgNVBAMMJm1pcHRlc3Qubm9ydGhldXJvcGUuY2xvdWRhcHAuYXp1cmUuY29tMS0wKwYJKoZIhvcNAQkBFh5zcmF2YW5pLmRhcHVsbGFwdWRpQGluLmlibS5jb20wHhcNMjIwMTI1MTE0OTM0WhcNMjMwMTI1MTE0OTM0WjCBqTELMAkGA1UEBhMCSU4xCzAJBgNVBAgMAktBMRIwEAYDVQQHDAlCZW5nYWx1cnUxDDAKBgNVBAoMA0lCTTELMAkGA1UECwwCR0IxLzAtBgNVBAMMJm1pcHRlc3Qubm9ydGhldXJvcGUuY2xvdWRhcHAuYXp1cmUuY29tMS0wKwYJKoZIhvcNAQkBFh5zcmF2YW5pLmRhcHVsbGFwdWRpQGluLmlibS5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDWWbW3dwzNUpDesJ1UW/JCQzxMCVAStUsBsl6+MA80E1w/oemo35uNU5dN6GnWitBjC9lTkj3RjWD9wOG9fEgtyWEtOHKRVzwCUpcnBjvwjGiD4cWVCFpStxoVPeYfRxlkuLdA9rEJyUEsEpxuux3gs64of2gJpFqjarTMgwnRjYgjIEu7QWxRA4nC4fkMNF4rhx0UktUrESLGU9pqs2hqphrfzV/vrzAw00HMtuy+fYjnrqlXbirl/b4JWip3R7R9qwWcncZ2TJw5S/zt7jO+VJ39JAWi6NIGVSvFwJGNzChlbDTV3R6XXeL56st4zgxZG1zL3sP6/Orlfk2qXPRXAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAFk9z680gURW8xy+nJVSrf6o/jm02NYYphItXp6q12cK5TVvJXkclDN6BOPui6GXfKgYyHlUquH7jyEoeIdK4B7qXtmlaDyHgvLqHiqVrCY1sBlU/ZkKTm98V5JFSR66DUMpRg/pKyQ+J668v140TXv57ztWA1IbUlQvNChe0fQz1mpZfl5awSSAh7GaOCte6JvZTCLbI5xN2m8cvs0PIyDXQx0gaSazvIb0HR2bTNjZGXXzldo176PXjXfkrcHl2sLryo4edUAMyQb6RkqISHRyeyCHjwBwSaGuDES7kCFA7XUWpG2Gas3R0NhezENpCCKFxttMHIq9BI7AuXObZ9Q='
        }
      }
      {
        name: 'mip-cert-test'
        properties: {
          data: 'LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tDQpNSUlFU3pDQ0F6T2dBd0lCQWdJVUJYbHlFa3ZIZ1Y3eENHV0pibVBTRE1NTWdlMHdEUVlKS29aSWh2Y05BUUVMDQpCUUF3Z1lJeEN6QUpCZ05WQkFZVEFrbE9NUkl3RUFZRFZRUUlEQWxMWVhKdVlYUmhhMkV4RWpBUUJnTlZCQWNNDQpDVUpoYm1kaGJHOXlaVEVNTUFvR0ExVUVDZ3dEU1VKTk1Rd3dDZ1lEVlFRTERBTkJVazh4THpBdEJnTlZCQU1NDQpKbTFwY0hSbGMzUXVibTl5ZEdobGRYSnZjR1V1WTJ4dmRXUmhjSEF1WVhwMWNtVXVZMjl0TUI0WERUSXlNREl3DQpPVEV3TVRnd01sb1hEVEl6TURJd09URXdNVGd3TWxvd2dZSXhDekFKQmdOVkJBWVRBa2xPTVJJd0VBWURWUVFJDQpEQWxMWVhKdVlYUmhhMkV4RWpBUUJnTlZCQWNNQ1VKaGJtZGhiRzl5WlRFTU1Bb0dBMVVFQ2d3RFNVSk5NUXd3DQpDZ1lEVlFRTERBTkJVazh4THpBdEJnTlZCQU1NSm0xcGNIUmxjM1F1Ym05eWRHaGxkWEp2Y0dVdVkyeHZkV1JoDQpjSEF1WVhwMWNtVXVZMjl0TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFvaXN0DQpITitxY2xPNmhRejBJM0dzc1pUL0E2Q2FIRHZEL0hoQjMweHpUZDU5b1o4VUY3dytmbzl1OGE1QkN0bmgzNURuDQpxa1RGQmdHcVVPdTZrSzJFQXh2eXFLdWRqaDJyUmFwblRkWlJmMGxhMmlJajdhVnpWZVBITmV4cFNDUTBpTzBhDQpiMEs2TGl6aFpxaFdxdjNqb0trUS9FUXNJTlphQnkyLzhSR0xqTkYxNE43THRDdVc1ZmhlYzl1bENvaEFSTmJpDQprNEc2M0xPTjNMMFRUQmw4MWxkT1hrajVFVlc1SHNnenNNdzMyb3gyci9WT2hXYldUTXdDK2VCd3NrL3dldjlFDQo2VkZzMzIzRE0zOU9nOFdrZFc5R1lEQWxtYUVQZVp6THJJcjc4TjRibGk4bnBzYmxvdTE5ODZhU0N4MXlzc25ODQpBOFZmS1I0bHBPV3dtVGdocXdJREFRQUJvNEcyTUlHek1Bc0dBMVVkRHdRRUF3SUVNREFUQmdOVkhTVUVEREFLDQpCZ2dyQmdFRkJRY0RBVENCamdZRFZSMFJCSUdHTUlHRGdpWnRhWEIwWlhOMExtNXZjblJvWlhWeWIzQmxMbU5zDQpiM1ZrWVhCd0xtRjZkWEpsTG1OdmJZSXNjM1JoWjJVdWJXbHdkR1Z6ZEM1dWIzSjBhR1YxY205d1pTNWpiRzkxDQpaR0Z3Y0M1aGVuVnlaUzVqYjIyQ0szUmxjM1F1Yldsd2RHVnpkQzV1YjNKMGFHVjFjbTl3WlM1amJHOTFaR0Z3DQpjQzVoZW5WeVpTNWpiMjB3RFFZSktvWklodmNOQVFFTEJRQURnZ0VCQURaYmJmWHh1MWhHVVYvTEpMRE0vdGFCDQorNEdYWTh6bGpua2FuMEdTdmxQV3ZZejRRckozSWlHL0c3QlVVZXRPYk1TMDkwbzJua25VZFpaazUzeFBrWjJYDQp0Q2kzT0Q4UjNrRmlZRWpORnA4UkRxRnYyNlYyRU5iUWtRSXg0bzFmYnQ2V1A3VVA0TmJkVHl5UWtKcEYwazkxDQpGTzc1WDNZQ1pwTXNENWZ1dm44Ujh5eWcxTkU1aUpRb2liS0w3NGJ0K01BeTBpUUJVV3BuaDc0YnhtRVkza2NFDQpRVHlBMzg1czdJNE00YXRCRCszcnc5OFRvYkJyMGF5RlRJMkVYMnZSZ3NIeU1idFRNMUxHR0g0aHI1ZXN3YXZ1DQo3cGJqeUUrMmJ3NHhPZGFZTzdmSm9uWWpuclhQR2lISW81dnFLWlFnbUxpQkhtc2RSL1FqVnplckhLbmE4UVU9DQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tDQo='
        }
      }
      {
        name: 'MIP-Cert-Custom'
        properties: {
          data: 'LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tDQpNSUlEM3pDQ0FzZWdBd0lCQWdJVU03c1RjQlpLMUV2YXRVK3lRMmpvSi93MEdGSXdEUVlKS29aSWh2Y05BUUVMDQpCUUF3ZkRFTE1Ba0dBMVVFQmhNQ1NVNHhDekFKQmdOVkJBZ01Ba3RCTVJJd0VBWURWUVFIREFsQ1lXNW5ZV3h2DQpjbVV4RERBS0JnTlZCQW9NQTBsQ1RURU5NQXNHQTFVRUN3d0VTVUpOUXpFdk1DMEdBMVVFQXd3bWJXbHdkR1Z6DQpkQzV1YjNKMGFHVjFjbTl3WlM1amJHOTFaR0Z3Y0M1aGVuVnlaUzVqYjIwd0hoY05Nakl3TWpBNU1qRXlNREF6DQpXaGNOTWpRd01qQTVNakV5TURBeldqQjhNUXN3Q1FZRFZRUUdFd0pKVGpFTE1Ba0dBMVVFQ0F3Q1MwRXhFakFRDQpCZ05WQkFjTUNVSmhibWRoYkc5eVpURU1NQW9HQTFVRUNnd0RTVUpOTVEwd0N3WURWUVFMREFSSlFrMURNUzh3DQpMUVlEVlFRRERDWnRhWEIwWlhOMExtNXZjblJvWlhWeWIzQmxMbU5zYjNWa1lYQndMbUY2ZFhKbExtTnZiVENDDQpBU0l3RFFZSktvWklodmNOQVFFQkJRQURnZ0VQQURDQ0FRb0NnZ0VCQU9rdHJhLzhoU05maVpEVlVkVFMwYnZGDQpxTVA0VEJkdFhJa0J4VHRtYnY2NlgxR1ZNQ3JWNFFFRWtOSjhRRkp6cERFTGJkYUFtWFpWT0htZ0RKOVUvaWpnDQpYdmswalhacmNDSTJpbzJ2Rk9sVzU3N1p1VUdyRERjQU5hUUJnZ29iS0xITzc2dnh6N2pjZFc0ZzdtUTZlY1dODQowQzhPTkI5d2hOT3pDcjEvWVlMMS9vem1PZUpTd2ZIZElOVHBkN2RsaVJQMlVkVERPclJkT2wyRkpMWEVnL084DQpsNXVHUjNpVHZkV01ZTUZSUFBXcEZZdU5LM1BYWVpqaS9VOHBVL2ZyV3daSkp5RHdubEdiVHdDMFFTTTBNem8vDQpYYUhPcXY0SHhNVlhxM0U3R3BlOGxyQTVzOEpJb1NFZXlMb01MQy9NcHJpNmNzeDYzWWpKK1REb2RScFpvbThDDQpBd0VBQWFOWk1GY3dDd1lEVlIwUEJBUURBZ1hnTUJNR0ExVWRKUVFNTUFvR0NDc0dBUVVGQndNQk1ETUdBMVVkDQpFUVFzTUNxQ0tDb3ViV2x3ZEdWemRDNXViM0owYUdWMWNtOXdaUzVqYkc5MVpHRndjQzVoZW5WeVpTNWpiMjB3DQpEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBSWhIYVJIOEpoU1VSbEJhbVVrV2lKcU9USitLQWlDLzN4cGJ5RVpIDQo5Q3lHeWFYbXVRWjNQZGZRV3BTVVU1aXhWWnplV0hlZElJWjI2Sm5qdW13bE9DenYxamlsOUdmWjN5U1NJNWRjDQpFZDlmVURDaEdIc0VvQ1hQSXR6Rks3NlVESGF2WkJGSHp4ZGVDN0kxYVJmandOaHFpYWhDU3NQQU11bkJVYzE0DQpjWmFod3A1elZ6VzIzNE5ONEhhVDZGdGJnRHl4RWhqQVV6blZOdm91ajVhWS8xNGpuZXNIcXBpbVJxYjROdVFxDQpUcGxVV3lKN3hXeWNSdENFZ1dvQjBlMG9TRm9aZERpanR4cDFwcTRTdXZZc09LY0IvQjJibTlQTkRlazZwekZVDQovVCtORVVURWlXVEY5TlBVZzJHZ3hYKzNIZXJweXVXLzE4ajZmQ3N1K3cweGQ0dz0NCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0NCg=='
        }
      }
      {
        name: 'MIP-Cert-Custom-Alt-Sub'
        properties: {
          data: 'LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tDQpNSUlFUFRDQ0F5V2dBd0lCQWdJVVhIWStRMGwvOFdWWmxJaFJMWDhBZzVyNkg4MHdEUVlKS29aSWh2Y05BUUVMDQpCUUF3ZkRFTE1Ba0dBMVVFQmhNQ1NVNHhDekFKQmdOVkJBZ01Ba3RCTVJJd0VBWURWUVFIREFsQ1lXNW5ZV3h2DQpjbVV4RERBS0JnTlZCQW9NQTBsQ1RURU5NQXNHQTFVRUN3d0VTVUpOUXpFdk1DMEdBMVVFQXd3bWJXbHdkR1Z6DQpkQzV1YjNKMGFHVjFjbTl3WlM1amJHOTFaR0Z3Y0M1aGVuVnlaUzVqYjIwd0hoY05Nakl3TWpFd01UQTBPVFUwDQpXaGNOTWpRd01qRXdNVEEwT1RVMFdqQjhNUXN3Q1FZRFZRUUdFd0pKVGpFTE1Ba0dBMVVFQ0F3Q1MwRXhFakFRDQpCZ05WQkFjTUNVSmhibWRoYkc5eVpURU1NQW9HQTFVRUNnd0RTVUpOTVEwd0N3WURWUVFMREFSSlFrMURNUzh3DQpMUVlEVlFRRERDWnRhWEIwWlhOMExtNXZjblJvWlhWeWIzQmxMbU5zYjNWa1lYQndMbUY2ZFhKbExtTnZiVENDDQpBU0l3RFFZSktvWklodmNOQVFFQkJRQURnZ0VQQURDQ0FRb0NnZ0VCQU90WVZOU3lCeHNTRW8zbkczSXdBVkJGDQpmM2dlaEdlZ3R3d3RvdHIwVHZWWk9IWTQ4OTRpYTBaVUVlS2JxeHBUcmJ4Ull5TW1qZ2x0SG5lR1hlaVBKKzJqDQp3dkEzT3dwRDBIalcwN0c4Ty9rL204dUF0WmJpcEt1OXpIbnRpOVhpOFpkMisvTDVxTFk0OGNZSEpwcTIzQ2U1DQpQcGdKYjZCd3pQZ21EeC9hOGMzQkxvTUdVUUlMaUlPT1QrVDlKaklSMFZHRnRkY1ZmdnRJaFlockF1UVJDV1BhDQpGdldaelYwUnZwbkdDRnJiU0tGSTdrclh3REdERTByNXkxd3RtTnRWaUZ5cVA5K0JiNy9JUkc0L3lDdGlOT2gwDQpQTDVhYTZpV2V3UDg1S1VQd1F5dmJ5NkFsbENuQ253aUFvWEFDdUxVSmtzSDdkRmlnbHdTR25mM2JEYVhOUVVDDQpBd0VBQWFPQnRqQ0JzekFMQmdOVkhROEVCQU1DQmVBd0V3WURWUjBsQkF3d0NnWUlLd1lCQlFVSEF3RXdnWTRHDQpBMVVkRVFTQmhqQ0JnNEltYldsd2RHVnpkQzV1YjNKMGFHVjFjbTl3WlM1amJHOTFaR0Z3Y0M1aGVuVnlaUzVqDQpiMjJDSzNSbGMzUXViV2x3ZEdWemRDNXViM0owYUdWMWNtOXdaUzVqYkc5MVpHRndjQzVoZW5WeVpTNWpiMjJDDQpMSE4wWVdkbExtMXBjSFJsYzNRdWJtOXlkR2hsZFhKdmNHVXVZMnh2ZFdSaGNIQXVZWHAxY21VdVkyOXRNQTBHDQpDU3FHU0liM0RRRUJDd1VBQTRJQkFRQWRjMmFONktHQ0xCMDdtTDY3UmJSYXp2M3c1Um5vY09uOWM3d2J1cURSDQpCNStzNWtHR1RKenRWalVjUUNieFk5RUZnZGdaWG1SK29DaHk4cWR6c3R6NXBOT1psRjBid0NIeFhGNnZ0WCsyDQo5QktjWDkyWkpLUVN2am44dlAxOXJrNWh2aW5kVkc3MzRiZ1RsKzQ4czdBaVV6R05WMC9yN2xCd0VXR2swRTkyDQpLNlh5UlZZZEgxR1hBMlQxVVJpZ2hYZEowbmg2ZW5CeXdsWVoyeXZXSXlxL2orTE42R0tUdUNVaklQSnlNNUhzDQpkYjIyY2QvckRaY0FpQ3N0YUdERWo5RGlENXdod0tuQU1PRitaWHl4a0NrdDBLc2J1OEJISHJZVGhxcDZNVHFuDQp1MmV0Z2Rxc1IrUWR1V1BDcUxFVll2RHFNd1ZzOHI0ZVhGM2tlbTRqcjA2OQ0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQ0K'
        }
      }
      {
        name: 'miproottest1'
        properties: {
          data: 'LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tDQpNSUlDV0RDQ0FmMENGRHZFUEJKanR6eXoxMkZmZkNNcklzZStyelFaTUFvR0NDcUdTTTQ5QkFNQ01JR3RNUXN3DQpDUVlEVlFRR0V3SkpUakVMTUFrR0ExVUVDQXdDUzBFeEVqQVFCZ05WQkFjTUNVSmhibWRoYkc5eVpURU1NQW9HDQpBMVVFQ2d3RFNVSk5NUTB3Q3dZRFZRUUxEQVJKUWsxRE1UWXdOQVlEVlFRRERDMXRhWEF0WVhCd1oyRjBaWGRoDQplUzV1YjNKMGFHVjFjbTl3WlM1amJHOTFaR0Z3Y0M1aGVuVnlaUzVqYjIweEtEQW1CZ2txaGtpRzl3MEJDUUVXDQpHWEpoYTJWemFDNTFjR0ZrYUhsaGVURkFkMkYwWlhJdWFXVXdIaGNOTWpJd01qRXhNRGN5TmpVMVdoY05Nak13DQpNakV4TURjeU5qVTFXakNCclRFTE1Ba0dBMVVFQmhNQ1NVNHhDekFKQmdOVkJBZ01Ba3RCTVJJd0VBWURWUVFIDQpEQWxDWVc1bllXeHZjbVV4RERBS0JnTlZCQW9NQTBsQ1RURU5NQXNHQTFVRUN3d0VTVUpOUXpFMk1EUUdBMVVFDQpBd3d0Yldsd0xXRndjR2RoZEdWM1lYa3VibTl5ZEdobGRYSnZjR1V1WTJ4dmRXUmhjSEF1WVhwMWNtVXVZMjl0DQpNU2d3SmdZSktvWklodmNOQVFrQkZobHlZV3RsYzJndWRYQmhaR2g1WVhreFFIZGhkR1Z5TG1sbE1Ga3dFd1lIDQpLb1pJemowQ0FRWUlLb1pJemowREFRY0RRZ0FFb0phVm1xRVdnd2RzR2NqWEdpNCtkRU1jRGJNSUdCbGVXRzhMDQpudkNNN2d4YnhvS1R3RVowdVFDWDVPUnd5bk1HQ0F2SXFUdXRFanN4a1d4MzBNeWpoekFLQmdncWhrak9QUVFEDQpBZ05KQURCR0FpRUFrN2lLMCsyUlZucmZUUWtvVEJsOXE5dWIvekxVSjB6eXdwdlU5TEIvc084Q0lRRGdMU1FoDQpBdWdhMit1c0xHa1dYVWI4YjZzK2k0ckpIN1hYbkNnZlovZENKQT09DQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tDQo='
        }
      }
    ]
    trustedClientCertificates: []
    sslProfiles: []
    frontendIPConfigurations: [
      {
        name: 'appGatewayFrontendIP'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_IWAZUNPDAGW001_IP001_externalid
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'appGatewayFrontendPort'
        properties: {
          port: 80
        }
      }
      {
        name: 'port_443'
        properties: {
          port: 443
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'nodejsbkend'
        properties: {
          backendAddresses: [
            {
              fqdn: 'nodejs-ex-git-demo1.apps.i2grkp07.northeurope.aroapp.io'
            }
          ]
        }
      }
      {
        name: 'nodehttp'
        properties: {
          backendAddresses: [
            {
              fqdn: 'nodejs-http-demo1.apps.i2grkp07.northeurope.aroapp.io'
            }
          ]
        }
      }
      {
        name: 'graphhttp'
        properties: {
          backendAddresses: [
            {
              fqdn: 'test-graphql-demo.apps.i2grkp07.northeurope.aroapp.io'
            }
          ]
        }
      }
      {
        name: 'mipnpd'
        properties: {
          backendAddresses: [
            {
              ipAddress: '10.86.1.254'
            }
          ]
        }
      }
      {
        name: 'graph-play-https'
        properties: {
          backendAddresses: [
            {
              fqdn: 'https-irishwater.apps.i2grkp07.northeurope.aroapp.io'
            }
          ]
        }
      }
      {
        name: 'graphql-https'
        properties: {
          backendAddresses: [
            {
              fqdn: 'https-test-graphql-demo.apps.i2grkp07.northeurope.aroapp.io'
            }
          ]
        }
      }
      {
        name: 'mipcachetest'
        properties: {
          backendAddresses: [
            {
              fqdn: 'cachetest.apps.i2grkp07.northeurope.aroapp.io'
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'nodejssetting'
        properties: {
          port: 443
          protocol: 'Https'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: true
          affinityCookieName: 'ApplicationGatewayAffinity'
          requestTimeout: 20
        }
      }
      {
        name: 'node-http-settings'
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: true
          affinityCookieName: 'ApplicationGatewayAffinity'
          requestTimeout: 20
        }
      }
      {
        name: 'graph-http-setting'
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: true
          affinityCookieName: 'ApplicationGatewayAffinity'
          path: '/graphql'
          requestTimeout: 20
          probe: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/probes/graphprobe'
          }
        }
      }
      {
        name: 'graphprobe'
        properties: {
          port: 8080
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: true
          affinityCookieName: 'ApplicationGatewayAffinity'
          path: '/graphql'
          requestTimeout: 20
        }
      }
      {
        name: 'graphqlhttp'
        properties: {
          port: 443
          protocol: 'Https'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: false
          affinityCookieName: 'ApplicationGatewayAffinity'
          requestTimeout: 20
        }
      }
      {
        name: 'graph-play-https-settings'
        properties: {
          port: 443
          protocol: 'Https'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: true
          affinityCookieName: 'ApplicationGatewayAffinity'
          path: '/graphql'
          requestTimeout: 20
          probe: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/probes/graphql-playground-probe'
          }
        }
      }
      {
        name: 'graphql-https-settings'
        properties: {
          port: 443
          protocol: 'Https'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: true
          affinityCookieName: 'ApplicationGatewayAffinity'
          path: '/graphql'
          requestTimeout: 20
          probe: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/probes/graphql-https-probe'
          }
        }
      }
      {
        name: 'mipapi1'
        properties: {
          port: 443
          protocol: 'Https'
          cookieBasedAffinity: 'Disabled'
          hostName: 'irishwater-graphql-gateway-525eca1d5089dbdc-istio-system.apps.i2grkp07.northeurope.aroapp.io'
          pickHostNameFromBackendAddress: false
          affinityCookieName: 'ApplicationGatewayAffinity'
          requestTimeout: 20
          probe: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/probes/mipapi1'
          }
        }
      }
      {
        name: 'mipapibearer'
        properties: {
          port: 443
          protocol: 'Https'
          cookieBasedAffinity: 'Disabled'
          hostName: 'irishtest.apps.i2grkp07.northeurope.aroapp.io'
          pickHostNameFromBackendAddress: false
          requestTimeout: 20
          probe: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/probes/mipapi1'
          }
        }
      }
      {
        name: 'mipcachetest'
        properties: {
          port: 443
          protocol: 'Https'
          cookieBasedAffinity: 'Disabled'
          hostName: 'cachetest.apps.i2grkp07.northeurope.aroapp.io'
          pickHostNameFromBackendAddress: false
          requestTimeout: 20
          probe: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/probes/mipapi1'
          }
        }
      }
    ]
    httpListeners: [
      {
        name: 'mipapi1'
        properties: {
          frontendIPConfiguration: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/frontendIPConfigurations/appGatewayFrontendIP'
          }
          frontendPort: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/frontendPorts/port_443'
          }
          protocol: 'Https'
          sslCertificate: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/sslCertificates/starmiptest'
          }
          hostName: 'hardcoded.miptest.northeurope.cloudapp.azure.com'
          hostNames: []
          requireServerNameIndication: true
        }
      }
      {
        name: 'mipapibearer'
        properties: {
          frontendIPConfiguration: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/frontendIPConfigurations/appGatewayFrontendIP'
          }
          frontendPort: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/frontendPorts/port_443'
          }
          protocol: 'Https'
          sslCertificate: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/sslCertificates/mikecert1'
          }
          hostName: 'miptest.northeurope.cloudapp.azure.com'
          hostNames: []
          requireServerNameIndication: true
        }
      }
      {
        name: 'mipcache'
        properties: {
          frontendIPConfiguration: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/frontendIPConfigurations/appGatewayFrontendIP'
          }
          frontendPort: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/frontendPorts/port_443'
          }
          protocol: 'Https'
          sslCertificate: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/sslCertificates/mikecert1'
          }
          hostName: 'cache.miptest.northeurope.cloudapp.azure.com'
          hostNames: []
          requireServerNameIndication: true
        }
      }
    ]
    urlPathMaps: []
    requestRoutingRules: [
      {
        name: 'mipapi1'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/httpListeners/mipapi1'
          }
          backendAddressPool: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/backendAddressPools/mipnpd'
          }
          backendHttpSettings: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/backendHttpSettingsCollection/mipapi1'
          }
        }
      }
      {
        name: 'mipapibearer'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/httpListeners/mipapibearer'
          }
          backendAddressPool: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/backendAddressPools/mipnpd'
          }
          backendHttpSettings: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/backendHttpSettingsCollection/mipapibearer'
          }
        }
      }
      {
        name: 'cachetestrule'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/httpListeners/mipcache'
          }
          backendAddressPool: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/backendAddressPools/mipnpd'
          }
          backendHttpSettings: {
            id: '${applicationGateways_IWAZUNPDAGW001_name_resource.id}/backendHttpSettingsCollection/mipcachetest'
          }
        }
      }
    ]
    probes: [
      {
        name: 'mipapi1'
        properties: {
          protocol: 'Https'
          host: 'https-test-graphql-demo.apps.i2grkp07.northeurope.aroapp.io'
          path: '/graphql?query=%7B__typename%7D'
          interval: 30
          timeout: 30
          unhealthyThreshold: 3
          pickHostNameFromBackendHttpSettings: false
          minServers: 0
          match: {
            statusCodes: [
              '200-399'
            ]
          }
        }
      }
      {
        name: 'graphprobe'
        properties: {
          protocol: 'Http'
          host: 'test-graphql-demo.apps.i2grkp07.northeurope.aroapp.io'
          path: '/graphql?query=%7B__typename%7D'
          interval: 30
          timeout: 30
          unhealthyThreshold: 3
          pickHostNameFromBackendHttpSettings: false
          minServers: 0
          match: {
            statusCodes: [
              '200-399'
            ]
          }
        }
      }
      {
        name: 'graphql-playground-probe'
        properties: {
          protocol: 'Https'
          host: 'https-irishwater.apps.i2grkp07.northeurope.aroapp.io'
          path: '/graphql?query=%7B__typename%7D'
          interval: 30
          timeout: 30
          unhealthyThreshold: 3
          pickHostNameFromBackendHttpSettings: false
          minServers: 0
          match: {
            statusCodes: [
              '200-399'
            ]
          }
        }
      }
      {
        name: 'graphql-https-probe'
        properties: {
          protocol: 'Https'
          host: 'https-test-graphql-demo.apps.i2grkp07.northeurope.aroapp.io'
          path: '/graphql?query=%7B__typename%7D'
          interval: 30
          timeout: 30
          unhealthyThreshold: 3
          pickHostNameFromBackendHttpSettings: false
          minServers: 0
          match: {
            statusCodes: [
              '200-399'
            ]
          }
        }
      }
    ]
    rewriteRuleSets: []
    redirectConfigurations: []
    privateLinkConfigurations: []
    webApplicationFirewallConfiguration: {
      enabled: true
      firewallMode: 'Detection'
      ruleSetType: 'OWASP'
      ruleSetVersion: '3.0'
      disabledRuleGroups: []
      exclusions: []
      requestBodyCheck: true
      maxRequestBodySizeInKb: 128
      fileUploadLimitInMb: 5
    }
  }
}
