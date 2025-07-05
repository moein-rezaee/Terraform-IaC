  # راهنمای کامل نصب Kubernetes با استفاده از `kubeadm` و Calico (با Helm)

این داکیومنت به صورت گام‌به‌گام نحوه نصب Kubernetes را توضیح می‌دهد. تمام نکات مهم، مشکلات احتمالی و راه‌حل‌ها در قالب **نکته** ذکر شده‌اند.

---

## **فهرست مطالب**
1. [پیش‌نیازها](#پیش-نیازها)
2. [مرحله 1: تنظیمات اولیه سیستم](#مرحله-1-تنظیمات-اولیه-سیستم)
3. [مرحله 2: نصب Container Runtime (`containerd`)](#مرحله-2-نصب-container-runtime-containerd)
4. [مرحله 3: نصب Kubernetes Components](#مرحله-3-نصب-kubernetes-components)
5. [مرحله 4: راه‌اندازی Kubernetes با `kubeadm`](#مرحله-4-راه-اندازی-kubernetes-با-kubeadm)
6. [مرحله 5: نصب شبکه CNI با Calico (با Helm)](#مرحله-5-نصب-شبکه-cni-با-calico-با-helm)
7. [نکات مهم و مشکلات رایج](#نکات-مهم-و-مشکلات-رایج)

---

## **پیش‌نیازها**

- **توزیع لینوکس:** Ubuntu 20.04 یا بالاتر (یا CentOS 7/8).
- **حداقل منابع سخت‌افزاری:**
  - CPU: حداقل 2 هسته.
  - RAM: حداقل 2 گیگابایت.
  - فضای دیسک: حداقل 20 گیگابایت.
- **دسترسی به اینترنت:** برای Pull تصاویر Docker و دانلود فایل‌های مورد نیاز.
- **Hostname مناسب:** Hostname باید منحصر به فرد و بدون فاصله باشد.

---

## **مرحله 1: تنظیمات اولیه سیستم**

### **1.1. تنظیم Hostname**
```bash
ssh-keygen -R 82.115.21.193

sudo hostnamectl set-hostname <YOUR_HOSTNAME>
```

**نکته:** Hostname باید منحصر به فرد باشد. مثلاً `master-node` یا `worker-node`.

### **1.2. تنظیم فایل `/etc/hosts`**
```bash
sudo nano /etc/hosts
```

محتوای زیر را اضافه کنید:
```plaintext
<IP_ADDRESS>    <YOUR_HOSTNAME>
```

**مثال:**
```plaintext
192.168.1.10    master-node
```

### **1.3. غیرفعال کردن Swap**
```bash
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
```

**نکته:** Kubernetes از Swap پشتیبانی نمی‌کند و باید آن را غیرفعال کنید.

### **1.4. بارگذاری ماژول‌های Kernel**
```bash
sudo modprobe overlay
sudo modprobe br_netfilter
```

برای بارگذاری دائمی ماژول‌ها:
```bash
echo "overlay" | sudo tee /etc/modules-load.d/overlay.conf
echo "br_netfilter" | sudo tee /etc/modules-load.d/br_netfilter.conf
```

### **1.5. تنظیمات شبکه Kernel**
```bash
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system
```

---

## **مرحله 2: نصب Container Runtime (`containerd`)**

### **2.1. نصب `containerd`**
```bash
sudo apt update
sudo apt install -y containerd
```

### **2.2. ایجاد فایل پیکربندی `containerd`**
```bash
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
```

### **2.3. تنظیم `SystemdCgroup`**
در فایل `/etc/containerd/config.toml`، خط زیر را پیدا کنید و مقدار آن را به `true` تغییر دهید:
```toml
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
  SystemdCgroup = true
```

### **2.4. ری‌استارت `containerd`**
```bash
sudo systemctl restart containerd
sudo systemctl enable containerd
```

**نکته:** اگر تصویر Sandbox (`pause`) وجود ندارد، آن را به صورت دستی Pull کنید:
```bash
sudo crictl pull registry.k8s.io/pause:3.10
```

---

## **مرحله 3: نصب Kubernetes Components**

### **3.1. اضافه کردن Repository Kubernetes**
```bash
sudo apt update && sudo apt install -y curl apt-transport-https
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
```

### **3.2. نصب Kubernetes Components**
```bash
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

**نکته:** با استفاده از `apt-mark hold`، جلوگیری می‌کنیم که نسخه‌های جدیدتر به صورت خودکار نصب شوند.

---

## **مرحله 4: راه‌اندازی Kubernetes با `kubeadm`**

### **4.1. اجرای `kubeadm init`**
```bash
sudo kubeadm init --pod-network-cidr=192.168.0.0/16
```

**نکته:** اگر خطایی در راه‌اندازی API Server یا `etcd` مشاهده کردید:
- لاگ‌های `kubelet` و `containerd` را بررسی کنید.
- مطمئن شوید که `SystemdCgroup` و `cgroup-driver` به درستی تنظیم شده‌اند.

### **4.2. تنظیم فایل پیکربندی `kubectl`**
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### **4.3. بررسی وضعیت Node**
```bash
kubectl get nodes
```

**نکته:** وضعیت Node ابتدا `NotReady` است، زیرا شبکه CNI هنوز نصب نشده است.

---

## **مرحله 5: نصب شبکه CNI با Calico (با Helm)**

### **5.1. نصب Helm**
```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

### **5.2. اضافه کردن Repository Calico**
```bash
helm repo add projectcalico https://projectcalico.docs.tigera.io/charts
helm repo update
```

### **5.3. نصب Calico**
```bash
helm install calico projectcalico/tigera-operator --namespace kube-system --create-namespace
```

### **5.4. بررسی وضعیت Pods**
```bash
kubectl get pods -n kube-system
```

**نکته:** اگر Pods Calico به حالت `Running` نرسیدند، لاگ‌های آن‌ها را بررسی کنید:
```bash
kubectl logs <POD_NAME> -n kube-system
```

### **5.5. بررسی وضعیت Node**
```bash
kubectl get nodes
```

وضعیت Node باید به `Ready` تغییر کند.

### **5.6. صادر کردن مجوز برای نود مستر برای ران کردن پاد ها Node**
```bash
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
```



---

## **نکات مهم و مشکلات رایج**

### **1. مشکل در راه‌اندازی API Server یا `etcd`**
- **علت:** معمولاً به دلیل تنظیمات نادرست `containerd` یا `kubelet`.
- **راه‌حل:**
  - لاگ‌های `kubelet` و `containerd` را بررسی کنید.
  - مطمئن شوید که `SystemdCgroup` و `cgroup-driver` به درستی تنظیم شده‌اند.

### **2. Node در حالت `NotReady` قرار دارد**
- **علت:** شبکه CNI نصب نشده است.
- **راه‌حل:** Calico یا Flannel را نصب کنید.

### **3. تصویر Sandbox (`pause`) وجود ندارد**
- **علت:** `containerd` نمی‌تواند تصویر Sandbox را Pull کند.
- **راه‌حل:**
```bash
sudo crictl pull registry.k8s.io/pause:3.10
```

### **4. مشکل در اتصال به API Server**
- **علت:** تنظیمات DNS یا Hostname نادرست است.
- **راه‌حل:**
  - فایل `/etc/hosts` را بررسی کنید.
  - مطمئن شوید که Hostname به درستی تنظیم شده است.

---

## **جمع‌بندی**



# دستورات مدیریتی Kubernetes (کامل و دسته‌بندی شده)

```bash
# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                            مدیریت کلی Kubernetes                           │
# └─────────────────────────────────────────────────────────────────────────────┘

# نمایش وضعیت کلی کلاستر
kubectl cluster-info
kubectl get componentstatuses

# نمایش تنظیمات پیکربندی فعلی
kubectl config view
kubectl config current-context

# تغییر کانتکست
kubectl config use-context <نام-کانتکست>

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                            مدیریت Namespace                                │
# └─────────────────────────────────────────────────────────────────────────────┘

# لیست Namespace ها
kubectl get namespaces

# ایجاد و حذف Namespace
kubectl create namespace <نام>
kubectl delete namespace <نام>

# تنظیم Namespace پیش‌فرض
kubectl config set-context --current --namespace=<نام-نیومسپیس>

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                            مدیریت Podها                                    │
# └─────────────────────────────────────────────────────────────────────────────┘

# لیست Podها
kubectl get pods [-n <نام-نیومسپیس>] [--watch]
kubectl get pods -o wide  # نمایش اطلاعات گسترده‌تر

# نمایش جزئیات Pod
kubectl describe pod <نام-پاد>

# لاگ‌های Pod
kubectl logs <نام-پاد> [-c <نام-کانتینر>]
kubectl logs -f <نام-پاد>  # دنبال کردن لاگ‌ها

# اجرای دستور در داخل Pod
kubectl exec -it <نام-پاد> -- <دستور>
kubectl exec -it <نام-پاد> -c <نام-کانتینر> -- <دستور>

# حذف Pod
kubectl delete pod <نام-پاد>

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                            مدیریت Deployments                             │
# └─────────────────────────────────────────────────────────────────────────────┘

# لیست Deployments
kubectl get deployments

# ایجاد Deployment
kubectl create deployment <نام> --image=<نام-ایمیج>

# نمایش جزئیات Deployment
kubectl describe deployment <نام>

# مقیاس‌دهی Deployment
kubectl scale deployment <نام> --replicas=<تعداد>

# به‌روزرسانی Deployment
kubectl set image deployment/<نام> <کانتینر>=<ایمیج-جدید>
kubectl rollout status deployment/<نام>

# بازگردانی Deployment
kubectl rollout undo deployment/<نام>

# حذف Deployment
kubectl delete deployment <نام>

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                            مدیریت Services                                │
# └─────────────────────────────────────────────────────────────────────────────┘

# لیست Services
kubectl get services

# ایجاد Service
kubectl expose deployment <نام> --port=<پورت> --target-port=<پورت-مقصد> --type=<نوع>

# نمایش جزئیات Service
kubectl describe service <نام>

# حذف Service
kubectl delete service <نام>

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                            مدیریت ConfigMaps و Secrets                    │
# └─────────────────────────────────────────────────────────────────────────────┘

# مدیریت ConfigMaps
kubectl get configmaps
kubectl create configmap <نام> --from-file=<مسیر-فایل>
kubectl describe configmap <نام>

# مدیریت Secrets
kubectl get secrets
kubectl create secret generic <نام> --from-literal=<کلید>=<مقدار>
kubectl describe secret <نام>

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                            مدیریت StatefulSets و DaemonSets               │
# └─────────────────────────────────────────────────────────────────────────────┘

# مدیریت StatefulSets
kubectl get statefulsets
kubectl describe statefulset <نام>

# مدیریت DaemonSets
kubectl get daemonsets
kubectl describe daemonset <نام>

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                            مدیریت PersistentVolumes و PersistentVolumeClaims│
# └─────────────────────────────────────────────────────────────────────────────┘

# مدیریت PV و PVC
kubectl get pv
kubectl get pvc
kubectl describe pv <نام>
kubectl describe pvc <نام>

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                            مدیریت Ingress                                 │
# └─────────────────────────────────────────────────────────────────────────────┘

# لیست Ingressها
kubectl get ingress

# نمایش جزئیات Ingress
kubectl describe ingress <نام>

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                            مدیریت Jobs و CronJobs                         │
# └─────────────────────────────────────────────────────────────────────────────┘

# مدیریت Jobs
kubectl get jobs
kubectl describe job <نام>

# مدیریت CronJobs
kubectl get cronjobs
kubectl describe cronjob <نام>

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                            مدیریت منابع                                   │
# └─────────────────────────────────────────────────────────────────────────────┘

# نمایش مصرف منابع
kubectl top nodes
kubectl top pods

# نمایش منابع اختصاص داده شده
kubectl get pods -o=jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[*].resources}{"\n"}{end}'

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                            دستورات عیب‌یابی                                │
# └─────────────────────────────────────────────────────────────────────────────┘

# بررسی رویدادهای کلاستر
kubectl get events --sort-by='.metadata.creationTimestamp'

# بررسی وضعیت Nodeها
kubectl get nodes
kubectl describe node <نام-نود>

# بررسی شبکه
kubectl run -it --rm --restart=Never network-test --image=alpine -- sh -c 'ping <آیپی>'

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                            دستورات پیشرفته                                 │
# └─────────────────────────────────────────────────────────────────────────────┘

# Port Forwarding
kubectl port-forward <نام-پاد> <پورت-محلی>:<پورت-پاد>

# ایجاد منبع از فایل YAML
kubectl apply -f <فایل.yaml>
kubectl delete -f <فایل.yaml>

# خروجی JSON برای اشیا
kubectl get <نوع> <نام> -o json
kubectl get <نوع> <نام> -o yaml

# ویرایش منبع در حال اجرا
kubectl edit <نوع> <نام>

# لیست APIهای موجود
kubectl api-resources
kubectl api-versions

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                            دستورات کاربردی برای توسعه‌دهندگان             │
# └─────────────────────────────────────────────────────────────────────────────┘

# ساخت فایل YAML از یک منبع موجود
kubectl get <نوع> <نام> -o yaml --export > <فایل.yaml>

# اجرای موقت Pod برای تست
kubectl run -it --rm --restart=Never test-pod --image=alpine -- sh

# بررسی دسترسی به سرویس‌ها
kubectl run -it --rm --restart=Never curl --image=curlimages/curl -- curl http://<سرویس>.<نیومسپیس>.svc.cluster.local
```




kubeadm join 82.115.21.193:6443 --token p5211u.jyqc0d21kl1ye6k1 \
	--discovery-token-ca-cert-hash sha256:8890e316351b06b375acc12f7b6c2fd80014822d5c78c96e3a9c15e506ed20b5 
