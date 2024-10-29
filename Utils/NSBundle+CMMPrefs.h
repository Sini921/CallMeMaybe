#import <Foundation/Foundation.h>
#import <roothide.h>

#define LOC(key) [NSBundle.cmm_defaultBundle localizedStringForKey:key value:nil table:nil]

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (CMMPrefs)

@property (class, nonatomic, readonly) NSBundle *cmm_defaultBundle;

@end

NS_ASSUME_NONNULL_END