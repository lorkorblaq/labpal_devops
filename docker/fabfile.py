from fabric import Connection, task

# Set your server details
SSH_CONFIG_NAME = "labpal_devops"

@task
def build_and_push(c):
    # Stop all running containers
    c.local("docker stop $(docker ps -a -q) || true")

    # Remove all containers
    c.local("docker rm -f $(docker ps -a -q) || true")

    # Remove all images
    c.local("docker rmi -f $(docker images -a -q) || true")

    # Build and push the first image
    c.local("docker build -t lorkorblaq/clinicalx_api:latest -f ../../clinicalx_api/Dockerfile ../../clinicalx_api")
    c.local("docker push lorkorblaq/clinicalx_api:latest")

    # Build and push the second image
    c.local("docker build -t lorkorblaq/clinicalx_main:latest -f ../../clinicalx_main/Dockerfile ../../clinicalx_main")
    c.local("docker push lorkorblaq/clinicalx_main:latest")

    print("Pushing completed.")

@task
def deploy(c):
    # Connect to the server
    conn = Connection(SSH_CONFIG_NAME)
    # Stop Docker containers
    conn.run("docker-compose down")

    # Remove the Docker containers
    conn.run("docker rm -f $(docker ps -a -q) || true")

    # Remove the Docker images
    conn.run("docker rmi -f lorkorblaq/clinicalx_main:latest || true")
    conn.run("docker rmi -f lorkorblaq/clinicalx_api:latest || true")
    conn.run("docker rmi -f lorkorblaq/clinicalx_nginx:latest || true")

    # Run Docker Compose to start the services again
    conn.run("docker-compose up -d --build")

    print("Deployment completed.")

@task
def full_deploy(c):
    build_and_push(c)
    deploy(c)

# Execute the full deployment process
if __name__ == "__main__":
    from fabric import Connection
    from invoke import Context

    # Create a context for local operations
    context = Context()

    # Execute the full deployment
    full_deploy(context)
