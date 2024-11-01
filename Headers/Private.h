#import <UIKit/UIKit.h>

@interface UIView (Private)
- (UIViewController *)_viewControllerForAncestor;
@end

@interface UIAlertController (Private)
@property (nonatomic, copy, readwrite, getter=_attributedTitle, setter=_setAttributedTitle:) NSAttributedString *attributedTitle;
@property (nonatomic, copy, readwrite, getter=_attributedMessage, setter=_setAttributedMessage:) NSAttributedString *attributedMessage;
@end

@interface UISwitchVisualElement : UIView
@property (nonatomic, assign) BOOL showsOnOffLabel;
@end

@interface UISwitch (Private)
@property (nonatomic, strong) UISwitchVisualElement *visualElement;
@end
