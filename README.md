# Preparing the local environment
```export AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXXXXXX```
```export AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX```
# Before deploying
-- On your first deploy, you must comment the **backend** configuration on the *main.tf* file on the root directory, then you can proceed to the next steps.
# Init
```terraform init```
# Plan
```terraform plan```
# Apply
```terraform apply```
# Setting up s3 backend
- After deploying the initial infrastructure, uncomment the **backend** configuration and run:
```terraform init -reconfigure```