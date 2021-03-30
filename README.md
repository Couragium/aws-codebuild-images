# AWS CodeBuild Docker images

This repository holds Dockerfiles of AWS CodeBuild Docker images.
It is based on [aws/aws-codebuild-docker-images](https://github.com/aws/aws-codebuild-docker-images) and [rust-lang/docker-rust](https://github.com/rust-lang/docker-rust)

The images are published to dockerhub at [*couragium/aws-codebuild-images*](https://hub.docker.com/r/couragium/aws-codebuild-images)

The Dockerfiles are at [*Couragium/aws-codebuild-images*](https://github.com/Couragium/aws-codebuild-images/tree/main/debian)

There are three flavours available:
* slim: Debian stable slim with AWS CLI v2 and Docker-in-Docker
* slim-rust: Like slim, but with rust installed
* slim-rust-cache: Like slim-rust, but with [mozilla/sccache](https://github.com/mozilla/sccache) installed

You can download the image with
```bash
docker pull couragium/aws-codebuild-images:tagname
````

Or pass it to your build project
```typescript
    const image = codebuild.LinuxBuildImage.fromDockerRegistry(
        'couragium/aws-codebuild-images:slim-rust'
    );

    const buildProject = new codebuild.PipelineProject(stack, name, {
        environment: {
            buildImage: image,
            privileged: true, // Required for Docker in Docker
        },
        //[...]
    });

```

Should you need to run a docker command, please start the daemon yourself in your buildspec:
```typescript
    const spec = codebuild.BuildSpec.fromObject({
        //[...]
        phases: {
            pre_build: {
                commands: [
                    '/usr/local/bin/dockerd-entrypoint.sh', // From standard-5.0
                ]
            },
            build: {
                commands: [
                    'docker build ...',
        },
    });

```
