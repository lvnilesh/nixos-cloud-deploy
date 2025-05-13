az feature register --name UseStandardSecurityType --namespace Microsoft.Compute
Once the feature 'UseStandardSecurityType' is registered, invoking 'az provider register -n Microsoft.Compute' is required to get the change propagated
{
  "id": "/subscriptions/f5028971-ce98-4710-8983-1fe2d4fc45dd/providers/Microsoft.Features/providers/Microsoft.Compute/features/UseStandardSecurityType",
  "name": "Microsoft.Compute/UseStandardSecurityType",
  "properties": {
    "state": "Registering"
  },
  "type": "Microsoft.Features/providers/features"
}

az provider register -n Microsoft.Compute

az feature show --name UseStandardSecurityType --namespace Microsoft.Compute
{
  "id": "/subscriptions/f5028971-ce98-4710-8983-1fe2d4fc45dd/providers/Microsoft.Features/providers/Microsoft.Compute/features/UseStandardSecurityType",
  "name": "Microsoft.Compute/UseStandardSecurityType",
  "properties": {
    "state": "Registering"
  },
  "type": "Microsoft.Features/providers/features"
}

https://github.com/Azure/azure-cli/issues/31191#issuecomment-2844144996