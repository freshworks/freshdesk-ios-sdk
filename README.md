Freshdesk iOS SDK
=================

"Modern ticket software that your sales and customer engagement teams will love [FreshdeskSDK](https://www.freshworks.com)."

## Installation
### Swift Package Manager
Add https://github.com/freshworks/freshdesk-ios-sdk as a Swift Package Repository in Xcode and follow the instructions to add FreshdeskSDK as a Swift Package.

### Cocoapods
Freshdesk iOS SDK can be integrated using cocoapods by specifying the following in your podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '15.0'

target 'Your project target' do
pod 'FreshdeskSDK'
end
```

## Documentation
### Initialisation
In Appdelegate -> didFinishLaunchingWithOptions (Invoke the Freshdesk initialisation)

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { 
    let sdkConfig = FreshdeskSDKConfig(token: "your-account-token",
                                       host: "your-host-url",
                                       sdkId: "your-sdk-id",
                                       jwtToken: "your-user-jwt-token",
                                       locale: "your-apps-locale"
    )
    Freshdesk.initialize(with: sdkConfig)
    registerNotifications() // For notification related, check PushNotification section at the last
    return true
}
```
`token, host, sdkId`  ==> Admin settings -> Mobile Chat SDK -> Select a SDK needed -> Under App Keys
`jwtToken` ==> Generate your JWT token based on encryption key under SDK or SDK linked web chat widget
`locale` ==> Add supported locale for widget, localisation is supported only during the initialisation

### UserCreation 
- Listeners are required for `User Created` generated.
- Listener Names -> `FDEvents.userCreated`
- Implementation
    ```swift
        NotificationCenter.default.addObserver(self, selector: #selector(self.onUserCreated(_:)), name: Notification.Name(FDEvents.userCreated.rawValue), object: nil)
    ```
    ```swift
        @objc func onUserCreated(_ notification: NSNotification) {
            print("User created")
            print(notification.object ?? "")
        }
    ```

### User
- Inorder to Create/Update/SetUser use the below for reference. (Make sure that properties are whitelisted under Contact Fields of SDK linked widget).
    ```swift
         // Compose user properties and pass them to setUserDetails API
         let userProperties: [String: Any] = [
                            "name": "Mobile iOS SDK",
                            "address": "Chennai, India",
                            "mobile": "1234567890",
                            "phone": "9876543210",
                            "customnumber": 123
        ]
        Freshdesk.setUserDetails(with: userProperties)
    ```
    Note: For JWT enforced SDKs, updating the user properties will be done through the JWT payload. Please refer the 'JWT' section below.

- To get current user information
    ```swift
        Freshdesk.getUser { [weak self] user in
            print(user)
        }
    ```
- To set ticket information (Make sure that properties are whitelisted under Ticket Fields of SDK linked widget)
    ```swift
        // Compose ticket properties and pass them to setTicketProperties API
        let ticketProperties: [String: Any] = [
                            "subject": "Product Enquiry",
                            "priority": 3
        ]

        // Pass the dictionary to Freshdesk API
        Freshdesk.setTicketProperties(with: ticketProperties)
    ```
- To clear clear details on logout or upgrade user from guest user to an identified user
    ```swift
        Freshdesk.resetUser()
    ```

### Launch the support experience
Note: self --> current viewcontroller
- Support Home
    ```swift
        Freshdesk.openSupport(self)
    ```
- Knowledge Base 
    ```swift
        Freshdesk.openKnowledgeBase(self)
    ```
- Open a specific topic
    Customize your ticket by adding specific topic filter during creation. To implement, pass specific topic id and topic name with openTopic public api call for relevant topic.
    ```swift
        Freshdesk.openTopic(self, topicId: topic-id, topicName: "topic-name")
    ```
### Unread count
    Get existing unread count value
```swift
    // This will provide you an unread count value to show under label
    Freshdesk.getUnreadCount()
```
To get unread count in real time add a notification observer as defined below
```swift
    NotificationCenter.default.addObserver(self, selector: #selector(self.onUnreadCount(_:)), name: Notification.Name(FDEvents.unreadCount.rawValue), object: nil)
        
    @objc func onUnreadCount(_ notification: NSNotification) {
        if let unreadCount = notification.object as? Int {
            DispatchQueue.main.async {
                //Update realtime count value with unreadCount
            }
        }
    }
```

### PushNotifications
Request for notification permission if granted register the token with Freshdesk.
```swift
   extension AppDelegate: UNUserNotificationCenterDelegate {
    func registerNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            // Handle authorization status
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Freshdesk.setPushRegistrationToken(deviceToken)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        let appState = UIApplication.shared.applicationState
        
        if Freshdesk.isFreshdeskNotification(userInfo) {
            Freshdesk.handleRemoteNotification(userInfo, appState: appState)
        
        } else {
            // Not Freshdesk notification
            completionHandler([.banner, .badge, .sound])
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let appState = UIApplication.shared.applicationState
        
        if Freshdesk.isFreshdeskNotification(userInfo) {
            Freshdesk.handleRemoteNotification(userInfo, appState: appState)
        } else{
            // Not Freshdesk notification
        }
}
        completionHandler()
    }
}      
```

### Tracking User Events
- Freshdesk allows you to track any events performed by your users. It can be anything, ranging from updating their profile picture to adding 5 items to the cart. You can use these events as context while engaging with the user. Events can also be used to set up triggered messages or to segment users for campaigns.
    ```swift
        Freshdesk.trackUserEvents(name: "eventName", payload: ["eventName":"eventValue"])
    ```
### JWT Authentication
- Enabling user authentication using JSON Web Token:
  
Freshdesk uses JSON Web Token (JWT) to allow only authenticated users to initiate a conversation with you through the Freshdesk messenger.

Step 1: Create the JWT using the public & private keys.

Step 2: Initiate the SDK with the above JWT.

```swift
    let sdkConfig = FreshdeskSDKConfig(token: "your-account-token",
                                       host: "your-host-url",
                                       sdkId: "your-sdk-id",
                                       jwtToken: "your-user-jwt-token",
                                       locale: "your-apps-locale"
    )
    Freshdesk.initialize(with: sdkConfig)
```

Note: If your SDK is JWT enforced, it is mandatory to pass JWT while SDK initialization, if its not passed during init it can be passed on the authenticateAndUpdate method subsequently only then the sdk apis can be used.

Step 3: Set 'YourClass' as the delegate to receive user state change updates.
```swift
Freshdesk.setJWTDelegate(self) // 'self' is the instance of <YourClass>'
```

Step 4: Implement the 'FreshdeskJWTDelegate' function to receive the user state change updates.
```swift
extension <YourClass>: FreshdeskJWTDelegate {

  func userStateChanged(_ userState: UserState) {
    /*
        jwtNotPresent - JWT is not passed during init for an enforced JWT SDK linked Widget
        notAuthenticated - Invalid token is being passed
        authExpired - JWT passed is expired
        identifierUpdated - Unique user identifier updated for an user
        authenticated - JWT passed is successfully authenticated or restored
        undefined - default case
    */
  }

}
```

Step 5: Create a valid JWT and update the user using below method, Reset user needs to be invoked if the new user is created/restored.
```swift
Freshdesk.authenticateAndUpdate(jwt: "<valid-JWT>")
```

Note: The above API (Freshdesk.authenticateAndUpdate) will also be responsible for updating the user details and ticket properties. While creating the JWT, the details which need to be updated should be added in the payload. (Same api can be used while migrating from non verified to verified user)

### Custom link handler
```swift
    Freshdesk.setCustomLinkHandler { url in
        print("Link tapped: \(url)")
        // Custom handling logic
        if url.absoluteString.hasPrefix("App-deep-link://") {
            // "Deeplink URL tapped: Perform any action with url.host ?? url.absoluteString
            return
        }
        // Open your custom link in seperate view url.host ?? url.absoluteString
    }
```
### Dismiss FreshdeskSDK screen 
```swift
        Freshdesk.dismissFreshdeskSDKViews()
```
    
## License
FreshdeskSDK is released under the Commercial license. See [LICENSE](https://github.com/freshworks/freshdesk-ios-sdk/blob/main/FreshdeskSDK/LICENSE) for details.

## Support
[support@freshdesk.com](mailto:support@freshdesk.com)

[Support Portal](https://support.freshdesk.com)
