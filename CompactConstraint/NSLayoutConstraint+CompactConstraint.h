//
//  Created by Marco Arment on 2014-04-06.
//  Copyright (c) 2014 Marco Arment. See included LICENSE file.
//

@interface NSLayoutConstraint (CompactConstraint)

+ (instancetype)compactConstraint:(NSString *)relationship metrics:(NSDictionary *)metrics views:(NSDictionary *)views;
+ (NSArray *)compactConstraints:(NSArray *)relationshipStrings metrics:(NSDictionary *)metrics views:(NSDictionary *)views;

@end
