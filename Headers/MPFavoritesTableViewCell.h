#import <UIKit/UIKit.h>

@interface MPFavoritesTableViewCell : UITableViewCell
@property (nonatomic, copy, readwrite) NSString *actionType;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *subtitleLabel;
@end
