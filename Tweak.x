#import "Prefs.h"

@interface UIView (Private)
- (UIViewController *)_viewControllerForAncestor;
@end

@interface UIAlertController (Private)
@property (nonatomic, copy, readwrite, getter=_attributedMessage, setter=_setAttributedMessage:) NSAttributedString *attributedMessage;
@end

static NSAttributedString *attributedMsg(NSString *contact, NSString *source) {
    NSString *confirmStr = [NSString stringWithFormat:LOC(@"CallConfirm"), contact];
    NSString *hintStr = [NSString stringWithFormat:LOC(@"Hint"), source];
    NSString *messageStr = [NSString stringWithFormat:@"%@\n\n%@", confirmStr, hintStr];

    NSMutableAttributedString *formattedStr = [[NSMutableAttributedString alloc] initWithString:messageStr];

    [formattedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, messageStr.length)];
    [formattedStr addAttribute:NSForegroundColorAttributeName value:[UIColor systemBlueColor] range:[messageStr rangeOfString:contact]];
    [formattedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:[messageStr rangeOfString:contact]];
    [formattedStr addAttribute:NSForegroundColorAttributeName value:[UIColor systemBlueColor] range:[messageStr rangeOfString:source]];
    [formattedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:[messageStr rangeOfString:source]];

    return [formattedStr copy];
}

@interface PHRecentsItem : NSObject
@property (nonatomic, copy, readwrite) NSString *localizedTitle;
@property (nonatomic, copy, readwrite) NSString *localizedSubtitle;
@end

@interface MPRecentsTableViewCell : UITableViewCell
@property (nonatomic, strong, readwrite) PHRecentsItem *item;
@end

@interface MPRecentsTableViewController : UIViewController
@end

%hook MPRecentsTableViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!cmmBool(@"confirmRecents")) {
        return %orig;
    }

    MPRecentsTableViewCell *cell = (MPRecentsTableViewCell* )[tableView cellForRowAtIndexPath:indexPath];

    if (![cell isKindOfClass:%c(MPRecentsTableViewCell)]) {
        return %orig;
    }

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Call Me Maybe" message:nil preferredStyle:UIAlertControllerStyleAlert];
    alertController.attributedMessage = attributedMsg(cell.item.localizedTitle, cell.item.localizedSubtitle);

    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"CALL", @"General", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        %orig;
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"CANCEL", @"General", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }]];

    [self presentViewController:alertController animated:YES completion:nil];
}
%end

@interface MPFavoritesTableViewCell : UITableViewCell
@property (nonatomic, copy, readwrite) NSString *actionType;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *subtitleLabel;
@end

@interface MPFavoritesTableViewController : UIViewController
@end

%hook MPFavoritesTableViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!cmmBool(@"confirmFavs")) {
        return %orig;
    }

    MPFavoritesTableViewCell *cell = (MPFavoritesTableViewCell* )[tableView cellForRowAtIndexPath:indexPath];

    if (![cell isKindOfClass:%c(MPFavoritesTableViewCell)]) {
        return %orig;
    }

    if (![cell.actionType isEqualToString:@"AudioCallActionType"]) {
        return %orig;
    }

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Call Me Maybe" message:nil preferredStyle:UIAlertControllerStyleAlert];
    alertController.attributedMessage = attributedMsg(cell.titleLabel.text, cell.subtitleLabel.text);

    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"CALL", @"General", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        %orig;
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"CANCEL", @"General", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }]];

    [self presentViewController:alertController animated:YES completion:nil];
}
%end

%hook PhoneTabBarController
- (void)showFavoritesTab:(BOOL)favoritesTab recentsTab:(BOOL)recentsTab contactsTab:(BOOL)contactsTab keypadTab:(BOOL)keypadTab voicemailTab:(BOOL)voicemailTab {
    %orig(!cmmBool(@"hideFavsTab"), !cmmBool(@"hideRecentsTab"), !cmmBool(@"hideContactsTab"), keypadTab, !cmmBool(@"hideVoicemailTab"));
}
%end

@interface UITabBar () <UIContextMenuInteractionDelegate>
@end

%hook UITabBar
- (void)setSelectedItem:(UITabBarItem *)item {
    %orig;

    UIContextMenuInteraction *menuInteraction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
    [self addInteraction:menuInteraction];
}

%new
- (UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location {
    return [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:nil actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        NSString *settingsTitle = [NSString stringWithFormat:LOC(@"CMM.Settings"), @"Call Me Maybe"];

        UIAction *settingsAction = [UIAction actionWithTitle:settingsTitle image:[UIImage systemImageNamed:@"gear"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[Prefs alloc] init]];
            [self._viewControllerForAncestor presentViewController:navigationController animated:YES completion:nil];
        }];

        return [UIMenu menuWithTitle:@"" children:@[settingsAction]];
    }];
}
%end
