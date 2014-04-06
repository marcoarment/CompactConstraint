
#import "UIView+CompactConstraint.h"

@implementation UIView (CompactConstraint)

- (NSLayoutConstraint *)addCompactConstraint:(NSString *)relationship metrics:(NSDictionary *)metrics views:(NSDictionary *)views
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint compactConstraint:relationship metrics:metrics views:views];
    [self addConstraint:constraint];
    return constraint;
}

- (void)addCompactConstraints:(NSArray *)relationshipStrings metrics:(NSDictionary *)metrics views:(NSDictionary *)views;
{
    for (NSString *relationship in relationshipStrings) [self addConstraint:[NSLayoutConstraint compactConstraint:relationship metrics:metrics views:views]];
}

- (void)addConstraintsWithVisualFormat:(NSString *)format options:(NSLayoutFormatOptions)opts metrics:(NSDictionary *)metrics views:(NSDictionary *)views
{
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:opts metrics:metrics views:views]];
}


@end
