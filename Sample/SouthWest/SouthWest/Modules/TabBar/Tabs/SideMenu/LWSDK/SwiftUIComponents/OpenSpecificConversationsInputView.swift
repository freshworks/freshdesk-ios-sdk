//
//  ParallelConversationsInputView.swift
//  FreshworksSDKTestApp
//
//  Created by Shahebaz Shaikh on 21/08/23.
//

import SwiftUI

struct OpenSpecificConversationsInputView: View {
    let didDismiss: (_ topicId: Int, _ topicName: String, _ showConversation: Bool) -> Void

    @State private var conversationReferenceId: String = UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.topicIdForConversation) ?? Constants.Characters.emptyString
    @State private var topicName: String = UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.topicNameForConversation) ?? Constants.Characters.emptyString

    var body: some View {
        FeatureBackgroundView(
            heading: Constants.Features.OpenSpecificConversation.title,
            subheading: Constants.Features.OpenSpecificConversation.subheading,
            mainButtonTitle: Constants.Features.OpenSpecificConversation.mainButton,
            dismissTapped: {
                dismissAction()
            },
            mainButtonTapped: {
                updateButtonTapped()
            },
            content: {
                FeatureTextfield(
                    title: Constants.Features.OpenSpecificConversation.referenceIdTitle,
                    placeholder: Constants.Features.OpenSpecificConversation.referenceIdPlaceholder,
                    content: $conversationReferenceId
                )
                FeatureTextfield(
                    title: Constants.Features.OpenSpecificConversation.topicNameTitle,
                    placeholder: Constants.Features.OpenSpecificConversation.topicNamePlaceholder,
                    content: $topicName
                )
            })
    }

    private func dismissAction() {
        didDismiss(0, Constants.Characters.emptyString ,false)
    }

    private func updateButtonTapped() {
        UserDefaults.standard.set(conversationReferenceId, forKey: Constants.UserDefaultsKeys.topicIdForConversation)
        UserDefaults.standard.set(topicName, forKey: Constants.UserDefaultsKeys.topicNameForConversation)
        didDismiss(0, topicName , true)
    }
}

struct ParallelConversationsInputView_Previews: PreviewProvider {
    static var previews: some View {
        OpenSpecificConversationsInputView { _,_,_  in }
    }
}
