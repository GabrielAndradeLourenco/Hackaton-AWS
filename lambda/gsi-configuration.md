# DynamoDB Global Secondary Index Configuration

## CampaignStatusIndex GSI for Content Table

### GSI Definition:
- **Index Name**: `CampaignStatusIndex`
- **Partition Key**: `category` (String)
- **Sort Key**: `status` (String)
- **Projection**: `ALL` (includes all attributes)

### AWS CLI Command to Create GSI:
```bash
aws dynamodb update-table \
  --table-name YourContentTableName \
  --attribute-definitions \
    AttributeName=category,AttributeType=S \
    AttributeName=status,AttributeType=S \
  --global-secondary-index-updates \
    '[{
      "Create": {
        "IndexName": "CampaignStatusIndex",
        "KeySchema": [
          {
            "AttributeName": "category",
            "KeyType": "HASH"
          },
          {
            "AttributeName": "status",
            "KeyType": "RANGE"
          }
        ],
        "Projection": {
          "ProjectionType": "ALL"
        },
        "ProvisionedThroughput": {
          "ReadCapacityUnits": 5,
          "WriteCapacityUnits": 5
        }
      }
    }]'
```

### CloudFormation/CDK Definition:
```yaml
GlobalSecondaryIndexes:
  - IndexName: CampaignStatusIndex
    KeySchema:
      - AttributeName: category
        KeyType: HASH
      - AttributeName: status
        KeyType: RANGE
    Projection:
      ProjectionType: ALL
    ProvisionedThroughput:
      ReadCapacityUnits: 5
      WriteCapacityUnits: 5
```

### Query Pattern:
- **Use Case**: Find all approved content for a specific campaign
- **Query**: `category = 'campaign-name' AND status = 'approved'`
- **Efficiency**: O(log n) lookup instead of full table scan