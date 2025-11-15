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
                        section(title: "Transcribed Text") {
                            Text(viewModel.entryModel.transcribedText)
                                .font(.body)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                    }
                    
                    // Structured Fields Section
                    section(title: "Structured Data") {
                        VStack(alignment: .leading, spacing: 12) {
                            if !viewModel.entryModel.id.isEmpty {
                                fieldRow(label: "ID", value: viewModel.entryModel.id)
                            }
                            if !viewModel.entryModel.title.isEmpty {
                                fieldRow(label: "Title", value: viewModel.entryModel.title)
                            }
                            if !viewModel.entryModel.brand.isEmpty {
                                fieldRow(label: "Brand", value: viewModel.entryModel.brand)
                            }
                            if !viewModel.entryModel.color.isEmpty {
                                fieldRow(label: "Color", value: viewModel.entryModel.color)
                            }
                            if !viewModel.entryModel.itemDescription.isEmpty {
                                fieldRow(label: "Description", value: viewModel.entryModel.itemDescription)
                            }
                            if viewModel.entryModel.isUnisex {
                                fieldRow(label: "Is Unisex", value: "Yes")
                            }
                            if viewModel.entryModel.measurementLength > 0 {
                                fieldRow(label: "Length", value: "\(viewModel.entryModel.measurementLength) cm")
                            }
                            if viewModel.entryModel.measurementWidth > 0 {
                                fieldRow(label: "Width", value: "\(viewModel.entryModel.measurementWidth) cm")
                            }
                            if viewModel.entryModel.price > 0 {
                                fieldRow(label: "Price", value: String(format: "%.2f €", viewModel.entryModel.price))
                            }
                            if !viewModel.entryModel.size.isEmpty {
                                fieldRow(label: "Size", value: viewModel.entryModel.size)
                            }
                            if !viewModel.entryModel.status.isEmpty {
                                fieldRow(label: "Status", value: viewModel.entryModel.status)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    
                    // Metadata Section
                    section(title: "Metadata") {
                        VStack(alignment: .leading, spacing: 12) {
                            fieldRow(
                                label: "Created",
                                value: viewModel.entryModel.creationDate.formatted(date: .abbreviated, time: .shortened)
                            )
                            
                            HStack {
                                Text("Email Status:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                if viewModel.entryModel.emailSent {
                                    HStack {
                                        Image(systemName: "envelope.fill")
                                            .foregroundColor(.green)
                                        Text("Sent")
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
                                        Text("Not Sent")
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
                            Text(viewModel.isSendingEmail ? "Sending..." : "Resend Email")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isSendingEmail ? Color.gray : Color.blue)
                        .cornerRadius(12)
                    }
                    .disabled(viewModel.isSendingEmail)
                    .accessibilityLabel("Resend email")
                    
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
            .navigationTitle("Entry Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
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

