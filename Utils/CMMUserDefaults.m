#import "CMMUserDefaults.h"

@implementation CMMUserDefaults

static NSString *const kDefaultsSuiteName = @"com.dvntm.cmm";

+ (CMMUserDefaults *)standardUserDefaults {
    static dispatch_once_t onceToken;
    static CMMUserDefaults *defaults = nil;

    dispatch_once(&onceToken, ^{
        defaults = [[self alloc] initWithSuiteName:kDefaultsSuiteName];
        [defaults registerDefaults];
    });

    return defaults;
}

- (void)reset {
    [self removePersistentDomainForName:kDefaultsSuiteName];
}

- (void)registerDefaults {
    [self registerDefaults:@{
        @"confirmRecents": @YES,
        @"confirmFavs": @YES,
        @"hideVoicemailTab": @YES
    }];
}

+ (void)resetUserDefaults {
    [[self standardUserDefaults] reset];
}

@end
