# AWS S3 Github Action

Interface to interact with S3 using the S3API.

**Note**: This builds the dockerfile every time, and will use the `latest` tag on the [AWS CLI](https://hub.docker.com/r/amazon/aws-cli/tags) docker image.

```
- uses: telia-actions/aws-s3-action@v1.0.0
  with:
    command: cp ./local_file.txt s3://yourbucket/folder/local_file.txt
    aws_access_key_id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws_secret_access_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    aws_region: us-east-1
```

**Inputs**

| Variable name      | Required/Optional  | Default  | Description                |
| ------------------ | ------------------ | -------- | -------------------------- |
| `command`          | Optional           | N/A     | This is the command that is being performed. |
| `aws_access_key_id` | Optional   | N/A | This is the credentials from an IAM role for getting access to a bucket. [More info](https://docs.aws.amazon.com/cli/latest/reference/configure/) |
| `aws_secret_access_key` | Optional   | N/A | This is the credentials from an IAM role for getting access to a bucket. [More info](https://docs.aws.amazon.com/cli/latest/reference/configure/) |
| `aws_session_token` | Optional   | N/A | This is the credentials from an IAM role for getting access to a bucket. [More info](https://docs.aws.amazon.com/cli/latest/reference/configure/) |
| `aws_region`        | Optional | N/A | This is the region of the bucket. S3 namespace is global but the bucket is regional. |
| `metadata_service_timeout` | Optional   | N/A | The number of seconds to wait until the metadata service request times out. [More info](https://docs.aws.amazon.com/cli/latest/reference/configure/) |
| `flags`        | Optional | N/A | Additional query flags.  |

## FAQs

**How can I use a specific version or test a feature branch?**

You are specifying the tag or branch by using the `@` after the Action name. Below, it uses `v1.0.0` which is based on the tag.

```
- uses: telia-actions/aws-s3api-action@v1.0.0
  ...
```

This uses the master branch:

```
- uses: telia-actions/aws-s3api-action@master
```

It is recommended that you point to a specific version to avoid unexpected changes affecting your workflow.


## Errors

**upload failed: ./test1.txt to s3://.../test1.txt Unable to locate credentials**

You didn't set credentials correctly. Common reason; forgot to set the Github Secrets.

**An error occurred (SignatureDoesNotMatch) when calling the PutObject operation: The request signature we calculated does not match the signature you provided. Check your key and signing method.**

Solution is [here](https://github.com/aws/aws-cli/issues/602#issuecomment-60387771). [More info](https://stackoverflow.com/questions/4770635/s3-error-the-difference-between-the-request-time-and-the-current-time-is-too-la), [more](https://forums.docker.com/t/syncing-clock-with-host/10432/6).

**botocore.utils.BadIMDSRequestError**

[Here](https://stackoverflow.com/questions/68348222/aws-s3-ls-gives-error-botocore-utils-badimdsrequesterror-botocore-awsrequest-a) is the solution. We set the AWS region as a required argument as a result.

**upload failed: folder1/ to s3://.../folder1/ [Errno 21] Is a directory: '/github/workspace/folder1/'**

You need to a recursive flag for the `cp`. Looks like:

```
- uses: telia-actions/aws-s3-action@v1.0.0
  name: Copy Folder
  with:
    command: cp ./folder1/ s3://bucket/folder1/
    aws_access_key_id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws_secret_access_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    aws_region: us-east-1
    flags: --recursive
```

**An error occurred (AccessDenied) when calling the ListObjectsV2 operation: Access Denied**

[Solution](https://aws.amazon.com/premiumsupport/knowledge-center/s3-access-denied-listobjects-sync/).


**fatal error: An error occurred (404) when calling the HeadObject operation: Key "verify-aws-s3-action/folder1/" does not exist**

You need to add a recursive flag, `flags: --recursive`.
