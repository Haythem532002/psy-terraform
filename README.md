# 🏗️ **PSY DevOps Infrastructure Architecture Diagram**

## 🎨 **Visual Architecture Overview**

```
                           ┌─────────────────────────────────────────────────────────────┐
                           │                      AZURE CLOUD                            │
                           └─────────────────────────────────────────────────────────────┘
                                                        │
                                                        │
              ┌─────────────────────────────────────────┼─────────────────────────────────────────┐
              │                                         │                                         │
              │                                         │                                         │
┌─────────────▼──────────────┐                ┌────────▼──────────┐                ┌─────────────▼──────────────┐
│     INTEGRATION ENV        │                │   SHARED HUB ENV  │                │    PRE-PRODUCTION ENV      │
│      (rg-int)              │◄──────────────►│    (rg-shared)    │◄──────────────►│      (rg-preprod)          │
│    UK South Region        │   VNet Peering │   UK South Region │   VNet Peering │    UK South Region        │
└────────────────────────────┘                └───────────────────┘                └────────────────────────────┘
│                                                        │                                                        │
│  ┌──────────────────────┐                              │                             ┌──────────────────────┐   │
│  │  integration-vnet    │                              │                             │   preprod-vnet       │   │
│  │   10.0.0.0/16        │                              │                             │    10.2.0.0/16       │   │
│  └──────────────────────┘                              │                             └──────────────────────┘   │
│           │                                            │                                          │              │
│  ┌────────▼──────────┐                                 │                              ┌──────────▼────────────┐ │
│  │integration-subnet-│                                 │                              │  preprod-subnet-app   │ │
│  │app (10.0.0.0/24)  │                                 │                              │   (10.2.0.0/24)      │ │
│  │                   │                                 │                              │                       │ │
│  │┌─────────────────┐│                                 │                              │┌─────────────────────┐│ │
│  ││integration-vm   ││                                 │                              ││   preprod-vm        ││ │
│  ││Standard_B2s     ││                                 │                              ││   Standard_B2s      ││ │
│  ││Private IP Only  ││                                 │                              ││   Private IP Only   ││ │
│  ││Docker:          ││                                 │                              ││   Docker:           ││ │
│  ││- Angular App    ││                                 │                              ││   - Angular App     ││ │
│  ││- Spring Boot API││                                 │                              ││   - Spring Boot API ││ │
│  │└─────────────────┘│                                 │                              │└─────────────────────┘│ │
│  │        │          │                                 │                              │          │            │ │
│  │        ▼          │                                 │                              │          ▼            │ │
│  │┌─────────────────┐│                                 │                              │┌─────────────────────┐│ │
│  ││PostgreSQL DB    ││                                 │                              ││  PostgreSQL DB      ││ │
│  ││psy-server-int   ││                                 │                              ││  psy-server-preprod ││ │
│  ││Version 16       ││                                 │                              ││  Version 16         ││ │
│  ││Private Endpoint ││                                 │                              ││  Private Endpoint   ││ │
│  ││Database:        ││                                 │                              ││  Database:          ││ │
│  ││psy_project      ││                                 │                              ││  psy_project        ││ │
│  │└─────────────────┘│                                 │                              │└─────────────────────┘│ │
│  └───────────────────┘                                 │                              └───────────────────────┘ │
└────────────────────────────────────────────────────────┼────────────────────────────────────────────────────────┘
                                                          │
                            ┌─────────────────────────────▼─────────────────────────────┐
                            │                SHARED HUB                                 │
                            │              shared-vnet                                  │
                            │             10.1.0.0/16                                   │
                            └───────────────────────────────────────────────────────────┘
                                          │                    │
                        ┌─────────────────▼─────────┐ ┌───────▼────────────────────────┐
                        │  AzureBastionSubnet       │ │    sonarqube-subnet            │
                        │   (10.1.1.0/24)          │ │    (10.1.2.0/24)              │
                        └───────────────────────────┘ └────────────────────────────────┘
                                    │                              │
                        ┌───────────▼───────────┐      ┌─────────▼─────────────────────┐
                        │    bastion-vm         │      │      sonarqube-vm             │
                        │    Standard_B2s       │      │      Standard_B2s             │
                        │    Public IP: YES     │      │      Private IP Only          │
                        │    SSH Access Point   │      │      Code Quality Analysis    │
                        │    Gateway to all VMs │      │      Port 9000 (SonarQube)   │
                        └───────────────────────┘      └───────────────────────────────┘
                                    │
                        ┌───────────▼───────────┐
                        │   INTERNET ACCESS     │
                        │    (SSH Port 22)      │
                        └───────────────────────┘

```

## 🗄️ **Terraform State Management**

```
                            ┌─────────────────────────────────────┐
                            │         Azure Storage               │
                            │       (rg-shared)                   │
                            │                                     │
                            │  ┌─────────────────────────────────┐│
                            │  │  psy-storage-account            ││
                            │  │                                 ││
                            │  │  ┌─────────────────────────────┐││
                            │  │  │     psy-container           │││
                            │  │  │                             │││
                            │  │  │ ├─ shared.terraform.tfstate │││
                            │  │  │ ├─ integration.terraform... │││
                            │  │  │ └─ preprod.terraform.tfstate│││
                            │  │  └─────────────────────────────┘││
                            │  └─────────────────────────────────┘│
                            └─────────────────────────────────────┘
```

## 🔐 **Network Security Groups (NSG) Rules**

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                              NETWORK SECURITY RULES                                │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────────────────────┐  │
│  │   app-nsg       │    │  nsg-bastion    │    │      nsg-sonarqube             │  │
│  │  (App Subnets)  │    │ (Bastion Only)  │    │   (SonarQube VM)               │  │
│  └─────────────────┘    └─────────────────┘    └─────────────────────────────────┘  │
│           │                       │                            │                    │
│  ┌────────▼────────┐    ┌─────────▼─────────┐    ┌────────────▼────────────────────┐  │
│  │ INBOUND:        │    │ INBOUND:          │    │ INBOUND:                        │  │
│  │ • HTTP (80)     │    │ • SSH (22) - All  │    │ • SonarQube (9000) - App subnets│  │
│  │ • HTTPS (443)   │    │                   │    │ • SSH (22) - Bastion subnet     │  │
│  │ • SSH (22) -    │    │                   │    │                                 │  │
│  │   Bastion only  │    │                   │    │                                 │  │
│  │                 │    │                   │    │                                 │  │
│  │ OUTBOUND:       │    │                   │    │                                 │  │
│  │ • SonarQube     │    │                   │    │                                 │  │
│  │   (9000) to     │    │                   │    │                                 │  │
│  │   10.1.2.0/24   │    │                   │    │                                 │  │
│  └─────────────────┘    └───────────────────┘    └─────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

## 🌐 **VNet Peering Topology**

```
                            ┌───────────────────────────────────┐
                            │          HUB-SPOKE TOPOLOGY       │
                            └───────────────────────────────────┘
                                             │
                                             │
                    ┌────────────────────────▼────────────────────────┐
                    │                SHARED HUB                      │
                    │              (10.1.0.0/16)                     │
                    │            Central Services:                   │
                    │            • Bastion Host                      │
                    │            • SonarQube                         │
                    │            • Storage Account                   │
                    └────────────────┬─────────┬─────────────────────┘
                                     │         │
                        ┌────────────▼─────┐   └─────▼────────────┐
                        │  INTEGRATION     │        │ PRE-PROD    │
                        │  (10.0.0.0/16)   │        │(10.2.0.0/16)│
                        │                  │        │             │
                        │ • App VM         │        │ • App VM    │
                        │ • PostgreSQL     │        │ • PostgreSQL│
                        └──────────────────┘        └─────────────┘

            ┌─────────────────────────────────────────────────────────────┐
            │                   PEERING RULES                             │
            ├─────────────────────────────────────────────────────────────┤
            │ • Integration ↔ Shared (bidirectional)                     │
            │ • Pre-Production ↔ Shared (bidirectional)                  │
            │ • Integration ✗ Pre-Production (no direct connection)      │
            │ • All traffic flows through Shared hub                     │
            │ • Virtual network access: ENABLED                          │
            │ • Forwarded traffic: ENABLED                               │
            └─────────────────────────────────────────────────────────────┘
```

## 📊 **Resource Distribution**

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                           RESOURCE ALLOCATION                                      │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  INTEGRATION (rg-int)         │  SHARED (rg-shared)        │  PRE-PROD (rg-preprod) │
│  ────────────────────         │  ──────────────────        │  ─────────────────────  │
│  📁 Resource Group: 1         │  📁 Resource Group: 1      │  📁 Resource Group: 1   │
│  🌐 Virtual Network: 1        │  🌐 Virtual Network: 1     │  🌐 Virtual Network: 1  │
│  🔹 Subnets: 1               │  🔹 Subnets: 2             │  🔹 Subnets: 1          │
│  💻 Virtual Machines: 1       │  💻 Virtual Machines: 2    │  💻 Virtual Machines: 1 │
│  🗄️ PostgreSQL Servers: 1     │  💾 Storage Account: 1     │  🗄️ PostgreSQL Servers: 1│
│  📡 Public IPs: 0            │  📡 Public IPs: 1          │  📡 Public IPs: 0       │
│  🛡️ NSGs: 1                  │  🛡️ NSGs: 2                │  🛡️ NSGs: 1             │
│                               │  📦 Storage Container: 1   │                         │
│                               │                            │                         │
│  TOTAL COST: ~$90/month      │  TOTAL COST: ~$90/month    │  TOTAL COST: ~$90/month │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

## 🔄 **Data Flow Diagram**

```
                    ┌─────────────────────────────────────────────────────────┐
                    │                    DATA FLOWS                           │
                    └─────────────────────────────────────────────────────────┘

      🌐 INTERNET                     SSH (22)                    📱 DEVELOPER
           │                            │                             │
           ▼                            ▼                             ▼
   ┌───────────────┐              ┌──────────────┐              ┌─────────────┐
   │               │              │              │              │             │
   │ Load Balancer │              │ bastion-vm   │              │ Local Dev   │
   │ (Future)      │──────────────┤ Public IP    │◄─────────────┤ Environment │
   │               │   HTTP/HTTPS │ UK South     │   SSH Access │             │
   └───────────────┘              └──────┬───────┘              └─────────────┘
           │                             │
           ▼                             ▼
   ┌───────────────┐              ┌──────────────┐
   │ integration-vm│◄─────────────┤ SSH Tunnel   │
   │ preprod-vm    │   SSH (22)   │ via Bastion  │
   │               │              └──────────────┘
   │ ┌───────────┐ │                     │
   │ │ Angular   │ │                     ▼
   │ │ Frontend  │ │              ┌──────────────┐
   │ └─────┬─────┘ │              │ sonarqube-vm │
   │       │       │              │ Code Quality │
   │ ┌─────▼─────┐ │              │ Analysis     │
   │ │Spring Boot│ │◄─────────────┤ Port 9000    │
   │ │ Backend   │ │   Code Scan  └──────────────┘
   │ └─────┬─────┘ │
   │       │       │
   └───────┼───────┘
           ▼
   ┌───────────────┐
   │ PostgreSQL    │
   │ Flexible      │
   │ Server        │
   │ Private       │
   │ Endpoint      │
   └───────────────┘
```

## 🚀 **Deployment Flow**

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                              DEPLOYMENT SEQUENCE                                   │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  STEP 1: SHARED                STEP 2: INTEGRATION           STEP 3: PRE-PRODUCTION │
│  ──────────────                ────────────────────          ─────────────────────  │
│                                                                                     │
│  1. terraform init             1. terraform init             1. terraform init      │
│  2. terraform plan             2. terraform plan             2. terraform plan      │
│  3. terraform apply            3. terraform apply            3. terraform apply     │
│                                                                                     │
│  Creates:                      Creates:                      Creates:               │
│  • Storage Account             • Integration RG              • Pre-prod RG          │
│  • Bastion VM                  • Integration VNet            • Pre-prod VNet        │
│  • SonarQube VM                • Integration VM              • Pre-prod VM          │
│  • Shared VNet                 • PostgreSQL Server          • PostgreSQL Server    │
│  • Backend Storage             • VNet Peering               • VNet Peering         │
│                                                                                     │
│  ⏱️ Duration: 10-15 min        ⏱️ Duration: 8-12 min         ⏱️ Duration: 8-12 min  │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 📋 **Architecture Summary**

This diagram represents a **production-ready, multi-environment Azure infrastructure** with:

### **🏗️ Core Architecture**

- **Hub-and-Spoke Network Topology** with centralized services
- **3 Environments**: Integration, Pre-Production, and Shared
- **Environment Isolation** with separate resource groups and VNets
- **Centralized Access** through bastion host for security

### **🔐 Security Features**

- **Private Endpoints** for all databases
- **No Public IPs** on application VMs
- **Network Security Groups** with restrictive rules
- **Bastion Host** as single point of entry
- **Network Segmentation** with dedicated subnets

### **⚡ DevOps Integration**

- **SonarQube** for code quality analysis
- **Terraform State Management** with remote backend
- **Infrastructure as Code** with modular design
- **Environment Parity** for consistent deployments

This architecture provides a **scalable, secure, and maintainable foundation** for your PSY DevOps project! 🎉
