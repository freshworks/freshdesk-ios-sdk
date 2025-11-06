//
//  ChangeAccountView.swift
//  SouthWest
//
//  Created by Shahebaz Shaikh on 22/11/23.
//

import SwiftUI
import FreshdeskSDK

struct ChangeAccountView: View {
    
    let didDismiss: (_ sdkConfig: FreshdeskSDKConfig?) -> Void
    
    @State private var showAlert: Bool = false
    
    @State private var token: String = UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.token) ?? Constants.Characters.emptyString
    @State private var domain: String = UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.domain) ?? Constants.Characters.emptyString
    @State private var sdkID: String = UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.sdkID) ?? Constants.Characters.emptyString
    @State private var jwt: String = UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.jwt) ?? Constants.Characters.emptyString
    @State private var locale: String = UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.locale) ?? Constants.Characters.emptyString

    
    var body: some View {
        FeatureBackgroundView(
            heading: Constants.Features.LoadAccount.title,
            subheading: Constants.Features.LoadAccount.subheading,
            mainButtonTitle: Constants.Features.LoadAccount.mainButton,
            dismissTapped: {
                didDismiss(nil)
            }, mainButtonTapped: {
                updateButtonTapped()
            }, content: {
                
                FeatureTextfield(
                    title: Constants.Features.LoadAccount.widgetTokenTitle,
                    placeholder: Constants.Features.LoadAccount.widgetTokenPlaceholder,
                    content: $token
                )
                FeatureTextfield(
                    title: Constants.Features.LoadAccount.domainTitle,
                    placeholder: Constants.Features.LoadAccount.domainPlaceholder,
                    content: $domain
                )
                FeatureTextfield(
                    title: Constants.Features.LoadAccount.sdkIdTitle,
                    placeholder: Constants.Features.LoadAccount.sdkIdPlaceholder,
                    content: $sdkID
                )
                FeatureTextfield(
                    title: Constants.Features.LoadAccount.authTokenTitle,
                    placeholder: Constants.Features.LoadAccount.authTokenPlaceholder,
                    content: $jwt
                )
                FeatureTextfield(
                    title: Constants.Features.LoadAccount.localeTitle,
                    placeholder: Constants.Features.LoadAccount.localePlaceholder,
                    content: $locale
                )
                Text(Constants.Features.LoadAccount.footer)
                    .font(.system(size: 12))
                    .foregroundColor(Color(Colors.darkBlue).opacity(0.7))
            })
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(Constants.Alert.title),
                message: Text(Constants.Features.LoadAccount.alertMessage),
                dismissButton: .default(Text(Constants.Alert.okay))
            )
        }
    }
    
    private func dismissAction() {
        didDismiss(nil)
    }
    
    private func updateButtonTapped() {
        guard !token.isEmpty && !domain.isEmpty && !sdkID.isEmpty else {
            showAlert = true
            return
        }
        showAlert = false
        let sdkConfig = FreshdeskSDKConfig(token: token, host: domain, sdkId: sdkID, jwtToken: jwt, locale: locale)
        UserDefaults.standard.updateSDKConfig(sdkConfig, locale: locale)
        didDismiss(sdkConfig)
    }
}

struct ChangeAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeAccountView { _ in }
    }
}

