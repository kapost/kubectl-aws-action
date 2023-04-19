# kubectl-aws-action
This action creates a docker container with kubectl, eksctl, and aws cli available for AWS EKS deployments. Multiple commands can be issued using `args`

# Usage
See [example.yml](.github/workflows/example.yml)

```yaml
on: push
name: Deploy
jobs:
  deploy:
    name: Deploy to Kubernetes
    runs-on: ubuntu-latest
    steps:
      - name: Cancel Previous Runs
        uses: styfle/cancel-workflow-action@0.4.1
        with:
          access_token: ${{ github.token }}

      - name: Checkout
        uses: actions/checkout@v2
    
      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
      
      - name: Login to AWS ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v1
      
      - name: Deploy to EKS Cluster
        uses: kapost/kubectl-aws-action@v1
        env:
          ECR_REPOSITORY: kap-app
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          RELEASE_IMAGE: ${{ github.sha }}
          KUBECTL_VERSION: "v1.21.0" # <-- Not required
          KUBE_CONFIG: ${{ secrets.KUBE_CONFIG_DATA }} # <-- Required
        with:
          args: |
            kubectl set image deployment/kap-app kap-app=$ECR_REGISTRY/$ECR_REPOSITORY:$RELEASE_IMAGE
```

Multiple commands can be issued under the `args`

```yaml
on: push
name: Deploy
jobs:
  deploy:
    name: Deploy to Kubernetes
    runs-on: ubuntu-latest
    steps:
      - name: Cancel Previous Runs
        uses: styfle/cancel-workflow-action@0.4.1
        with:
          access_token: ${{ github.token }}

      - name: Checkout
        uses: actions/checkout@v2
    
      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
      
      - name: Login to AWS ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v1
      
      - name: Deploy to EKS Cluster
        uses: kapost/kubectl-aws-action@v1
        env:
          ECR_REPOSITORY: kap-app
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          RELEASE_IMAGE: ${{ github.sha }}
          KUBECTL_VERSION: "v1.21.0" # <-- Not required
          KUBE_CONFIG: ${{ secrets.KUBE_CONFIG_DATA }} # <-- Required
        with:
          args: |
            kubectl set image deployment/kap-app kap-app=$ECR_REGISTRY/$ECR_REPOSITORY:$RELEASE_IMAGE
            kubectl rollout status deployment/kap-app
```

# Secrets
`KUBE_CONFIG` - **IS required**: This is a base64 encoded kubeconfig file with credentials for Kubernetes cluster access. You need a kubeconfig file with the following format:

```txt
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data:
    LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCmFiY2RlZmdoaWprbG1ub3BxcnN0dXZ3eXh6YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJjZGVmZ2hpamtsbW5vcHFyc3R1ZGVmZ2ZGVmZ2hpamtsbW5vcHFyc3R1dnd5eHphYmNkZWZnaGlqa2wKYWJ==
    server: https://ABCD1234EFGH5678IJKL9012MNOP3456.gr7.us-east-2.eks.amazonaws.com
  name: arn:aws:eks:us-east-2:111222333444:cluster/super-awesome-kap-cluster
contexts:
- context:
    cluster: arn:aws:eks:us-east-2:111222333444:cluster/super-awesome-kap-cluster
    user: arn:aws:eks:us-east-2:111222333444:cluster/super-awesome-kap-cluster
  name: arn:aws:eks:us-east-2:111222333444:cluster/super-awesome-kap-cluster
current-context: arn:aws:eks:us-east-2:111222333444:cluster/super-awesome-kap-cluster
kind: Config
preferences: {}
users:
- name: arn:aws:eks:us-east-2:111222333444:cluster/super-awesome-kap-cluster
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - --region
      - us-east-2
      - eks
      - get-token
      - --cluster-name
      - super-awesome-kap-cluster
      command: aws
```
Run the following command to populate the secret: 
```bash
cat kubeconfig | base64
```

Make sure that the kubeconfig does not have `AWS_PROFILE`, i.e. remove the section before base64 encoding:
```yaml
env:
  - name: AWS_PROFILE
      value: kap
```

## Changeable Variables
`KUBECTL_VERSION` - **not required**: The latest version of kubectl is installed via the Dockerfile. To prevent dependency issues, you can specify a desired kubectl version.
```yaml
      - name: Deploy to EKS Cluster
        uses: kapost/kubectl-aws-action@v1
        env:
          ECR_REPOSITORY: kap-app
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          RELEASE_IMAGE: ${{ github.sha }}
          KUBECTL_VERSION: "v1.21.0" # <-- Not required
          KUBE_CONFIG: ${{ secrets.KUBE_CONFIG_DATA }} # <-- Required
        with:
          args: |
            kubectl set image deployment/kap-app kap-app=$ECR_REGISTRY/$ECR_REPOSITORY:$RELEASE_IMAGE
            kubectl rollout status deployment/kap-app
```
## Notes:
`eksctl` is available in this action, at the time of this writing the version is 0.137.0 and your mileage may vary with later versions in the future. 
Refer to the [eksctl](https://eksctl.io/introduction/) documentation for usage.

If the `KUBECTL_VERSION` isn't specified in your action usage, the latest version of `kubectl` will be used. This may cause issues with your specific cluster if your EKS/Kubernetes version is more than 2 versions behind the most recent release. Refer to the kubernetes documentation on [kubectl compatability](https://kubernetes.io/releases/version-skew-policy/).
