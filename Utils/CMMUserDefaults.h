#import <Foundation/Foundation.h>

#define cmmBool(key) [[CMMUserDefaults standardUserDefaults] boolForKey:key]

NS_ASSUME_NONNULL_BEGIN

@interface CMMUserDefaults : NSUserDefaults 

@property (class, readonly, strong) CMMUserDefaults *standardUserDefaults;

- (void)reset;
+ (void)resetUserDefaults;

@end

NS_ASSUME_NONNULL_END
