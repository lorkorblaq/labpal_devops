#!/usr/bin/env python3
import aws_cdk as cdk
from aws_cdk import (
    aws_ec2 as ec2,
    aws_ecs as ecs,
    aws_elasticloadbalancingv2 as elbv2,
    aws_autoscaling as autoscaling
)

class LabpalStack(cdk.Stack):

    def __init__(self, scope: cdk.Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        # Define the VPC
        vpc = ec2.Vpc(self, "VPC", max_azs=2)

        # Define the ECS cluster
        cluster = ecs.Cluster(self, "Cluster", vpc=vpc)

        # Define the Network Load Balancer
        nlb = elbv2.NetworkLoadBalancer(self, "NLB",
            vpc=vpc,
            internet_facing=True
        )

        # Create target groups for each service
        target_group_main = elbv2.NetworkTargetGroup(self, "TargetGroupMain",
            vpc=vpc,
            port=8080,
            protocol=elbv2.Protocol.TCP
        )

        target_group_api = elbv2.NetworkTargetGroup(self, "TargetGroupApi",
            vpc=vpc,
            port=3000,
            protocol=elbv2.Protocol.TCP
        )

        # Create a listener for the NLB
        listener = nlb.add_listener("Listener", port=80)

        # Create an ECS task definition with the required resource limits
        task_definition = ecs.Ec2TaskDefinition(self, "TaskDef")

        task_definition.add_container(
            "LabpalMain",
            image=ecs.ContainerImage.from_registry("lorkorblaq/labpal_main:latest"),
            memory_limit_mib=2048,
            cpu=1024,
            logging=ecs.LogDrivers.aws_logs(stream_prefix="LabpalMain")
        ).add_port_mappings(ecs.PortMapping(container_port=8080))

        task_definition.add_container(
            "LabpalApi",
            image=ecs.ContainerImage.from_registry("lorkorblaq/labpal_api:latest"),
            memory_limit_mib=2048,
            cpu=1024,
            logging=ecs.LogDrivers.aws_logs(stream_prefix="LabpalApi")
        ).add_port_mappings(ecs.PortMapping(container_port=3000))

        task_definition.add_container(
            "LabpalNginx",
            image=ecs.ContainerImage.from_registry("lorkorblaq/labpal_nginx:secure"),
            memory_limit_mib=2048,
            cpu=1024,
            logging=ecs.LogDrivers.aws_logs(stream_prefix="LabpalNginx")
        ).add_port_mappings(ecs.PortMapping(container_port=80))

        task_definition.add_container(
            "LabpalRedis",
            image=ecs.ContainerImage.from_registry("lorkorblaq/labpal_redis:latest"),
            memory_limit_mib=2048,
            cpu=1024,
            logging=ecs.LogDrivers.aws_logs(stream_prefix="LabpalRedis")
        ).add_port_mappings(ecs.PortMapping(container_port=6379))

        # Create an Auto Scaling Group with EC2 instances
        asg = autoscaling.AutoScalingGroup(self, "ASG",
            vpc=vpc,
            instance_type=ec2.InstanceType("t3.micro"),
            machine_image=ec2.MachineImage.latest_amazon_linux(),
            min_capacity=1,
            max_capacity=4,
            desired_capacity=1
        )

        # Create an ECS service for each container
        ecs_service_main = ecs.Ec2Service(self, "ServiceMain",
            cluster=cluster,
            task_definition=task_definition,
            desired_count=1,
            service_name="labpal-main"
        )

        ecs_service_api = ecs.Ec2Service(self, "ServiceApi",
            cluster=cluster,
            task_definition=task_definition,
            desired_count=1,
            service_name="labpal-api"
        )

        ecs_service_nginx = ecs.Ec2Service(self, "ServiceNginx",
            cluster=cluster,
            task_definition=task_definition,
            desired_count=1,
            service_name="labpal-nginx"
        )

        ecs_service_redis = ecs.Ec2Service(self, "ServiceRedis",
            cluster=cluster,
            task_definition=task_definition,
            desired_count=1,
            service_name="labpal-redis"
        )

        # Attach target groups to the NLB listener
        listener.add_targets("MainTargets",
            port=8080,
            targets=[ecs_service_main],
            health_check=elbv2.HealthCheck(
                port="8080",  # Port should be a string
                protocol=elbv2.Protocol.TCP
            )
        )

        listener.add_targets("ApiTargets",
            port=3000,
            targets=[ecs_service_api],
            health_check=elbv2.HealthCheck(
                port="3000",  # Port should be a string
                protocol=elbv2.Protocol.TCP
            )
        )

        # Allow ASG instances to register with the ECS service
        ecs_service_main.connections.allow_from_any_ipv4(ec2.Port.tcp(8080))
        ecs_service_api.connections.allow_from_any_ipv4(ec2.Port.tcp(3000))
        ecs_service_nginx.connections.allow_from_any_ipv4(ec2.Port.tcp(80))
        ecs_service_redis.connections.allow_from_any_ipv4(ec2.Port.tcp(6379))

        # Attach the ASG to the ECS cluster
        cluster.add_asg_capacity_provider(asg)

app = cdk.App()
LabpalStack(app, "LabpalStack")
app.synth()
