//
//  Created by Marco Arment on 2014-04-06.
//  Copyright (c) 2014 Marco Arment. See included LICENSE file.
//

#import "UIView+CompactConstraint.h"

@implementation UIView (CompactConstraint)

- (NSLayoutConstraint *)addCompactConstraint:(NSString *)relationship metrics:(NSDictionary *)metrics views:(NSDictionary *)views
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint compactConstraint:relationship metrics:metrics views:views self:self];
    [self addConstraint:constraint];
    return constraint;
}

- (NSArray *)addCompactConstraints:(NSArray *)relationshipStrings metrics:(NSDictionary *)metrics views:(NSDictionary *)views;
{
    NSMutableArray *mConstraints = [NSMutableArray arrayWithCapacity:relationshipStrings.count];
    for (NSString *relationship in relationshipStrings) [mConstraints addObject:[NSLayoutConstraint compactConstraint:relationship metrics:metrics views:views self:self]];
    NSArray *constraints = [mConstraints copy];
    [self addConstraints:constraints];
    return constraints;
}

- (void)addConstraintsWithVisualFormat:(NSString *)format options:(NSLayoutFormatOptions)opts metrics:(NSDictionary *)metrics views:(NSDictionary *)views
{
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:opts metrics:metrics views:views]];
}

@end
