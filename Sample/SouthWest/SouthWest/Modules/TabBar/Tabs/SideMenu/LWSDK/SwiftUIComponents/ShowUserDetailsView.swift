//
//  ShowUserDetailsView.swift
//  SouthWest
//
//  Created by Harish Kumar on 13/09/25.
//

import SwiftUI

struct ShowUserDetailsView: View {
    let didDismiss: () -> Void
    
    @State private var userDetails: String?
    
    init(userInfo: String? = nil, didDismiss: @escaping () -> Void) {
        self.didDismiss = didDismiss
        _userDetails = State(initialValue: userInfo)
    }
    
    var body: some View {
        FeatureBackgroundView(
            heading: Constants.Features.UserDetails.showTitle,
            subheading: Constants.Features.UserDetails.subheading,
            mainButtonTitle: Constants.Alert.okay,
            dismissTapped: {
                dismissAction()
            },
            mainButtonTapped: {
                dismissAction()
            },
            content: {
                if let userDetails = userDetails {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(Constants.Features.UserDetails.info)
                            .font(.headline)
                        Text(userDetails)
                            .font(.body)
                            .padding(.vertical, 4)
                            .padding(.horizontal)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .padding(.top)
                } else {
                    Text("No user details found")
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            })
    }
    
    
    private func dismissAction() {
        didDismiss()
    }
    
}

struct ShowUserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ShowUserDetailsView {
            // Dismiss action
        }
    }
}
