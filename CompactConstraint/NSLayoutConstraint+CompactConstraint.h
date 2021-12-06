//
//  Created by Marco Arment on 2014-04-06.
//  Copyright (c) 2014 Marco Arment. See included LICENSE file.
//

#import "TargetConditionals.h" 

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@interface NSLayoutConstraint (CompactConstraint)

+ (instancetype _Nonnull)compactConstraint:(NSString * _Nonnull)relationship metrics:(NSDictionary * _Nullable)metrics views:(NSDictionary * _Nullable)views self:(id _Nullable)selfView;
+ (NSArray<NSLayoutConstraint *> * _Nonnull)compactConstraints:(NSArray * _Nullable)relationshipStrings metrics:(NSDictionary * _Nullable)metrics views:(NSDictionary * _Nullable)views self:(id _Nullable)selfView;

// And a convenient shortcut for creating constraints with the visualFormat string as the identifier
+ (NSArray<NSLayoutConstraint *> * _Nonnull)identifiedConstraintsWithVisualFormat:(NSString * _Nonnull)format options:(NSLayoutFormatOptions)opts metrics:(NSDictionary * _Nullable)metrics views:(NSDictionary * _Nullable)views;

@end
