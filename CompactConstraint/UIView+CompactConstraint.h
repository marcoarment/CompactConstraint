#import "NSLayoutConstraint+CompactConstraint.h"

@interface UIView (CompactConstraint)

- (NSLayoutConstraint *)addCompactConstraint:(NSString *)relationship metrics:(NSDictionary *)metrics views:(NSDictionary *)views;
- (void)addCompactConstraints:(NSArray *)relationshipStrings metrics:(NSDictionary *)metrics views:(NSDictionary *)views;

// And a convenient shortcut for what we always end up doing with the visualFormat call.
- (void)addConstraintsWithVisualFormat:(NSString *)format options:(NSLayoutFormatOptions)opts metrics:(NSDictionary *)metrics views:(NSDictionary *)views;

@end

