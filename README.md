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
