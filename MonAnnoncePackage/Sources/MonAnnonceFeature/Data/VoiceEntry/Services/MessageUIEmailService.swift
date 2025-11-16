import MessageUI
import UIKit
import Foundation

/// MessageUI implementation of EmailService
/// Note: This service requires UI presentation, so it needs to be called from MainActor context
public final class MessageUIEmailService: @unchecked Sendable, EmailService {
    private let recipientEmail: String
    private var currentDelegate: MailComposeDelegate?
    
    public init(recipientEmail: String) {
        self.recipientEmail = recipientEmail
    }
    
    public func canSendEmail() -> Bool {
        MFMailComposeViewController.canSendMail()
    }
    
    public func composeEmail(
        recipient: String,
        subject: String,
        body: String,
        completion: @escaping @Sendable (Result<Void, EmailError>) -> Void
    ) {
        guard canSendEmail() else {
            completion(.failure(.emailNotConfigured))
            return
        }
        
        Task { @MainActor in
            let mailComposer = MFMailComposeViewController()
            let delegate = MailComposeDelegate(completion: completion)
            self.currentDelegate = delegate // Retain the delegate
            mailComposer.mailComposeDelegate = delegate
            mailComposer.setToRecipients([recipient])
            mailComposer.setSubject(subject)
            mailComposer.setMessageBody(body, isHTML: false)
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                var topViewController = rootViewController
                while let presented = topViewController.presentedViewController {
                    topViewController = presented
                }
                topViewController.present(mailComposer, animated: true)
            } else {
                self.currentDelegate = nil
                completion(.failure(.sendingFailed))
            }
        }
    }
    
    public func sendEmail(recipient: String, subject: String, body: String) async throws {
        guard canSendEmail() else {
            throw EmailError.emailNotConfigured
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            composeEmail(recipient: recipient, subject: subject, body: body) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

/// Delegate to handle mail compose result
private class MailComposeDelegate: NSObject, MFMailComposeViewControllerDelegate {
    private let completion: @Sendable (Result<Void, EmailError>) -> Void
    
    init(completion: @escaping @Sendable (Result<Void, EmailError>) -> Void) {
        self.completion = completion
    }
    
    nonisolated func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        Task { @MainActor in
            controller.dismiss(animated: true)
        }
        
        switch result {
        case .sent:
            completion(.success(()))
        case .cancelled:
            completion(.failure(.userCancelled))
        case .failed:
            completion(.failure(.sendingFailed))
        case .saved:
            // Email was saved as draft - consider this a success
            completion(.success(()))
        @unknown default:
            completion(.failure(.sendingFailed))
        }
    }
}

