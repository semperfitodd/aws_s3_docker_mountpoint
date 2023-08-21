# AWS S3 Docker Mountpoint
![docker_mount.png](images%2Fdocker_mount.png)
This project provides a Dockerfile and instructions to create a container that can mount an Amazon S3 bucket as a filesystem using the new AWS S3 mountpoint feature. It leverages Amazon's latest `mount-s3` tool to enable seamless integration of S3 with applications running inside a Docker container.

## Requirements

- Docker installed on the host machine
- AWS CLI with valid credentials configured

## Build and Usage

1. **Build the Docker Image:**
    ```bash
    docker build -t aws_s3_mount .
    ```
   ![build.png](images%2Fbuild.png)
2. **Run the Docker Container:**
   ```bash
   docker run --rm -it --device /dev/fuse --cap-add SYS_ADMIN -v ~/.aws/credentials:/root/.aws/credentials aws_s3_mount sh
   ```
   ![run.png](images%2Frun.png)
   What do the flags mean?
   * --rm: This flag automatically removes the container when it exits. It helps in cleaning up and not leaving behind any stopped containers after you're done with them.
   * -it: This combines two flags:
      * -i: Keeps the standard input (STDIN) open even if not attached, allowing you to interact with the container.
      * -t: Allocates a pseudo-TTY, providing you with a terminal inside the container, enabling interactive processes.
   * --device /dev/fuse: This flag allows the container to access the FUSE (Filesystem in Userspace) device on the host system. FUSE is required for mounting filesystems at the user level, which is what you're doing with S3.
   * --cap-add SYS_ADMIN: This adds the SYS_ADMIN capability to the container, which is often required for operations related to mounting filesystems. Without this capability, the container's user might not have the required permissions to perform the mount.
   * -v ~/.aws/credentials:/root/.aws/credentials: This flag mounts the AWS credentials file from the host system to the specified location inside the container. It's necessary for authenticating with AWS, so the mount operation can access the appropriate S3 bucket.

3. **Mount the S3 Bucket Inside the Container:**
   ```bash
   mount-s3 --profile <PROFILE> <S3_BUCKET> /mount_s3
   ```
   ![mount.png](images%2Fmount.png)
## Details

- The Dockerfile uses `amazonlinux:2023` as a base image.
- It installs the required packages, including `wget` and `aws-cli`.
- The `mount-s3` package is downloaded and installed from a specific URL.
- A directory `/mount_s3` is created inside the container where the S3 bucket will be mounted.

## Possible Use Cases

- **Data Processing:** Easily process large datasets stored in S3 by mounting the S3 bucket in a containerized data processing application.
- **Backup and Restore:** Utilize this setup for backup and restore operations involving data on S3.
- **Development and Testing:** Simulate production environments by mounting S3 buckets during development and testing phases.
- **Endless Others:** The possibilities are endless. If you can think of any other use cases, please share them with me.

## Security

- Ensure that the AWS credentials used have appropriate permissions for the S3 buckets being mounted.
- When sharing the container or image, be cautious with the AWS credentials file to prevent unauthorized access.
