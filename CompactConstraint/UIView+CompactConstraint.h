//
//  Created by Marco Arment on 2014-04-06.
//  Copyright (c) 2014 Marco Arment. See included LICENSE file.
//

#import "NSLayoutConstraint+CompactConstraint.h"

@interface UIView (CompactConstraint)

- (NSLayoutConstraint *)addCompactConstraint:(NSString *)relationship metrics:(NSDictionary *)metrics views:(NSDictionary *)views;
- (NSArray *)addCompactConstraints:(NSArray *)relationshipStrings metrics:(NSDictionary *)metrics views:(NSDictionary *)views;

// And a convenient shortcut for what we always end up doing with the visualFormat call.
- (void)addConstraintsWithVisualFormat:(NSString *)format options:(NSLayoutFormatOptions)opts metrics:(NSDictionary *)metrics views:(NSDictionary *)views;

@end
