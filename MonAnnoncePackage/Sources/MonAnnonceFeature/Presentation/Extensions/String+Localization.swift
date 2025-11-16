import Foundation

extension String {
    /// Returns a localized string using the key
    /// The Localizable.xcstrings file is in the main app bundle
    public func localized() -> String {
        // NSLocalizedString automatically uses Localizable.xcstrings if available
        // The table parameter defaults to "Localizable" which matches our .xcstrings file
        let localized = NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: self, comment: "")
        return localized
    }
    
    /// Returns a localized string with arguments
    public func localized(_ arguments: CVarArg...) -> String {
        let format = self.localized()
        return String(format: format, arguments: arguments)
    }
}

