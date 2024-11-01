#import "Prefs.h"

#define TAG_FOR_INDEX_PATH(section, row) ((section << 16) | (row & 0xFFFF))
#define SECTION_FROM_TAG(tag) (tag >> 16)
#define ROW_FROM_TAG(tag) (tag & 0xFFFF)

@implementation Prefs
{
    NSArray *_sections;
    NSArray *_main;
    NSArray *_recents;
    NSArray *_tabs;
    NSArray *_reset;
    NSArray *_developer;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {

    self = [super initWithStyle:UITableViewStyleInsetGrouped];

    if (self) {
        _main = @[
            @{@"title": @"Favorites", @"icon": @"star.fill", @"type": @"bool", @"key": @"confirmFavs", @"id": @"mainCell"},
            @{@"title": @"RecentCalls", @"icon": @"clock.fill", @"type": @"bool", @"key": @"confirmRecents", @"id": @"mainCell"}
        ];

        _recents = @[
            @{@"title": @"NoTelCalls", @"desc": @"NoTelCallsDesc", @"icon": @"teletype", @"type": @"bool", @"key": @"hideTelCalls", @"id": @"recentsCell"},
            @{@"title": @"NoAppCalls", @"desc": @"NoAppCallsDesc", @"icon": @"sparkles", @"type": @"bool", @"key": @"hideAppCalls", @"id": @"recentsCell"},
            @{@"title": @"NoFTCalls", @"desc": @"NoFTCallsDesc", @"icon": @"video", @"type": @"bool", @"key": @"hideFTCalls", @"id": @"recentsCell"}
        ];

        _tabs = @[
            @{@"title": @"HideFavsTab", @"icon": @"star", @"type": @"bool", @"key": @"hideFavsTab", @"id": @"tabsCell"},
            @{@"title": @"HideRecentsTab", @"icon": @"clock", @"type": @"bool", @"key": @"hideRecentsTab", @"id": @"tabsCell"},
            @{@"title": @"HideContactsTab", @"icon": @"person.crop.circle", @"type": @"bool", @"key": @"hideContactsTab", @"id": @"tabsCell"},
            @{@"title": @"HideKeypadTab", @"icon": @"circle.grid.3x3", @"type": @"bool", @"key": @"hideKeypadTab", @"id": @"tabsCell"},
            @{@"title": @"HideVoicemailTab", @"icon": @"recordingtape", @"type": @"bool", @"key": @"hideVoicemailTab", @"id": @"tabsCell"},
        ];

        _reset = @[
            @{@"title": @"ResetSettings", @"icon": @"trash",@"type": @"reset", @"key": @"reset", @"id": @"resetCell"},
        ];

        _developer = @[
            @{@"title": @"FollowMe", @"icon": @"dvn", @"type": @"link", @"key": @"https://twitter.com/dayanch96", @"id": @"devCell"},
            @{@"title": @"Github", @"icon": @"github", @"type": @"link", @"key": @"https://github.com/dayanch96/CallMeMaybe", @"id": @"devCell"},
            @{@"title": @"Patreon", @"icon": @"patreon", @"type": @"link", @"key": @"https://patreon.com/dayanch96", @"id": @"devCell"},
            @{@"title": @"Coffee", @"icon": @"coffee", @"type": @"link", @"key": @"https://buymeacoffee.com/dayanch96", @"id": @"devCell"}
        ];

        _sections = @[_main, _recents, _tabs, _reset, _developer];

        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"xmark"]
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(dismissButtonTapped)]; 
    }

    return self;
}

- (NSString *)title {
    return @"Call Me Maybe";
}

- (void)dismissButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_sections[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *header;

    if (section == [_sections indexOfObject:_main]) {
        header = @"Confirmation.Header";
    }

    if (section == [_sections indexOfObject:_recents]) {
        header = @"Recents.Header";
    }

    if (section == [_sections indexOfObject:_tabs]) {
        header = @"Tabs.Header";
    }

    return LOC(header);
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString *footer;

    if (section == [_sections indexOfObject:_main]) {
        footer = @"Confirmation.Footer";
    }

    if (section == [_sections indexOfObject:_recents]) {
        footer = @"Recents.Footer";
    }

    if (section == _sections.count - 1) {
        return [NSString stringWithFormat:@"v%@", @(OS_STRINGIFY(TWEAK_VERSION))];
    }

    return LOC(footer);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }

    if (_sections[indexPath.section]) {
        NSDictionary *data = _sections[indexPath.section][indexPath.row];

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:data[@"id"]];

        if (data[@"title"]) {
            cell.textLabel.text = LOC(data[@"title"]);
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
        }

        if (data[@"desc"]) {
            cell.detailTextLabel.text = LOC(data[@"desc"]);
            cell.detailTextLabel.numberOfLines = 0;
        }

        if ([data[@"type"] isEqualToString:@"bool"]) {
            cell.imageView.image = [self cellImageWithName:data[@"icon"]];

            UISwitch *switchControl = [self switchForKey:data[@"key"]];
            switchControl.tag = TAG_FOR_INDEX_PATH(indexPath.section, indexPath.row);

            cell.accessoryView = switchControl;
        }

        if ([data[@"type"] isEqualToString:@"reset"]) {
            cell.tintColor = [UIColor redColor];
            cell.textLabel.textColor = [UIColor redColor];
            cell.imageView.image = [self cellImageWithName:data[@"icon"]];
        }

        if ([data[@"type"] isEqualToString:@"link"]) {
            UIImage *image = [UIImage imageNamed:data[@"icon"] inBundle:NSBundle.cmm_defaultBundle compatibleWithTraitCollection:nil];

            cell.imageView.image = image;
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"safari"]];

            NSArray <NSString *> *bwIcons = @[@"github", @"patreon"];
            if ([bwIcons containsObject:data[@"icon"]]) {
                cell.imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                cell.imageView.tintColor = [UIColor labelColor];
            }
        }

        return cell;
    }

    return cell;
}

- (UIImage *)cellImageWithName:(NSString *)imageName {
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(20, 20)];
    UIImage *newImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        UIImage *iconImage = [UIImage systemImageNamed:imageName];
        UIView *imageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:iconImage];
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        iconImageView.clipsToBounds = YES;
        iconImageView.frame = imageView.bounds;

        [imageView addSubview:iconImageView];
        [imageView.layer renderInContext:rendererContext.CGContext];
    }];

    return [newImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (UISwitch *)switchForKey:(NSString *)key {
    UISwitch *switchControl = [[UISwitch alloc] init];
    switchControl.onTintColor = [UIColor systemBlueColor];
    switchControl.on = cmmBool(key);
    switchControl.visualElement.showsOnOffLabel = YES;

    [switchControl addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventValueChanged];

    return switchControl;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = _sections[indexPath.section][indexPath.row];

    if ([data[@"type"] isEqualToString:@"bool"]) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UISwitch *switchControl = (UISwitch *)cell.accessoryView;

        [switchControl setOn:!switchControl.on animated:YES];
        [self toggleSwitch:switchControl];
    }

    if ([data[@"type"] isEqualToString:@"reset"]) {
        [CMMUserDefaults resetUserDefaults];
        [tableView reloadData];
    }

    if ([data[@"type"] isEqualToString:@"link"]) {
        NSURL *url = [NSURL URLWithString:data[@"key"]];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)toggleSwitch:(UISwitch *)sender {
    NSInteger tag = sender.tag;
    NSInteger section = SECTION_FROM_TAG(tag);
    NSInteger row = ROW_FROM_TAG(tag);

    NSDictionary *data = _sections[section][row];
    if (data) {
        [[CMMUserDefaults standardUserDefaults] setBool:sender.isOn forKey:data[@"key"]];
    }

    if (section == [_sections indexOfObject:_tabs]) {
        NSInteger tabsCount = 0;

        for (NSDictionary *tab in _tabs) {
            if (!cmmBool(tab[@"key"])) {
                tabsCount++;
            }
        }

        if (tabsCount == 0 && sender.isOn == YES) {
            [[CMMUserDefaults standardUserDefaults] setBool:NO forKey:data[@"key"]];

            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];

            NSString *messageStr = [NSString stringWithFormat:@"%@\n\n%@", LOC(@"Warning"), LOC(@"Error.OneTab")];

            NSMutableAttributedString *formattedStr = [[NSMutableAttributedString alloc] initWithString:messageStr];

            [formattedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, messageStr.length)];
            [formattedStr addAttribute:NSForegroundColorAttributeName value:[UIColor systemRedColor] range:[messageStr rangeOfString:LOC(@"Warning")]];
            [formattedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:[messageStr rangeOfString:LOC(@"Warning")]];

            alertController.attributedTitle = [NSAttributedString attributedStringWithAttachment:[NSTextAttachment textAttachmentWithImage:[UIImage imageNamed:@"icon" inBundle:NSBundle.cmm_defaultBundle compatibleWithTraitCollection:nil]]];
            alertController.attributedMessage = formattedStr.copy;

            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"PHCarPlay", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [sender setOn:NO animated:YES];
            }]];

            [self presentViewController:alertController animated:YES completion:nil];
        }

        PhoneApplication *app = (PhoneApplication *)[[UIApplication sharedApplication] delegate];
        MPRootViewController *rootVC = [app valueForKey:@"_rootController"];

        [rootVC.baseViewController showFavoritesTab:YES recentsTab:YES contactsTab:YES keypadTab:!cmmBool(@"hideKeypadTab") voicemailTab:YES];
    }
}

@end
