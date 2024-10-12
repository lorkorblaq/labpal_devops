import boto3

# Initialize boto3 clients for ECS and IAM
ecs_client = boto3.client('ecs')
iam_client = boto3.client('iam')

# Create ECS Cluster
def create_ecs_cluster(cluster_name):
    response = ecs_client.create_cluster(
        clusterName=cluster_name
    )
    return response['cluster']

# Create Task Execution Role (for Fargate)
def create_task_execution_role(role_name):
    assume_role_policy = {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "ecs-tasks.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }

    response = iam_client.create_role(
        RoleName=role_name,
        AssumeRolePolicyDocument=json.dumps(assume_role_policy)
    )
    
    # Attach policies for logging and pulling from ECR
    iam_client.attach_role_policy(
        RoleName=role_name,
        PolicyArn="arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
    )
    
    return response['Role']

# Create Task Definition
def create_task_definition(task_family, execution_role_arn, container_name, image):
    response = ecs_client.register_task_definition(
        family=task_family,
        networkMode='awsvpc',
        executionRoleArn=execution_role_arn,
        containerDefinitions=[
            {
                'name': container_name,
                'image': image,
                'essential': True,
                'memory': 512,
                'cpu': 256,
                'portMappings': [
                    {
                        'containerPort': 80,
                        'protocol': 'tcp'
                    }
                ],
            }
        ],
        requiresCompatibilities=['FARGATE'],
        cpu='256',
        memory='512'
    )
    return response['taskDefinition']

# Create Fargate Service
def create_fargate_service(cluster_name, service_name, task_definition, subnets, security_groups):
    response = ecs_client.create_service(
        cluster=cluster_name,
        serviceName=service_name,
        taskDefinition=task_definition,
        launchType='FARGATE',
        desiredCount=1,
        networkConfiguration={
            'awsvpcConfiguration': {
                'subnets': subnets,
                'securityGroups': security_groups,
                'assignPublicIp': 'ENABLED'
            }
        }
    )
    return response['service']

if __name__ == "__main__":
    # Variables
    cluster_name = 'my-fargate-cluster'
    task_family = 'my-task-family'
    role_name = 'ecsTaskExecutionRole'
    service_name = 'my-fargate-service'
    container_name = 'my-container'
    image = 'YOUR_DOCKER_IMAGE'  # Replace with your Docker image URI
    subnets = ['subnet-abc123']  # Replace with your subnet IDs
    security_groups = ['sg-abc123']  # Replace with your security group IDs

    # Step 1: Create ECS Cluster
    cluster = create_ecs_cluster(cluster_name)
    print(f"Created ECS Cluster: {cluster['clusterArn']}")

    # Step 2: Create Task Execution Role
    role = create_task_execution_role(role_name)
    print(f"Created Task Execution Role: {role['Arn']}")

    # Step 3: Register Task Definition
    task_definition = create_task_definition(task_family, role['Arn'], container_name, image)
    print(f"Created Task Definition: {task_definition['taskDefinitionArn']}")

    # Step 4: Create ECS Fargate Service
    service = create_fargate_service(cluster_name, service_name, task_definition['taskDefinitionArn'], subnets, security_groups)
    print(f"Created Fargate Service: {service['serviceArn']}")
