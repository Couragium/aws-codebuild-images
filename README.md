# AWS CodeBuild Docker images

This repository holds Dockerfiles of AWS CodeBuild Docker images.
It is based on [aws/aws-codebuild-docker-images](https://github.com/aws/aws-codebuild-docker-images) and [rust-lang/docker-rust](https://github.com/rust-lang/docker-rust)

The images are published to dockerhub at *couragium/aws-codebuild-images*

There are five flavours available:
* slim: Debian stable slim with AWS tools and Docker-in-Docker
* slim-rust: Like slim, but with rust installed
* slim-rust-cache: Like slim-rust, but with [mozilla/sccache](https://github.com/mozilla/sccache) installed
* standard-5.0: Built from official curated Dockerfile, no changes
* standard-5.0-rust: Like standard, but with rust installed

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

AWS CodeBuild ignores the [*ENTRYPOINT*](https://github.com/aws/aws-codebuild-docker-images/issues/254) so if you need to run a docker command, you should start the daemon yourself in your spec:
```typescript
    const spec = codebuild.BuildSpec.fromObject({
        //[...]
        phases: {
            pre_build: {
                commands: [
                    '/usr/local/bin/dockerd-entrypoint.sh', // Set in official image, but ignored
                ]
            },
            build: {
                commands: [
                    'docker build ...',
        },
    });

```
