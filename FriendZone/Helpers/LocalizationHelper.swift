//
//  LocalizationHelper.swift
//  FriendZone
//
//  Created by williams saadi on 02/10/2025.
//

import Foundation

struct LocalizationHelper {
    
    // MARK: - Launch Page
    static let friendzone = NSLocalizedString("Friendzone", comment: "App name")
    
    // MARK: - Introducing Question View
    static let faisonsConnaissance = NSLocalizedString("Faisons connaissance", comment: "Let's get to know each other")
    static let monCrushEst = NSLocalizedString("Mon crush est %@", comment: "My crush is %@")
    static let garcon = NSLocalizedString("garçon", comment: "boy")
    static let fille = NSLocalizedString("fille", comment: "girl")
    static let jaiEntre = NSLocalizedString("J'ai entre ", comment: "I am between ")
    static let age13_15 = NSLocalizedString("13 - 15 ans", comment: "13 - 15 years old")
    static let age15_17 = NSLocalizedString("15 - 17 ans", comment: "15 - 17 years old")
    static let agePlus17 = NSLocalizedString(" Plus de 17 ans", comment: "Over 17 years old")
    static let valider = NSLocalizedString("Valider", comment: "Validate")
    
    // MARK: - Content View
    static let questionFormat = NSLocalizedString("Q %d : %@", comment: "Q %d: %@")
    static let zero = NSLocalizedString("0", comment: "0")
    static let percentageFormat = NSLocalizedString("%d%%", comment: "%d%%")
    
    // MARK: - Result View
    static let letsGo = NSLocalizedString("Tu peux y aller !", comment: "Go for it!")
    static let middle = NSLocalizedString("Dans le doute...", comment: "In doubt...")
    static let friendzoneResult = NSLocalizedString("Lache l'affaire !", comment: "Let it go!")
    
    // MARK: - Common
    static let objetCollecte = NSLocalizedString("Objet collecté", comment: "Item collected")
    static let objetRequis = NSLocalizedString("Objet requis", comment: "Item required")
    static let solution = NSLocalizedString("Solution", comment: "Solution")
    static let packPremium = NSLocalizedString("Pack Premium", comment: "Premium Pack")
    static let reinitialiserPremium = NSLocalizedString("Réinitialiser Premium", comment: "Reset Premium")
    
    // MARK: - Helper Methods
    static func localizedString(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    
    static func localizedStringWithFormat(_ key: String, _ arguments: CVarArg...) -> String {
        return String(format: NSLocalizedString(key, comment: ""), arguments: arguments)
    }
}
