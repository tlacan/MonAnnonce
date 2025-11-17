import SwiftUI

public struct EntryDetailView: View {
    @StateObject private var viewModel: EntryDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    public init(viewModel: EntryDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
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
                        // Always show all fields, even if empty
                        editableFieldRow(
                            label: "entry.detail.field.id".localized(),
                            value: $viewModel.editedId,
                            isEditing: viewModel.isEditing
                        )
                        
                        editableFieldRow(
                            label: "entry.detail.field.title".localized(),
                            value: $viewModel.editedTitle,
                            isEditing: viewModel.isEditing
                        )
                        
                        editableFieldRow(
                            label: "entry.detail.field.brand".localized(),
                            value: $viewModel.editedBrand,
                            isEditing: viewModel.isEditing
                        )
                        
                        editableFieldRow(
                            label: "entry.detail.field.color".localized(),
                            value: $viewModel.editedColor,
                            isEditing: viewModel.isEditing
                        )
                        
                        editableFieldRow(
                            label: "entry.detail.field.description".localized(),
                            value: $viewModel.editedDescription,
                            isEditing: viewModel.isEditing,
                            isMultiline: true
                        )
                        
                        // Unisex toggle - always show in edit mode, show value in view mode
                        if viewModel.isEditing {
                            editableToggleRow(
                                label: "entry.detail.field.unisex".localized(),
                                value: $viewModel.editedIsUnisex
                            )
                        } else {
                            let unisexValue = viewModel.entryModel.isUnisex ? "entry.detail.field.unisex.yes".localized() : "entry.detail.field.unisex.no".localized()
                            fieldRow(label: "entry.detail.field.unisex".localized(), value: unisexValue, isEditing: false)
                        }
                        
                        editableFieldRow(
                            label: "entry.detail.field.length".localized(),
                            value: $viewModel.editedMeasurementLength,
                            isEditing: viewModel.isEditing,
                            placeholder: "0",
                            suffix: "unit.centimeters".localized()
                        )
                        
                        editableFieldRow(
                            label: "entry.detail.field.width".localized(),
                            value: $viewModel.editedMeasurementWidth,
                            isEditing: viewModel.isEditing,
                            placeholder: "0",
                            suffix: "unit.centimeters".localized()
                        )
                        
                        editableFieldRow(
                            label: "entry.detail.field.price".localized(),
                            value: $viewModel.editedPrice,
                            isEditing: viewModel.isEditing,
                            placeholder: "0",
                            suffix: "unit.currency.euro".localized(),
                            keyboardType: .decimalPad
                        )
                        
                        editableFieldRow(
                            label: "entry.detail.field.size".localized(),
                            value: $viewModel.editedSize,
                            isEditing: viewModel.isEditing
                        )
                        
                        editableFieldRow(
                            label: "entry.detail.field.status".localized(),
                            value: $viewModel.editedStatus,
                            isEditing: viewModel.isEditing
                        )
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
                            value: viewModel.entryModel.creationDate.formatted(date: .abbreviated, time: .shortened),
                            isEditing: false
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
            if viewModel.isEditing {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task {
                            await viewModel.saveChanges()
                        }
                    } label: {
                        if viewModel.isSaving {
                            ProgressView()
                        } else {
                            Text("entry.detail.save".localized())
                        }
                    }
                    .disabled(viewModel.isSaving)
                }
            } else {
                ToolbarItem(placement: .primaryAction) {
                    Button("entry.detail.edit".localized()) {
                        viewModel.startEditing()
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
    
    private func fieldRow(label: String, value: String, isEditing: Bool) -> some View {
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
    
    private func editableFieldRow(
        label: String,
        value: Binding<String>,
        isEditing: Bool,
        placeholder: String = "",
        suffix: String = "",
        isMultiline: Bool = false,
        keyboardType: UIKeyboardType = .default
    ) -> some View {
        HStack(alignment: .top) {
            Text(label + ":")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            
            if isEditing {
                if isMultiline {
                    TextField(placeholder, text: value, axis: .vertical)
                        .font(.subheadline)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...6)
                } else {
                    HStack {
                        TextField(placeholder, text: value)
                            .font(.subheadline)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(keyboardType)
                        if !suffix.isEmpty {
                            Text(suffix)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            } else {
                let displayValue = value.wrappedValue.isEmpty ? "-" : (value.wrappedValue + suffix)
                Text(displayValue)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
    }
    
    private func editableToggleRow(
        label: String,
        value: Binding<Bool>
    ) -> some View {
        HStack {
            Text(label + ":")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            
            Toggle("", isOn: value)
                .labelsHidden()
            
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

