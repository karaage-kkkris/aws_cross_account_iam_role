# aws_cross_account_iam_role
A simple cross account implementation by using IAM role.

## Description
When we have multiple AWS accounts, we may want to access the resources in account A from account B. This can be simply done by using IAM role. Suppose we have a CloudWatch log group in account A, and we want to read from an EC2 instance in account B. We need the following resources to be prepared:
- Create RoleB in account B. Attach the AssumeRole permission, and other required permissions depends on the user. Use this role to create an EC2 instance. Take the ARN of RoleB.
- Create RoleA in account A. Enable RoleB to assume RoleA. Also, remember to attach the expect permissions to read CloudWatch logs.
- After the deployment for both accounts finish, log into the EC2 instance in account B. The current role is RoleB.
- Assume RoleA by
  ```
  aws sts assume-role --role-arn "arn:aws:iam::{account_A_id}:role/{role_name}" --role-session-name "test_session"
  ```
  It will give the output like:
  ```
  {
    "Credentials": {
        "SecretAccessKey": "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
        "SessionToken": "AQoDYXdzEGcaEXAMPLE2gsYULo+Im5ZEXAMPLEeYjs1M2FUIgIJx9tQqNMBEXAMPLE
                         CvSRyh0FW7jEXAMPLEW+vE/7s1HRpXviG7b+qYf4nD00EXAMPLEmj4wxS04L/uZEXAMPLECihzFB5lTYLto9dyBgSDy
                         EXAMPLE9/g7QRUhZp4bqbEXAMPLENwGPyOj59pFA4lNKCIkVgkREXAMPLEjlzxQ7y52gekeVEXAMPLEDiB9ST3Uuysg
                         sKdEXAMPLE1TVastU1A0SKFEXAMPLEiywCC/Cs8EXAMPLEpZgOs+6hz4AP4KEXAMPLERbASP+4eZScEXAMPLEsnf87e
                         NhyDHq6ikBQ==",
        "Expiration": "2014-12-11T23:08:07Z",
        "AccessKeyId": "AKIAIOSFODNN7EXAMPLE"
        }
  }
  ```
- Then, add the values of `SecretAccessKey, SessionToken, AccessKeyId` to the environment by
  ```
  export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
  export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
  export AWS_SESSION_TOKEN=AQoDYXdzEGcaEXAMPLE2gsYULo+Im5ZEXAMPLEeYjs1M2FUIgIJx9tQqNMBEXAMPLECvS
  Ryh0FW7jEXAMPLEW+vE/7s1HRpXviG7b+qYf4nD00EXAMPLEmj4wxS04L/uZEXAMPLECihzFB5lTYLto9dyBgSDyEXA
  MPLEKEY9/g7QRUhZp4bqbEXAMPLENwGPyOj59pFA4lNKCIkVgkREXAMPLEjlzxQ7y52gekeVEXAMPLEDiB9ST3UusKd
  EXAMPLE1TVastU1A0SKFEXAMPLEiywCC/Cs8EXAMPLEpZgOs+6hz4AP4KEXAMPLERbASP+4eZScEXAMPLENhykxiHen
  DHq6ikBQ==
  ```
- Now, you can access the CloudWatch log in account A from account B by doing any command you want, such as:
  ```
  aws logs filter-log-events --log-group-name account_a_log_group_name
  ```
