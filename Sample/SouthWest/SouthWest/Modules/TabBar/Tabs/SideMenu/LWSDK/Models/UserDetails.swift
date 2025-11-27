//
//  UserDetails.swift
//  SouthWest
//
//  Created by Shahebaz Shaikh on 21/11/23.
//

import Foundation
import FreshdeskSDK

// Extension to reset UserDefaults
extension UserDefaults {
    func resetUserDetails() {
        //User details
        removeObject(forKey: Constants.UserDefaultsKeys.userDetails)
        
        //Locale change
        removeObject(forKey: Constants.UserDefaultsKeys.selectedUserLanguageLocaleCode)
        
        //Parallel conversation
        removeObject(forKey: Constants.UserDefaultsKeys.topicIdForConversation)
        removeObject(forKey: Constants.UserDefaultsKeys.topicNameForConversation)
        
        //Tags
        removeObject(forKey: Constants.UserDefaultsKeys.tags)
        removeObject(forKey: Constants.UserDefaultsKeys.tagsSelectOption)
        
        //Jwt
        updateJWT(Constants.Characters.emptyString)
        
        //Ticket Properties
        removeObject(forKey: Constants.UserDefaultsKeys.ticketProperties)
        
        //Bot variables
        removeObject(forKey: Constants.UserDefaultsKeys.userProperties)
        
        //Header and content property
        removeObject(forKey: Constants.UserDefaultsKeys.headerProperty)
        removeObject(forKey: Constants.UserDefaultsKeys.contentProperty)
    }
}

// Extension to UserDefaults to simplify storing and retrieving UserDetails
extension UserDefaults {
    
    func updateSDKConfig(_ sdkConfig: FreshdeskSDKConfig, locale: String? = nil) {
        UserDefaults.standard.set(sdkConfig.token, forKey: Constants.UserDefaultsKeys.token)
        UserDefaults.standard.set(sdkConfig.host, forKey: Constants.UserDefaultsKeys.domain)
        UserDefaults.standard.set(sdkConfig.sdkId, forKey: Constants.UserDefaultsKeys.sdkID)
        UserDefaults.standard.set(sdkConfig.jwtAuthToken, forKey: Constants.UserDefaultsKeys.jwt)
        UserDefaults.standard.set(locale, forKey: Constants.UserDefaultsKeys.locale)
    }
    
    func updateJWT(_ jwt: String) {
        UserDefaults.standard.set(jwt, forKey: Constants.UserDefaultsKeys.jwt)
    }

    func getSDKConfig() -> FreshdeskSDKConfig? {
        guard let token =  UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.token),
              let domain =  UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.domain),
              let sdkId =  UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.sdkID),
              let jwtToken =  UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.jwt),
              let locale =  UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.locale)
        else {
            return nil
        }
        
        guard !sdkId.isEmpty && !token.isEmpty && !domain.isEmpty else {
            return nil
        }
        
        let sdkConfig = FreshdeskSDKConfig(token: token, host: domain, sdkId: sdkId, jwtToken: jwtToken, locale: locale)
        return sdkConfig
    }
}

