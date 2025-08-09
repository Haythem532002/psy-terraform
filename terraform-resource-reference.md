## 🧱 Liste des ressources à créer avec Terraform

### 🔹 1. **Groupes de ressources (Resource Groups)**

| Nom          | Rôle                                                                |
| ------------ | ------------------------------------------------------------------- |
| `rg-int`     | Regroupe toutes les ressources de l’environnement **Intégration**   |
| `rg-preprod` | Regroupe toutes les ressources de l’environnement **Préproduction** |

---

### 🔹 2. **Machines virtuelles (VMs)**

| Nom de la VM     | Environnement | Rôle                                                                |
| ---------------- | ------------- | ------------------------------------------------------------------- |
| `vm-app-int`     | Intégration   | Héberge ton **site Angular** et ton **API Spring Boot** en Docker   |
| `vm-app-preprod` | Préproduction | Même rôle que ci-dessus, mais pour l’environnement de préprod       |
| `vm-sonarqube`   | Global        | Contient **SonarQube**, l’outil d’analyse qualité de code           |
| `vm-bastion`     | Global        | **Point d’accès sécurisé** pour se connecter aux autres VMs via SSH |

---

### 🔹 3. **Réseaux virtuels (Virtual Networks) et Sous-réseaux**

| Nom du VNet        | Rôle                                                          |
| ------------------ | ------------------------------------------------------------- |
| `vnet-int`         | Réseau privé pour les ressources de l’intégration             |
| `vnet-preprod`     | Réseau privé pour les ressources de la préproduction          |
| `subnet-app`       | Sous-réseau pour les VMs app (`vm-app-int`, `vm-app-preprod`) |
| `subnet-bastion`   | Sous-réseau pour la VM Bastion                                |
| `subnet-sonarqube` | Sous-réseau pour la VM SonarQube                              |

---

### 🔹 4. **Groupes de sécurité réseau (NSG - Network Security Groups)**

| Nom             | Rôle                                                                                |
| --------------- | ----------------------------------------------------------------------------------- |
| `nsg-app`       | Autoriser les ports nécessaires à l’application (HTTP 80, HTTPS 443, etc.)          |
| `nsg-bastion`   | Autoriser uniquement **SSH (port 22)** depuis ton IP pour se connecter à la bastion |
| `nsg-sonarqube` | Autoriser accès à SonarQube (ex: port 9000) uniquement depuis GitHub Actions        |

---

### 🔹 5. **Adresse IP publique**

| Nom                          | Rôle                                             |
| ---------------------------- | ------------------------------------------------ |
| `ip-bastion`                 | Permet de se connecter à la VM Bastion           |
| `ip-app-int` (optionnel)     | Pour accéder à l’app d’intégration si nécessaire |
| `ip-app-preprod` (optionnel) | Pour accéder à l’app de préprod si nécessaire    |

---

### 🔹 6. **Base de données Azure PostgreSQL**

| Nom         | Rôle                                                 |
| ----------- | ---------------------------------------------------- |
| `pg-app-db` | Base de données managée pour ton backend Spring Boot |

---

## ✅ Résumé simplifié

| Catégorie              | Ressources (noms)                                            | Utilité principale                                |
| ---------------------- | ------------------------------------------------------------ | ------------------------------------------------- |
| **Groupes**            | `rg-int`, `rg-preprod`                                       | Organiser les ressources par environnement        |
| **VMs**                | `vm-app-int`, `vm-app-preprod`, `vm-sonarqube`, `vm-bastion` | Héberger ton app, SonarQube, et accéder au réseau |
| **Réseaux**            | `vnet-int`, `vnet-preprod`, `subnet-app`, `subnet-bastion`   | Créer un réseau privé sécurisé                    |
| **NSGs**               | `nsg-app`, `nsg-bastion`, `nsg-sonarqube`                    | Contrôler l'accès aux VMs (ouvrir ports)          |
| **IP publiques**       | `ip-bastion`, `ip-app-int`, `ip-app-preprod`                 | Accès externe aux VMs si nécessaire               |
| **Base de données**    | `pg-app-db`                                                  | Gérer les données de l’application (Spring Boot)  |
| **Container Registry** | `acr-devops-app`                                             | Stocker et récupérer les images Docker            |
