
@interface NSLayoutConstraint (CompactConstraint)

+ (instancetype)compactConstraint:(NSString *)relationship metrics:(NSDictionary *)metrics views:(NSDictionary *)views;
+ (NSArray *)compactConstraints:(NSArray *)relationshipStrings metrics:(NSDictionary *)metrics views:(NSDictionary *)views;

@end
