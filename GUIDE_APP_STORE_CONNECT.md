# 📱 Guide de configuration App Store Connect pour FriendZone

Ce guide vous explique étape par étape comment configurer App Store Connect pour activer les **vrais achats In-App** dans FriendZone.

## 🎯 **État actuel**

✅ **Code implémenté** : L'intégration StoreKit complète est prête dans `PremiumManager.swift`
✅ **Compilation réussie** : Le projet compile sans erreurs
⚠️ **Configuration nécessaire** : Vous devez configurer App Store Connect

## 📋 **Étapes à suivre dans App Store Connect**

### **Étape 1 : Accéder à App Store Connect**
1. Allez sur [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
2. Connectez-vous avec votre compte développeur Apple
3. Sélectionnez votre app **FriendZone**

### **Étape 2 : Créer le produit In-App**

#### **2.1. Accéder aux Achats intégrés**
- Menu de gauche : **Fonctionnalités** → **Achats intégrés**
- Cliquez sur le bouton **+** (Créer)

#### **2.2. Configurer le produit**
- **Type de produit** : Sélectionnez **Non consommable**
  - *Pourquoi Non consommable ?* : L'utilisateur achète le pack premium une fois, il reste actif à vie.

- **Référence du produit** : 
  ```
  fz_premium_pack_1.99
  ```
  - ⚠️ **IMPORTANT** : Cet identifiant doit correspondre EXACTEMENT à celui dans le code
  - **Identifiant Apple** : 6761523018 (pour référence dans App Store Connect)

- **Nom du produit** : 
  - Français : "Pack Premium FriendZone"
  - Anglais : "FriendZone Premium Pack"

- **Description** :
  - Français : "Accédez à toutes les fonctionnalités premium : analyses détaillées, conseils personnalisés, pas de publicités."
  - Anglais : "Access all premium features: detailed analysis, personalized advice, no ads."

#### **2.3. Configurer les prix**
- **Plan tarifaire** : Sélectionnez un prix
- **Prix suggéré** : 4,99 € (ou équivalent dans d'autres devises)
- **Disponibilité** : Tous les pays/régions

### **Étape 3 : Configurer les accords financiers**

#### **3.1. Vérifier l'accord financier**
- Menu de gauche : **Accords, impôts et opérations bancaires**
- Vérifiez que vous avez un **accord financier actif**
- Si non, suivez le processus de signature

#### **3.2. Configurer les informations bancaires**
- Ajoutez vos informations bancaires
- Configurez la fiscalité (si applicable)

### **Étape 4 : Configurer les capacités Xcode**

#### **4.1. Dans Xcode**
1. Ouvrez `FriendZone.xcodeproj`
2. Sélectionnez la cible **FriendZone**
3. Onglet **Signing & Capabilities**
4. Cliquez sur **+ Capability**
5. Ajoutez **In-App Purchase**

#### **4.2. Vérifier les certificats**
- Assurez-vous que les certificats de signature sont valides
- Vérifiez que le bundle identifier correspond à celui d'App Store Connect

## 🔧 **Placeholders dans le code**

### **1. Identifiant du produit (Ligne 48 dans PremiumManager.swift)**
```swift
// ⚠️ PLACEHOLDER IMPORTANT : IDENTIFIANT DU PRODUIT
// À CONFIGURER DANS APP STORE CONNECT :
// 1. Allez sur App Store Connect → FriendZone → Fonctionnalités → Achats intégrés
// 2. Créez un produit "Non consommable" avec cet identifiant :
private let premiumProductID = "fz_premium_pack_1.99"
// 3. Prix suggéré : 4,99 € (Non consommable - l'utilisateur achète une fois)
// 4. Identifiant Apple : 6761523018 (pour référence dans App Store Connect)
```

### **2. Validation des identifiants (Ligne 185-193 dans PremiumManager.swift)**
```swift
// ⚠️ PLACEHOLDER IMPORTANT : CONFIGURATION APP STORE CONNECT
// Si vous voyez ce message, vérifiez que :
// 1. Le produit est créé dans App Store Connect
// 2. L'identifiant correspond exactement : "fz_premium_pack_1.99"
// 3. Le produit est approuvé et actif
// 4. L'accord financier est signé
// 5. Identifiant Apple : 6761523018
```

### **3. Validation des reçus (Ligne 218-221)**
```swift
// ⚠️ PLACEHOLDER IMPORTANT : VALIDATION DE RECEIPT
// En production, vous devriez valider le reçu avec votre serveur
// pour prévenir la fraude. Apple recommande la validation serveur.
```

## 🧪 **Tests en sandbox**

### **1. Créer des comptes test**
- Dans App Store Connect : **Utilisateurs et accès** → **Testeurs Sandbox**
- Créez un compte test pour chaque région à tester

### **2. Tester les achats**
1. Compilez l'app en mode **Release** (pas Debug)
2. Installez sur un appareil de test
3. Utilisez le compte Sandbox pour les achats
4. Testez tous les scénarios :
   - Achat réussi
   - Annulation
   - Restauration
   - Échec de paiement

### **3. Scénarios de test obligatoires**
- ✅ Achat initial
- ✅ Restauration sur nouvel appareil
- ✅ Annulation pendant l'achat
- ✅ Pas de connexion Internet
- ✅ Changement de région

## 🚀 **Passage en production**

### **1. Désactiver le mode test**
Dans `PremiumManager.swift`, modifiez :
```swift
#if DEBUG
// Mode test activé pour le développement
isTestMode = true
#else
// En production, désactiver le mode test
isTestMode = false
loadProducts()
#endif
```

### **2. Validation serveur (Recommandé)**
Pour prévenir la fraude, implémentez la validation serveur :
1. Créez un endpoint sur votre serveur
2. Envoyez le reçu d'achat pour validation
3. Vérifiez la signature avec Apple

### **3. Soumission à l'App Store**
1. **Version** : Incrémentez le numéro de version
2. **Notes de version** : Décrivez les nouvelles fonctionnalités
3. **Capture d'écran** : Ajoutez des screenshots de l'achat In-App
4. **Informations de conformité** : Répondez aux questions sur les achats

## ⚠️ **Points de contrôle critiques**

### **Avant la soumission :**
- [ ] Produit créé dans App Store Connect
- [ ] Identifiant correspond exactement au code
- [ ] Accord financier signé
- [ ] Prix configuré
- [ ] Tests sandbox réussis
- [ ] Mode test désactivé en production
- [ ] Messages d'erreur localisés

### **Risques de rejet :**
- ❌ "L'achat In-App ne fonctionne pas"
- ❌ "Pas de restauration des achats"
- ❌ "Interface utilisateur trompeuse"
- ❌ "Produit non disponible"

## 📞 **Support et dépannage**

### **Erreurs courantes :**

#### **"Identifiants de produits invalides"**
- Vérifiez que l'identifiant correspond exactement
- Vérifiez que le produit est **actif** dans App Store Connect
- Vérifiez l'accord financier

#### **"Achat échoué" en sandbox**
- Utilisez un compte Sandbox, pas un vrai compte
- Vérifiez la connexion Internet
- Essayez sur un appareil physique, pas simulateur

#### **"Produit non disponible"**
- Attendez 24h après la création du produit
- Vérifiez la région du compte test
- Vérifiez les restrictions d'âge

## 🎉 **Félicitations !**

Une fois ces étapes terminées, votre app FriendZone sera prête pour les **vrais achats In-App** ! Les utilisateurs pourront acheter le pack premium directement depuis l'app, et vous commencerez à générer des revenus.

**Prochaines étapes :**
1. Configurer App Store Connect (ce guide)
2. Tester en sandbox
3. Soumettre à l'App Store
4. Surveiller les analytics et revenus

**Bonne chance avec la publication !** 🚀