# 🚀 Guide rapide : Créer une archive pour TestFlight

## 📋 **Checklist avant de commencer**

### **Configuration Xcode :**
- [ ] **Version/Build** incrémentés
  - **Version** : Ex: `1.0` (première version)
  - **Build** : Ex: `2` (incrémentez à chaque archive)
- [ ] **Team** : Votre équipe Apple Developer sélectionnée
- [ ] **Bundle Identifier** : `sliceofdigital.FriendZone`
- [ ] **Signing** : Automatique activé

### **Code :**
- [ ] **Mode test activé** pour TestFlight (déjà fait)
- [ ] **PremiumManager** : `isTestMode = true` en DEBUG
- [ ] **Compilation réussie** : ✅ **BUILD SUCCEEDED**

## 📱 **Étapes pour créer l'archive**

### **Étape 1 : Nettoyer le projet**
```bash
cd /Users/wills/Downloads/FriendZone
xcodebuild clean -project FriendZone.xcodeproj -scheme FriendZone
```

### **Étape 2 : Vérifier les paramètres**
1. **Ouvrir Xcode** : `open FriendZone.xcodeproj`
2. **Sélectionner la cible** : FriendZone
3. **Onglet General** :
   - **Version** : Incrémentez si nécessaire
   - **Build** : Incrémentez (ex: 1 → 2)
4. **Team** : Sélectionnez votre équipe

### **Étape 3 : Créer l'archive**
1. **Device** : Sélectionner **"Any iOS Device"** (⚠️ PAS un simulateur)
2. **Product → Archive** (⇧⌘B)
3. **Attendre** la fin de la génération (2-5 minutes)

### **Étape 4 : Valider l'archive**
1. **Window → Organizer** s'ouvre automatiquement
2. **Sélectionner votre archive**
3. **Cliquer sur "Validate App"**
4. **Résoudre les problèmes** si nécessaire

### **Étape 5 : Distribuer à TestFlight**
1. **Dans Organizer** : Cliquer sur **"Distribute App"**
2. **Destination** : "App Store Connect"
3. **Method** : "Upload"
4. **Distribution** : "TestFlight and App Store"
5. **Options** :
   - ✅ **Upload your app's symbols**
   - ✅ **Include bitcode**
   - ✅ **Strip Swift symbols**
6. **Suivre les étapes** jusqu'au téléversement

## ⚠️ **Problèmes courants et solutions**

### **Problème 1 : "No matching provisioning profile"**
**Solution :**
1. **Xcode → Preferences → Accounts**
2. Sélectionnez votre compte
3. **Download Manual Profiles**
4. **Product → Clean Build Folder**

### **Problème 2 : "Archive not created"**
**Solution :**
```bash
# Terminal
cd /Users/wills/Downloads/FriendZone
rm -rf ~/Library/Developer/Xcode/DerivedData/FriendZone-*
```

### **Problème 3 : "In-App Purchase capability missing"**
**Solution (pour TestFlight) :**
C'est NORMAL ! Pour TestFlight, nous utilisons le mode test.
- ✅ **Premium fonctionne** en mode simulation
- ✅ **Pas de configuration StoreKit** nécessaire
- ✅ **TestFlight accepte** l'archive sans capability

## 🧪 **Ce que TestFlight testera**

### **Fonctionnalités VALIDÉES :**
- ✅ **Interface utilisateur** : Complète et responsive
- ✅ **Questions/réponses** : Personnalisation par genre
- ✅ **Analyse résultats** : Calcul des scores
- ✅ **Premium (mode test)** : Activation/désactivation
- ✅ **Synchronisation** : PremiumManager ↔ ContentViewModel
- ✅ **Persistance** : UserDefaults entre sessions
- ✅ **Publicités** : Conditionnelles (masquées si premium)
- ✅ **ATT** : Implémenté (même si refusé)

### **Fonctionnalités NON testables :**
- ❌ **Achats réels** : Mode test seulement
- ❌ **Restauration achats** : Mode test seulement
- ❌ **Validation reçus** : Pas nécessaire en test

## 📊 **Timeline typique**

### **Téléversement :**
- **Préparation** : 5-10 minutes
- **Génération archive** : 2-5 minutes
- **Validation** : 1-2 minutes
- **Téléversement** : 5-15 minutes

### **Processing Apple :**
- **Initial** : 5-30 minutes
- **Disponible tests internes** : 15-60 minutes
- **Review tests externes** : 24-48 heures

## 🎯 **Instructions pour les testeurs**

### **Tests internes (vous-même) :**
1. **App Store Connect → FriendZone → TestFlight**
2. **Builds** : Sélectionnez votre build
3. **Internal Testing** : Ajoutez-vous comme testeur
4. **Installer** via l'app TestFlight

### **Tests à effectuer :**
1. **Navigation complète** : Du début à la fin
2. **Premium** : Activation/désactivation
3. **Publicités** : Apparaissent/masquées correctement
4. **Persistance** : Fermer/rouvrir l'app
5. **Performance** : Fluidité sur différents devices

## 🔧 **Configuration avancée (optionnelle)**

### **Pour désactiver complètement StoreKit en TestFlight :**
```swift
// Dans PremiumManager.swift, modifier :
#if DEBUG || ADHOC
// Mode test pour développement ET TestFlight
isTestMode = true
#else
// Mode production seulement
isTestMode = false
loadProducts()
#endif
```

### **Créer un scheme AdHoc :**
1. **Product → Scheme → Edit Scheme**
2. **Duplicate Scheme** → "FriendZone AdHoc"
3. **Archive → Build Configuration** : "Release"
4. **Build Settings → Other Swift Flags** : `-D ADHOC` pour Release

## 🚀 **Commandes Terminal utiles**

### **Nettoyage complet :**
```bash
cd /Users/wills/Downloads/FriendZone
rm -rf ~/Library/Developer/Xcode/DerivedData/FriendZone-*
rm -rf ~/Library/Caches/com.apple.dt.Xcode
```

### **Créer archive via CLI :**
```bash
cd /Users/wills/Downloads/FriendZone
xcodebuild archive \
  -project FriendZone.xcodeproj \
  -scheme FriendZone \
  -configuration Release \
  -archivePath ~/Desktop/FriendZone.xcarchive
```

## 🎉 **Félicitations !**

**Votre app FriendZone est maintenant prête pour TestFlight !** 

**Prochaines étapes après TestFlight :**
1. **Recueillir les feedbacks** des testeurs
2. **Corriger les bugs** identifiés
3. **Configurer App Store Connect** pour les vrais achats
4. **Soumettre à l'App Store** avec achats réels

**Bonne chance avec TestFlight !** 🚀