import SwiftUI

public struct EntryDetailView: View {
    @StateObject private var viewModel: EntryDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    public init(viewModel: EntryDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Transcribed Text Section
                    if !viewModel.entryModel.transcribedText.isEmpty {
                        section(title: "entry.detail.transcribed.text".localized()) {
                            Text(viewModel.entryModel.transcribedText)
                                .font(.body)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                    }
                    
                    // Structured Fields Section
                    section(title: "entry.detail.structured.data".localized()) {
                        VStack(alignment: .leading, spacing: 12) {
                            if !viewModel.entryModel.id.isEmpty {
                                fieldRow(label: "entry.detail.field.id".localized(), value: viewModel.entryModel.id)
                            }
                            if !viewModel.entryModel.title.isEmpty {
                                fieldRow(label: "entry.detail.field.title".localized(), value: viewModel.entryModel.title)
                            }
                            if !viewModel.entryModel.brand.isEmpty {
                                fieldRow(label: "entry.detail.field.brand".localized(), value: viewModel.entryModel.brand)
                            }
                            if !viewModel.entryModel.color.isEmpty {
                                fieldRow(label: "entry.detail.field.color".localized(), value: viewModel.entryModel.color)
                            }
                            if !viewModel.entryModel.itemDescription.isEmpty {
                                fieldRow(label: "entry.detail.field.description".localized(), value: viewModel.entryModel.itemDescription)
                            }
                            if viewModel.entryModel.isUnisex {
                                fieldRow(label: "entry.detail.field.unisex".localized(), value: "entry.detail.field.unisex.yes".localized())
                            }
                            if viewModel.entryModel.measurementLength > 0 {
                                fieldRow(label: "entry.detail.field.length".localized(), value: "\(viewModel.entryModel.measurementLength) cm")
                            }
                            if viewModel.entryModel.measurementWidth > 0 {
                                fieldRow(label: "entry.detail.field.width".localized(), value: "\(viewModel.entryModel.measurementWidth) cm")
                            }
                            if viewModel.entryModel.price > 0 {
                                fieldRow(label: "entry.detail.field.price".localized(), value: String(format: "%.2f €", viewModel.entryModel.price))
                            }
                            if !viewModel.entryModel.size.isEmpty {
                                fieldRow(label: "entry.detail.field.size".localized(), value: viewModel.entryModel.size)
                            }
                            if !viewModel.entryModel.status.isEmpty {
                                fieldRow(label: "entry.detail.field.status".localized(), value: viewModel.entryModel.status)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    
                    // Metadata Section
                    section(title: "entry.detail.metadata".localized()) {
                        VStack(alignment: .leading, spacing: 12) {
                            fieldRow(
                                label: "entry.detail.field.created".localized(),
                                value: viewModel.entryModel.creationDate.formatted(date: .abbreviated, time: .shortened)
                            )
                            
                            HStack {
                                Text("entry.detail.field.email.status".localized())
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                if viewModel.entryModel.emailSent {
                                    HStack {
                                        Image(systemName: "envelope.fill")
                                            .foregroundColor(.green)
                                        Text("entry.detail.email.sent".localized())
                                            .foregroundColor(.green)
                                        if let lastSent = viewModel.entryModel.lastEmailSentDate {
                                            Text("(\(lastSent.formatted(date: .abbreviated, time: .shortened)))")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                } else {
                                    HStack {
                                        Image(systemName: "envelope")
                                            .foregroundColor(.secondary)
                                        Text("entry.detail.email.not.sent".localized())
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    
                    // Resend Email Button
                    Button {
                        Task {
                            await viewModel.resendEmail()
                        }
                    } label: {
                        HStack {
                            if viewModel.isSendingEmail {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Image(systemName: "envelope.arrow.triangle.branch")
                            }
                            Text(viewModel.isSendingEmail ? "entry.detail.resend.email.sending".localized() : "entry.detail.resend.email".localized())
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isSendingEmail ? Color.gray : Color.blue)
                        .cornerRadius(12)
                    }
                    .disabled(viewModel.isSendingEmail)
                    .accessibilityLabel("entry.detail.resend.email.accessibility".localized())
                    
                    // Success/Error Messages
                    if let successMessage = viewModel.successMessage {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(successMessage)
                                .foregroundColor(.green)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text(errorMessage)
                                .foregroundColor(.orange)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding()
            }
            .navigationTitle("entry.detail.title".localized())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("entry.detail.done".localized()) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            content()
        }
    }
    
    private func fieldRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(label + ":")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
            Spacer()
        }
    }
}

#Preview {
    let entry = EntryModel(
        transcribedText: "Id: SKU-12345, Brand: Levi's, Color: blue, Description: Vintage denim jacket size M, Is unisex: true, Measurement length: 70, Measurement width: 50, Price: 45, Size: M, Status: good, Title: Vintage Levi's Jacket",
        brand: "Levi's",
        color: "blue",
        itemDescription: "Vintage denim jacket size M",
        isUnisex: true,
        measurementLength: 70.0,
        measurementWidth: 50.0,
        price: 45.0,
        size: "M",
        status: "good",
        title: "Vintage Levi's Jacket"
    )
    let emailService = MessageUIEmailService(recipientEmail: AppConfig.recipientEmail)
    let sendEmailUseCase = SendEmailUseCase(
        emailService: emailService,
        recipientEmail: AppConfig.recipientEmail
    )
    let repository = MockEntryRepository()
    let viewModel = EntryDetailViewModel(
        entry: entry,
        sendEmailUseCase: sendEmailUseCase,
        repository: repository
    )
    return EntryDetailView(viewModel: viewModel)
}

