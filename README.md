AWS Terraform EC2 Instance action
============================
This repository is home to an _EC2_ GitHub action used as a template for
rapid deployment of instances.

Usage
-----

```yaml
  - name: My Project
    id: project
    uses: aplaceformom/terraform-project-base-action@master
    with:
      workspace: dev
      project: my-project
      owner: myteam
      email: myteam@example.org
      remote_state_bucket: apfm-terraform-remotestate
      remote_lock_table: terraform-statelock
      shared_state_key: terraform/apfm.tfstate
      tf_assume_role: TerraformApply
        debug: false
  - name: EC2 Deploy
    uses: aplaceformom/terraform-elasticsearch-action@master
    with:
      
```

### instance_type
The EC2 instance type to use. See: https://aws.amazon.com/ec2/instance-types/
- default: t3.micro

- More information about the valid options to be used, can be found [here](https://aplaceformom.atlassian.net/wiki/spaces/TECHOPS/pages/1049133728/2020+AWS+Tagging+Standards) 

Test executed
-------------


References
----------

- https://aws.amazon.com/ec2/instance-types/
- https://bitbucket.org/aplaceformom/techops-terraform-common/src/master/ec2/