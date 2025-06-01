
# 🚀 Mafialegends IaC (Infrastructure as Code)

Manage all of your infrastructure **as code** using [Terraform](https://www.terraform.io/) – modular, reproducible, and production-ready.

---

## 📖 Overview

This repository provides the full Terraform codebase for deploying, managing, and evolving the infrastructure behind the Mafialegends project.  
It is modular, extensible, and ready to support real-world development, staging, and production environments.

---

## 🌟 Features

- **Modular Design:** Every building block (database, services, secrets, storage, etc.) is implemented as a reusable module or service.
- **Multi-environment:** Separate configuration for `dev`, `prod`, and more.
- **GitOps-Friendly:** All changes are traceable and auditable through version control.
- **Secure by Design:** (Secret management planned – see roadmap below)
- **Easy to Extend:** Add or change services quickly by adding a module and wiring it up in your environment.

---

## 📁 Project Structure

```plaintext
infrastructure/
├── environments/
│   ├── dev/
│   └── prod/
├── modules/
│   ├── helm_release
│   ├── k8s_secret
│   └── local_path_provisioner
├── services/
│   ├── argocd
│   ├── gitea
│   ├── harbor
│   ├── ingress-nginx
│   ├── plane
│   ├── postgresql
│   ├── rabbitmq
│   ├── redis
│   └── woodpecker
├── README.md
```

---

## 🚀 Getting Started

### 1. Clone the repository
```shell
git clone https://github.com/mafialegends/iac.git
cd iac/infrastructure/environments/dev
```

### 2. Configure your environment variables
Copy and adjust the provided tfvars example:
```shell
cp terraform.tfvars.example terraform.tfvars
# Edit the file as needed for your environment
```

### 3. Initialize and apply Terraform
```shell
terraform init
terraform plan
terraform apply
```

### 4. (Optional) Destroy resources
```shell
terraform destroy
```

---

## 📦 Modules & Services

> **Currently implemented:**

```plaintext
modules/
  ├─ helm_release
  ├─ k8s_secret
  ├─ local_path_provisioner

services/
  ├─ argocd
  ├─ gitea
  ├─ harbor
  ├─ ingress-nginx
  ├─ plane
  ├─ postgresql
  ├─ rabbitmq
  ├─ redis
  ├─ woodpecker
```

---

## 🚧 Roadmap & Vision

- **Vault integration** and advanced secret management:  
  Currently, Vault support is removed for simplicity. Secure secrets management (Vault, ESO, etc.) is a high-priority roadmap item.  
  *Interested in this? Your contribution is very welcome!*

---

## 🤝 Contributing

- **Fork** this repo, push your branch, and open a Pull Request.
- Please keep code modular, well-documented, and formatted (`terraform fmt`).
- For any changes in secrets or sensitive flows, avoid hard-coding credentials and prefer using secure mechanisms.
- Open issues for bugs, feature requests, or improvement ideas.

---

## 📝 License

Distributed under the [MIT License](LICENSE).

---

## 💬 Questions & Discussions

- Open an [issue](https://github.com/mafialegends/iac/issues) or [start a discussion](https://github.com/mafialegends/iac/discussions).

---

**Professional, reproducible, and extensible infrastructure for everyone!**
