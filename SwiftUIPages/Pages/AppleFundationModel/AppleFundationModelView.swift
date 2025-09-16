//
//  AppleFundationModelView.swift
//  SwiftUIPages
//
//  (\(\
//  ( -.-)
//  o_(")(")
//  -----------------------
//  Created by jeffy on 9/16/25.
//

import FoundationModels
import SwiftUI


struct AppleFundationModelView: View {
    
    private var model = SystemLanguageModel.default
    
    @State private var answer: String = ""
    @State private var question: String = ""
    
    // 保留上下文
    @State private var session = LanguageModelSession()
    
    var body: some View {
        switch model.availability {
        case .available:
            mainView
        case .unavailable(let reason):
            Text(unavailableMessage(reason))
        }
    }
    
    private var mainView: some View {
        ScrollView {
            VStack {
                Text("Ask Me Anything")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                
                TextField("", text: $question, prompt: Text("Type your question here"), axis: .vertical)
                    .lineLimit(3...5)
                    .padding()
                    .background {
                        Color(.systemGray6)
                    }
                    .font(.system(.title2, design: .rounded))
                
                Button {
                    Task {
                        await generateAnswer()
                    }
                } label: {
                    Text("Show me the answer")
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                }
                .disabled(session.isResponding)
                .buttonStyle(.borderedProminent)
                .controlSize(.extraLarge)
                .padding(.top)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(.systemGray5))
                    .padding(.vertical)
                
                Text(LocalizedStringKey(answer))
                    .font(.system(.body, design: .rounded))
            }
            .padding()
        }
    }
    
    private func unavailableMessage(_ reason: SystemLanguageModel.Availability.UnavailableReason) -> String {
        switch reason {
        case .deviceNotEligible:
            return "The device is not eligible for using Apple Intelligence."
        case .appleIntelligenceNotEnabled:
            return "Apple Intelligence is not enabled on this device."
        case .modelNotReady:
            return "The model isn't ready because it's downloading or because of other system reasons."
        @unknown default:
            return "The model is unavailable for an unknown reason."
        }
    }
    
    @available(iOS 26.0, *)
    private func generateAnswer() async {
        do {
            answer = ""
            let stream = session.streamResponse(to: question)
            for try await streamData in stream {
                answer = streamData.content
            }
        } catch {
            answer = "Failed to answer the question: \(error.localizedDescription)"
        }
    }
    
}


