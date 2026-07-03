# Cost

Estimated AWS monthly cost in `us-west-2`:

| Item | Quantity | Estimate |
| --- | ---: | ---: |
| EC2 `t3.small` nodes | 3 | about $45/month |
| gp3 root volumes, 30 GiB each | 90 GiB | about $7/month |
| S3 Terraform state | 1 bucket | less than $1/month |
| DynamoDB lock table | pay per request | less than $1/month |
| Route 53 hosted zone | 1 | about $0.50/month |
| Data transfer | light demo traffic | usually less than $5/month |

Total expected demo cost: about `$55-60/month`, plus the domain registration if needed.

To cut this roughly in half, run the cluster only during demo windows and destroy it afterward, use smaller burstable instances if the app remains stable, and keep evidence screenshots so the cluster does not need to stay online continuously.
