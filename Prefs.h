#import <UIKit/UIKit.h>
#import "Utils/CMMUserDefaults.h"
#import "Utils/NSBundle+CMMPrefs.h"

@interface Prefs : UITableViewController
@end

@interface UISwitchVisualElement : UIView
@property (nonatomic, assign) BOOL showsOnOffLabel;
@end

@interface UISwitch (Private)
@property (nonatomic, strong) UISwitchVisualElement *visualElement;
@end

@interface PhoneTabBarController : UIViewController
- (void)showFavoritesTab:(BOOL)favoritesTab recentsTab:(BOOL)recentsTab contactsTab:(BOOL)contactsTab keypadTab:(BOOL)keypadTab voicemailTab:(BOOL)voicemailTab;
@end

@interface MPRootViewController : UIViewController
@property (nonatomic, strong, readonly) PhoneTabBarController *baseViewController;
@end

@interface PhoneApplication : UIApplication
@end