# 📚 Guide de Localisation - FriendZone

## 🎯 Vue d'ensemble

Le système de localisation de FriendZone est maintenant implémenté et prêt pour l'ajout de nouvelles langues.

## 🏗️ Architecture

### Structure des fichiers
```
FriendZone/
├── Helpers/
│   └── LocalizationHelper.swift    # Helper centralisé
├── fr.lproj/
│   └── Localizable.strings         # Français (base)
├── en.lproj/
│   └── Localizable.strings         # Anglais
└── View/
    ├── LaunchPage.swift
    ├── IntroducingQuestionView.swift
    ├── ContentView.swift
    └── ResultView.swift
```

### Fichiers de localisation
- **fr.lproj/Localizable.strings** : Français (langue par défaut)
- **en.lproj/Localizable.strings** : Anglais

## 🔧 Utilisation dans le code

### Via LocalizationHelper
```swift
// Texte simple
Text(LocalizationHelper.friendzone)

// Texte avec format
Text(String(format: LocalizationHelper.questionFormat, i + 1, question))
```

### Directement avec NSLocalizedString
```swift
Text(NSLocalizedString("Friendzone", comment: "App name"))
```

## 🌍 Ajouter une nouvelle langue

### 1. Créer le dossier de langue
```bash
# Exemple pour l'espagnol
mkdir FriendZone/es.lproj
```

### 2. Créer le fichier Localizable.strings
```swift
// es.lproj/Localizable.strings
"Friendzone" = "Friendzone";
"Faisons connaissance" = "Conozcámonos";
"Mon crush est %@" = "Mi crush es %@";
// ... autres traductions
```

### 3. Mettre à jour le projet Xcode
- Ouvrir le projet dans Xcode
- Sélectionner le projet dans le navigateur
- Aller dans l'onglet "Info"
- Ajouter la nouvelle langue dans "Localizations"

## 📋 Liste des chaînes à traduire

### Launch Page
- "Friendzone"

### Introducing Question View
- "Faisons connaissance"
- "Mon crush est %@"
- "garçon"
- "fille"
- "J'ai entre "
- "10 - 13 ans"
- "13 - 15 ans"
- " Plus de 15 ans"
- "Valider"

### Content View
- "Q %d : %@"
- "0"
- "%d%%"

### Result View
- "Tu peux y aller !"
- "Dans le doute..."
- "Lache l'affaire !"

### Common
- "Objet collecté"
- "Objet requis"
- "Solution"
- "Pack Premium"
- "Réinitialiser Premium"

## 🚀 Test de la localisation

### Simulateur iOS
1. Aller dans **Settings > General > Language & Region**
2. Changer la langue de l'appareil
3. Relancer l'application

### Xcode
1. Modifier le schéma d'exécution
2. Changer la langue dans **Run > Options > Application Language**

## 🔄 Maintenance

### Ajouter une nouvelle chaîne
1. Ajouter la clé dans `LocalizationHelper.swift`
2. Ajouter la traduction dans tous les fichiers `.strings`
3. Utiliser la nouvelle clé dans le code

### Mettre à jour une traduction
1. Modifier la valeur dans le fichier `.strings` correspondant
2. Les changements seront automatiquement pris en compte

## 📝 Bonnes pratiques

1. **Utiliser des commentaires** dans les fichiers `.strings`
2. **Tester toutes les langues** après chaque modification
3. **Garder les clés descriptives** et cohérentes
4. **Utiliser des placeholders** pour les textes dynamiques
5. **Vérifier les longueurs** de texte dans différentes langues

## 🎉 Prochaines étapes

1. **Traduire les questions** dans les fichiers JSON
2. **Ajouter plus de langues** (espagnol, allemand, etc.)
3. **Implémenter le changement de langue** dans l'application
4. **Tester avec des langues RTL** (arabe, hébreu)
