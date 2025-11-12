//
//  UpdateJWTView.swift
//  SouthWest
//
//  Created by Pramit Tewari on 08/12/23.
//

import SwiftUI
import Combine
import FreshdeskSDK

struct UpdateJWTView: View {
    
    let didDismiss: (_ jwt: String?) -> Void

    @ObservedObject private var handler = JWTObservableHandler()
    @State private var jwt: String = Constants.Characters.emptyString
    @State private var showAlert: Bool = false

    var body: some View {
        FeatureBackgroundView(
            heading: Constants.Features.UpdateJWT.title,
            subheading: Constants.Features.UpdateJWT.subheading,
            mainButtonTitle: Constants.Features.UpdateJWT.mainButton,
            dismissTapped: {
                dismiss()
            }, mainButtonTapped: {
                authenticate()
            }, content: {
                FeatureTextfield(
                    title: Constants.Features.UpdateJWT.userStateTitle,
                    placeholder: Constants.Features.UpdateJWT.userStatePlaceholder,
                    content: $handler.userState
                )
                FeatureTextfield(
                    title: Constants.Features.UpdateJWT.tokenTitle,
                    placeholder: Constants.Features.UpdateJWT.tokenPlaceholder,
                    content: $jwt
                )
                    .padding(.bottom, 20)
            }
        )
        .onAppear {
            handler.setDelegate()
            handler.setUserState()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(Constants.Alert.title),
                message: Text(Constants.Features.UpdateJWT.alertMessage),
                dismissButton: .default(Text(Constants.Alert.okay))
            )
        }
    }
    
    private func dismiss() {
        didDismiss(nil)
    }
    
    private func authenticate() {
        guard !jwt.isEmpty else {
            showAlert = true
            return
        }
        showAlert = false
        didDismiss(jwt)
    }

}

struct UpdateJWTView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateJWTView { _ in }
    }
}

class JWTObservableHandler: ObservableObject, FreshdeskJWTDelegate {
    
    @Published var userState: String = Constants.Characters.emptyString
    @Published var state: UserState = .undefined
    private var cancellables: Set<AnyCancellable> = []
    
    func setDelegate() {
        Freshdesk.setJWTDelegate(self)
    }
    
    func userStateChanged(_ userState: UserState) {
        DispatchQueue.main.async { [weak self] in
            self?.state = userState
        }
    }
    
    func setUserState() {
        $state
            .sink { [weak self] newUserState in
                self?.handleUserStateChanged(newUserState)
            }
            .store(in: &cancellables)
    }
    
    private func handleUserStateChanged(_ userState: UserState) {
        self.userState = userState.rawValue
        switch userState {
        case .authenticated: break
        case .authExpired, .jwtNotPresent, .notAuthenticated, .identifierUpdated, .undefined: handleJWTFailure()
        }
    }
    
    private func handleJWTFailure() {
        // TODO: Need to check for handling these states
    }
}
