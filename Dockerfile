FROM amazonlinux:2023

# Run package updates
RUN yum install -yq wget aws-cli && \
    wget https://s3.amazonaws.com/mountpoint-s3-release/latest/arm64/mount-s3.rpm && \
    yum install -y mount-s3.rpm && \
    mkdir /mount_s3