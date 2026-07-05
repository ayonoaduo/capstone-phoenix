# Cost

Estimate for the demo cluster in `eu-north-1`, running continuously for a 730-hour month.

| Item | Quantity | Estimate |
| --- | ---: | ---: |
| EC2 `c7i-flex.large` Linux nodes | 3 | about $199/month |
| gp3 root volumes, 30 GiB each | 90 GiB | about $8/month |
| S3 Terraform state bucket | 1 | less than $1/month |
| DynamoDB lock table | pay per request | less than $1/month |
| Route 53 hosted zone | 1 | about $0.50/month |
| Data transfer | light demo traffic | usually less than $5/month |

Expected monthly total: about `$210-215`, plus domain registration if not already owned.

To cut this roughly in half, run the cluster only during build/demo windows and destroy it afterward. For non-demo practice runs, reduce to one worker or a smaller instance type after the platform is stable, but keep the final evidence on the three-node cluster because the rubric expects real multi-node Kubernetes behavior.
