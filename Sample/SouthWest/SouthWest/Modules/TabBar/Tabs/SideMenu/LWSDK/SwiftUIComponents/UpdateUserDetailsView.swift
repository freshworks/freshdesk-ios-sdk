//
//  UpdateUserDetailsView.swift
//  SouthWest
//
//  Created by Shahebaz Shaikh on 21/11/23.
//

import SwiftUI

struct UpdateUserDetailsView: View {
    let didDismiss: (String?) -> Void
    
    @State private var userDetails: String
    
    init(userInfo: String? = nil, _ didDismiss: @escaping (String?) -> Void) {
        self.didDismiss = didDismiss
        userDetails = userInfo ?? Constants.Characters.emptyString
    }
    
    var body: some View {
        FeatureBackgroundView(
            heading: Constants.Features.UserDetails.updateTitle,
            subheading: Constants.Features.UserDetails.subheading,
            mainButtonTitle: Constants.Features.UserDetails.mainButton,
            dismissTapped: {
                dismissAction()
            },
            mainButtonTapped: {
                updateButtonTapped()
            },
            content: {
                FeatureTextfield(title: Constants.Features.UserDetails.name,
                                 placeholder: Constants.Features.UserDetails.namePlaceholer,
                                 content: $userDetails)
            })
    }

    private func dismissAction() {
        didDismiss(nil)
    }

    private func updateButtonTapped() {
        didDismiss(userDetails)
    }
}

struct UpdateUserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateUserDetailsView { _ in}
    }
}
