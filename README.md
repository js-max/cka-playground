# CKA Playground

To help me to study for [CKA](https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/) really needed an environment (k8s cluster).  
But something disposable because in the end, one of goals it's to understand how to configure/setup a k8s cluster so at least need the bare minimal infrastructure deployed.

Some considerations (collected from Linux Foundations FAQ):
* Ubuntu 16.04
* ETCD v3 for Ubuntu

At the moment, K8S cluster version it's v1.17 (accordingly to Linux Foundations FAQ) and latest it's v1.18 - due to that I didn't pinned the version.

You might see somethings that are not accordingly to best pratices or/and static versions/code, etc etc...
All code were done to suit my needs, feel free to fork/clone and adapt to yours.

I think that I took more time to write down this README than the rest... :grin:

## Requirements

* GCP Account (well with all that free credit that they offer I will rely on Google cloud) to deploy infra;
* Terraform;
* Ansible.

## Architecture

Nothing too much complex to understand:
* 1 Master;
* 3x Nodes/Workers.

~~~text
+-------+
| M     |
| a     |
| s     +-------+---------+---------+
| t     |       |         |         |
| e     |       |         |         |
| r     |       |         |         |
+-------+       |         |         |
            +---+---+ +---+---+ +---+---+
            | N     | | N     | | N     |
            | o     | | o     | | o     |
            | d     | | d     | | d     |
            | e     | | e     | | e     |
            |       | |       | |       |
            | 1     | | 2     | | 3     |
            +-------+ +-------+ +-------+
~~~

No extra security considerations were taken...

That means:
* You need to pass a ssh key at Terraform (instructions below);
* All instances will have a Public IP and accessible;
* Firewall was disabled (yup, test env, dirty as possible...).

Why? Like mentioned before this is something disposable to test/use/destroy in couple of hours only.  
Tomorrow? I will create another one, I need to go deep in CLI and work with K8S cluster and objects - dont want to keep bash history or others...

## Start using it!

### Pre-flight

#### Requirements

##### GCP Account

Oh well... You need to have a [GCP account](https://cloud.google.com/).  
Like I mentioned before, was to take advantage of free credit (and in the end got amazed by the simplicity of GCP, not bad!)

##### Terraform

You need to install Terraform in order to deploy infra.  
Go ahead to their [website](https://www.terraform.io/downloads.html) and install.

Tested version:
~~~bash
$ terraform --version
Terraform v0.12.23
~~~

##### Ansible

We rely on Terraform to manage infra lifecycle and Ansible to configure it properly.  
You need to have Ansible at your machine also, follow [instructions](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).

Tested version:
~~~bash
$ ansible --version
ansible 2.9.6
  ... redacted ...
  python version = 3.7.7 (default, Mar 10 2020, 15:43:33) [Clang 11.0.0 (clang-1100.0.33.17)]
~~~

#### Files

##### GCP Account

*In order to make requests against the GCP API, you need to authenticate to prove that it's you making the request. The preferred method of provisioning resources with Terraform is to use a [GCP service account](https://cloud.google.com/docs/authentication/getting-started), a "robot account" that can be granted a limited set of IAM permissions.*

*From [the service account key page in the Cloud Console](https://console.cloud.google.com/apis/credentials/serviceaccountkey) choose an existing account, or create a new one. Next, download the JSON key file. Name it something you can remember, and store it somewhere secure on your machine.*

Credits to [Terraform - Getting started page](https://www.terraform.io/docs/providers/google/guides/getting_started.html#adding-credentials)

Follow instructions and save into `cka-playground/credentials` folder a JSON file named `credentials.json` (if you dont name that way you need to change Ansible/Terraform in order to reuse it).

## Flight!

### Folder structure

~~~bash
.
├── ansible                 # Ansible code
├── credentials             # Folder to host JSON credentials
└── terraform                
    ├── environments        # Terraform folder to host cluster environments configs
    │   ├── cka01
    │   ├── cka02
    │   └── ckaXX
    └── modules             # Terraform folder modules to allow multiples clusters configs
        ├── cka-infra
        └── cka-network
~~~


### Deploy

#### Infra creation

Vars to be changed on Terraform code:

**File:** `cka-playground/terraform/environments/cka01/main.tf`

| Variable | Description                           |
|----------|---------------------------------------|
| cluster  | Cluster unique name                   |
| ssh_user | SSH user to be configured at instance |
| ssh_key  | SSH pubkey                            |

**File:** `cka-playground/terraform/environments/cka01/provider.tf`

| Variable    | Description                     |
|-------------|---------------------------------|
| credentials | In case you want to change path |
| project     | GCP project                     |
| region      | GCP region pubkey               |
| zone        | GCP zone                        |

Change to folder `cka-playground/terraform/environments/cka01` and allow Terraform to work on

~~~bash
$ terraform init

Initializing modules...
- cka01_infra in ../../modules/cka-infra
- cka01_network in ../../modules/cka-network

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "google" (hashicorp/google) 3.16.0...
...
~~~

~~~bash
$ terraform apply

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:
...
~~~

In the end you should have your infra available at GCP

#### Infra configuration

Now allow Ansible to configure stuff... Based on dynamic inventory plugin.

Instructions collected at [K8S docs](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

Ansible will configure to you:
* Let iptables see bridged traffic
* Disable UFW firewall
* Install runtime (Docker)
* Install kubeadm, kubelet and kubectl
* Install ETCD v3

In the end your cluster will be ready to be initiated/configured with kubeadm tool.

Vars to be changed on Ansible code:

**File:** `cka-playground/ansible/inventory.gcp.yml`

| Variable             | Description                                              |
|----------------------|----------------------------------------------------------|
| projects             | GCP project                                              |
| regions              | GCP region(s) or zone(s) if you want to be more specific |
| service_account_file | Path to GCP JSON file                                    |

Change to folder `cka-playground/ansible`

You can test your config if you try to list inventory:
~~~bash
$ ansible-inventory -i inventory.gcp.yml --graph
@all:
  |--@master:
  |  |--1.1.1.1
  |--@ungrouped:
  |--@workers:
  |  |--1.1.1.2
  |  |--1.1.1.3
  |  |--1.1.1.4
~~~

To config instances:
~~~bash
$ ansible-playbook -i inventory.gcp.yml -b -u SSH-USER cka-setup.yml


PLAY [Install CKA stack] ******************************************************************

TASK [Gathering Facts]
...redacted

TASK [Install etcd v3] ********************************************************************
skipping: [1.1.1.2]
skipping: [1.1.1.3]
skipping: [1.1.1.4]
changed: [1.1.1.1]

PLAY RECAP ********************************************************************************
1.1.1.2               : ok=12   changed=11   unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
1.1.1.1               : ok=13   changed=12   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
1.1.1.3               : ok=12   changed=11   unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
1.1.1.4               : ok=12   changed=11   unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
~~~

SSH to master and conquer the world!!

### Destroy

Change to folder `cka-playground/terraform/environments/cka01` and allow Terraform to work on

~~~bash
$ terraform destroy
module.cka01_network.google_compute_network.vpc: Refreshing state... [id=projects...
~~~

## Optional

### Multiple CKA env

Don't know if you need, but imagine that you want at the same time two, or more, CKA cluster to test things (just because yes!).

Simple create a copy of folder `cka01` to `cka02` (example) and change parameters like mentioned above.
Repeat all necessary steps for this new cluster environment
