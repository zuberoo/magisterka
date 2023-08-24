package test

import (
	"testing"
	"strings"
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/stretchr/testify/assert"
)

func TestAWSEC2AndS3(t *testing.T) {
	t.Parallel()

	awsRegion := "us-west-1"
	bucketName := "my-test-s3-bucket"

	
	for i := 1; i <= 5; i++ {
		instanceID := "id_inst" + string(i)
		exists := aws.Ec2InstanceExists(t, instanceID, awsRegion)
		assert.True(t, exists, "EC2 instance does not exist: "+instanceID)
	}

	
	assert.True(t, aws.S3BucketExists(t, awsRegion, bucketName), "S3 bucket does not exist")

	
	for i := 1; i <= 5; i++ {
		instanceID := "id_inst" + string(i)
		instanceType := aws.GetEc2InstanceType(t, instanceID, awsRegion)
		assert.Equal(t, "t2.micro", instanceType, "Unexpected EC2 instance type for "+instanceID)
	}

	
	isPublic := aws.GetS3BucketPublicAccessBlock(t, awsRegion, bucketName)
	assert.False(t, isPublic, "S3 bucket should be private")

	
	expectedVPC := "vpc-0123456789abcdef0"
	for i := 1; i <= 5; i++ {
		instanceID := "id_inst" + string(i)
		vpcID := aws.GetEc2InstanceVpcId(t, instanceID, awsRegion)
		assert.Equal(t, expectedVPC, vpcID, "Unexpected VPC for EC2 instance "+instanceID)
	}

	
	aclVersion := aws.GetS3BucketAclVersioning(t, awsRegion, bucketName)
	assert.True(t, aclVersion, "S3 bucket versioning is not enabled")

	
	loggingEnabled := aws.GetS3BucketLoggingTargetPrefix(t, awsRegion, bucketName)
	assert.NotEqual(t, "", loggingEnabled, "S3 bucket logging is not enabled")

	
	expectedAZ := "us-west-1a"
	for i := 1; i <= 5; i++ {
		instanceID := "id_inst" + string(i)
		az := aws.GetEc2InstanceAvailabilityZone(t, instanceID, awsRegion)
		assert.Equal(t, expectedAZ, az, "Unexpected Availability Zone for EC2 instance "+instanceID)
	}

	retentionPolicy := aws.GetS3BucketObjectLockConfiguration(t, awsRegion, bucketName)
    assert.NotNil(t, retentionPolicy, "S3 bucket does not have an object retention policy")

	for i := 1; i <= 5; i++ {
        instanceID := "id_inst" + string(i)
        detailedMonitoringStatus := aws.GetEc2InstanceDetailedMonitoringStatus(t, instanceID, awsRegion)
        assert.True(t, detailedMonitoringStatus, "EC2 instance does not have detailed monitoring enabled: "+instanceID)
    }


}