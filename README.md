# k8s-ecr-rotation
it apply ECR sign-in, and re-rolled automatically

## Usage

Please download this repository.

```bash
$ git clone git@github.com:pyar6329/k8s-ecr-rotation.git
$ cd k8s-ecr-rotation
```

You need to set environment variables

```bash
export AWS_ACCESS_KEY_ID="<your aws access key>"
export AWS_SECRET_ACCESS_KEY="<your aws secret key>"
export AWS_ACCOUNT_ID="<your aws account id>"
export AWS_DEFAULT_REGION="<your default region>"
export SECRET_NAMESPACE="<The namespace saved of docker login's credential>"
```

Besides, you run below command.

```bash
./install.sh
```

## Uninstall

Please run below

```bash
./uninstall.sh
```
