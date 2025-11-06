//
//  PreChatFormView.swift
//  SouthWest
//
//  Created by Revanth Kausikan on 02/07/24.
//

import SwiftUI

struct PreChatFormView: View {
    let didDismiss: (_ preChatFormTemplate: String, _ toBeDismissed: Bool) -> Void
    
    @State private var preChatFormTemplate: String = UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.preChatFormTemplate) ?? Constants.Characters.emptyString
    
    var body: some View {
        FeatureBackgroundView(
            heading: Constants.Features.PreChatFormTemplate.title,
            subheading: Constants.Features.PreChatFormTemplate.subheading,
            mainButtonTitle: Constants.Features.PreChatFormTemplate.mainButton,
            dismissTapped: {
                dismissAction()
            },
            mainButtonTapped: {
                updateButtonTapped()
            },
            content: {
                FeatureTextEditor(
                    title: Constants.Characters.emptyString,
                    placeholder: Constants.Features.PreChatFormTemplate.contentPropertyPlaceholder,
                    description: Constants.Features.PreChatFormTemplate.description,
                    content: $preChatFormTemplate
                )
            })
    }
    
    private func dismissAction() {
        didDismiss(Constants.Characters.emptyString, true)
    }
    
    private func updateButtonTapped() {
        UserDefaults.standard.set(preChatFormTemplate, forKey: Constants.UserDefaultsKeys.preChatFormTemplate)
        didDismiss(preChatFormTemplate, false)
    }
}

#Preview {
    PreChatFormView { _,_   in }
}
