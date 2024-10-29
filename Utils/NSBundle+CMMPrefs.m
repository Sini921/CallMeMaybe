#import "NSBundle+CMMPrefs.h"

@implementation NSBundle (CallMeMaybe)

+ (NSBundle *)cmm_defaultBundle {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        NSString *tweakBundlePath = [[NSBundle mainBundle] pathForResource:@"CallMeMaybe" ofType:@"bundle"];
        NSString *rootlessBundlePath = jbroot(@"/Library/Application Support/CallMeMaybe.bundle");

        bundle = [NSBundle bundleWithPath:tweakBundlePath ?: rootlessBundlePath];
    });

    return bundle;
}

@end