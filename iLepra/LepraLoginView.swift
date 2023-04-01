//
//  LepraLoginView.swift
//  iLepra
//
//  Created by Maxim Potapov on 31.03.2023.
//

import SwiftUI

struct LepraLoginView: View {
    @EnvironmentObject var viewModel: LepraViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoading = false

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 24)
            Image(systemName: isLoading ? "theatermasks.fill" : "theatermasks")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Spacer()
                .frame(height: 24)
            Text("Leprosorium")
                .font(.headline)
            Spacer()
                .frame(height: 24)

            TextField("Login", text: $username)
            #if os(iOS)
                .keyboardType(.asciiCapable)
            #endif
                .disabled(isLoading)
                .disabled(isLoading)
                .textContentType(.username)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 300)

            SecureField("Password", text: $password)
            #if os(iOS)
                .keyboardType(.asciiCapable)
            #endif
                .textContentType(.password)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 300)

            Spacer()
                .frame(height: 24)
            Button("YARRR!") {
                isLoading = true
                Task {
                    try await viewModel.login(username: username, password: password)
                }
                isLoading = false
            }
            .disabled(isLoading)
            .tint(.accentColor)
            .buttonStyle(.bordered)
            Spacer()
                .frame(height: 24)
        }
        .padding()
    }
}

struct LepraLoginView_Previews: PreviewProvider {
    static var previews: some View {
        LepraLoginView()
            .environmentObject(LepraViewModel())
    }
}
