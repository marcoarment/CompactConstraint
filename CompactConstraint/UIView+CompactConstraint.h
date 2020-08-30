//
//  Created by Marco Arment on 2014-04-06.
//  Copyright (c) 2014 Marco Arment. See included LICENSE file.
//

#import "NSLayoutConstraint+CompactConstraint.h"

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
    #define CCView UIView
#elif TARGET_OS_MAC
    #define CCView NSView
#endif

@interface CCView (CompactConstraint)

// Add a single constraint with the compact syntax
- (NSLayoutConstraint * _Nullable)addCompactConstraint:(NSString * _Nonnull)relationship metrics:(NSDictionary * _Nullable)metrics views:(NSDictionary * _Nullable)views;

// Add any number of constraints. Can also mix in Visual Format Language strings.
- (NSArray * _Nullable)addCompactConstraints:(NSArray * _Nonnull)relationshipStrings metrics:(NSDictionary * _Nullable)metrics views:(NSDictionary * _Nullable)views;

// And a convenient shortcut for what we always end up doing with the visualFormat call.
- (void)addConstraintsWithVisualFormat:(NSString * _Nonnull)format options:(NSLayoutFormatOptions)opts metrics:(NSDictionary * _Nullable)metrics views:(NSDictionary * _Nullable)views;

@end
