//
//  Created by Marco Arment on 2014-04-06.
//  Copyright (c) 2014 Marco Arment. See included LICENSE file.
//

#import "NSLayoutConstraint+CompactConstraint.h"

static CGFloat standardSpacingToSuperview = 20.;
static CGFloat standardSpacingToView = 8.;

@implementation NSLayoutConstraint (CompactConstraint)


+ (NSArray *)compactConstraints:(NSArray *)relationshipStrings metrics:(NSDictionary *)metrics views:(NSDictionary *)views
{
    return [self compactConstraints:relationshipStrings metrics:metrics views:views self:nil];
}

+ (NSArray *)compactConstraints:(NSArray *)relationshipStrings metrics:(NSDictionary *)metrics views:(NSDictionary *)views self:(id)selfView
{
    NSMutableArray *constraints = [NSMutableArray array];
    for (NSString *relationship in relationshipStrings) {
        [constraints addObject:[self compactConstraint:relationship metrics:metrics views:views self:selfView]];
    }
    return [constraints copy];
}

+ (instancetype)compactConstraint:(NSString *)relationship metrics:(NSDictionary *)metrics views:(NSDictionary *)views
{
    return [self compactConstraint:relationship metrics:metrics views:views self:nil];
}

+ (instancetype)compactConstraint:(NSString *)relationship metrics:(NSDictionary *)metrics views:(NSDictionary *)views self:(id)selfView
{
    static NSCharacterSet *operatorCharacterSet = nil;
    static NSCharacterSet *multiplicationOperatorCharacterSet = nil;
    static NSCharacterSet *additionOperatorCharacterSet = nil;
    static NSCharacterSet *leftOperandTerminatingCharacterSet = nil;
    static NSCharacterSet *rightOperandTerminatingCharacterSet = nil;
    static NSDictionary *propertyDictionary = nil;
    if (! propertyDictionary) {
        propertyDictionary = @{
            @".left" : @(NSLayoutAttributeLeft),
            @".right" : @(NSLayoutAttributeRight),
            @".top" : @(NSLayoutAttributeTop),
            @".bottom" : @(NSLayoutAttributeBottom),
            @".leading" : @(NSLayoutAttributeLeading),
            @".trailing" : @(NSLayoutAttributeTrailing),
            @".width" : @(NSLayoutAttributeWidth),
            @".height" : @(NSLayoutAttributeHeight),
            @".centerX" : @(NSLayoutAttributeCenterX),
            @".centerY" : @(NSLayoutAttributeCenterY),
            @".baseline" : @(NSLayoutAttributeBaseline),
        };

        multiplicationOperatorCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"*/"];
        additionOperatorCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"+-"];

        NSMutableCharacterSet *rotcs = [NSCharacterSet.whitespaceAndNewlineCharacterSet mutableCopy];
        [rotcs formUnionWithCharacterSet:multiplicationOperatorCharacterSet];
        [rotcs formUnionWithCharacterSet:additionOperatorCharacterSet];
        rightOperandTerminatingCharacterSet = [rotcs copy];

        operatorCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"<>="];

        NSMutableCharacterSet *lotcs = [NSCharacterSet.whitespaceAndNewlineCharacterSet mutableCopy];
        [lotcs formUnionWithCharacterSet:operatorCharacterSet];
        leftOperandTerminatingCharacterSet = [lotcs copy];
    }

    NSScanner *scanner = [NSScanner scannerWithString:relationship];
    scanner.charactersToBeSkipped = NSCharacterSet.whitespaceAndNewlineCharacterSet;

    id leftOperand, rightOperand, leftAttributeNumber, rightAttributeNumber, rightMetricNumber;
    NSLayoutAttribute leftAttribute, rightAttribute;
    double rightScalar = 1.0, rightConstant = 0.0, rightMetric = 0.0;
    BOOL rightOperandIsMetric = NO;
    NSString *leftOperandStr, *leftPropertyStr, *operatorStr, *rightOperandStr, *rightPropertyStr, *rightValueStr;

    BOOL leftOperandScanned = [scanner scanUpToCharactersFromSet:leftOperandTerminatingCharacterSet intoString:&leftOperandStr];
    NSAssert(leftOperandScanned, @"No left operand given");
    if (leftOperandScanned) {}
    leftOperandStr = [leftOperandStr stringByTrimmingCharactersInSet:leftOperandTerminatingCharacterSet];
    NSRange lastDot = [leftOperandStr rangeOfString:@"." options:NSBackwardsSearch];
    NSAssert1(lastDot.location != NSNotFound, @"Left operand has no property, e.g. '%@.width'", leftOperandStr);
    leftPropertyStr = [leftOperandStr substringFromIndex:lastDot.location];
    leftOperandStr = [leftOperandStr substringToIndex:lastDot.location];
    leftOperand = views[leftOperandStr];
    if (! leftOperand && [leftOperandStr isEqualToString:@"self"]) {
        leftOperand = selfView;
        NSAssert(leftOperand, @"Left operand is self, but self is nil or not supplied");
    }
    NSAssert1(leftOperand, @"Left operand '%@' not found in views dictionary", leftOperandStr);

    leftAttributeNumber = propertyDictionary[leftPropertyStr];
    NSAssert1(leftAttributeNumber, @"Unrecognized left property '%@'", leftPropertyStr);
    leftAttribute = (NSLayoutAttribute) [leftAttributeNumber integerValue];

    BOOL operatorScanned = [scanner scanCharactersFromSet:operatorCharacterSet intoString:&operatorStr];
    NSAssert(operatorScanned, @"No operator given");
    if (operatorScanned) {}
    NSLayoutRelation relation;
    if ([operatorStr isEqualToString:@"=="] || [operatorStr isEqualToString:@"="]) relation = NSLayoutRelationEqual;
    else if ([operatorStr isEqualToString:@">="]) relation = NSLayoutRelationGreaterThanOrEqual;
    else if ([operatorStr isEqualToString:@"<="]) relation = NSLayoutRelationLessThanOrEqual;
    else { NSAssert(0, @"Unrecognized operator '%@'. Valid operators: = == >= <=", operatorStr); relation = NSLayoutRelationEqual; }

    if ([scanner scanDouble:&rightConstant]) {
        // constant without right operand, e.g. "a.width >= 42"
        rightOperand = nil;
        rightAttribute = NSLayoutAttributeNotAnAttribute;
    } else {
        // right operand is a symbol. Either a metric or a view. Views have dot-properties, metrics don't.
        BOOL rightOperandScanned = [scanner scanUpToCharactersFromSet:rightOperandTerminatingCharacterSet intoString:&rightOperandStr];
        NSAssert(rightOperandScanned, @"No right operand given");
        if (rightOperandScanned) {}

        lastDot = [rightOperandStr rangeOfString:@"." options:NSBackwardsSearch];
        if (lastDot.location == NSNotFound) {
            // No dots. Right operand is a metric, not a view.
            rightOperandIsMetric = YES;
            rightAttribute = NSLayoutAttributeNotAnAttribute;
            rightOperand = nil;
            if ([rightOperandStr isEqualToString:@"std"]) {
                if (leftAttribute == NSLayoutAttributeTop || leftAttribute == NSLayoutAttributeLeft) {
                    rightMetric = standardSpacingToSuperview;
                } else {
                    NSAssert(NO, @"Right metric 'std' can only be used with 'top' or 'left' left attributed");
                }
            } else {
            rightMetricNumber = metrics[rightOperandStr];
            NSAssert1(rightMetricNumber, @"Right metric '%@' not found in metrics dictionary", rightOperandStr);
            rightMetric = [rightMetricNumber doubleValue];
            }
        } else {
            rightPropertyStr = [rightOperandStr substringFromIndex:lastDot.location];
            rightOperandStr = [rightOperandStr substringToIndex:lastDot.location];
            rightOperand = views[rightOperandStr];
            if (! rightOperand) {
                if ([rightOperandStr isEqualToString:@"super"]) {
                    rightOperand = [leftOperand superview];
                    NSAssert(rightOperand, @"Right operand is super, but superview of left operand is nil");
                } else if ([rightOperandStr isEqualToString:@"self"]) {
                    rightOperand = selfView;
                    NSAssert(rightOperand, @"Right operand is self, but self is nil or not supplied");
                }
            }
            NSAssert1(rightOperand, @"Right operand '%@' not found in views dictionary", rightOperandStr);

            rightAttributeNumber = propertyDictionary[rightPropertyStr];
            NSAssert1(rightAttributeNumber, @"Unrecognized right property '%@'", rightPropertyStr);
            rightAttribute = (NSLayoutAttribute) [rightAttributeNumber integerValue];
        }
    }

    NSString *valueOperator;
    if ([scanner scanCharactersFromSet:multiplicationOperatorCharacterSet intoString:&valueOperator]) {
        if (! [scanner scanDouble:&rightScalar]) {
            // see if the scalar is a metric instead of a literal number
            BOOL scalarAfterMultiplication = [scanner scanUpToCharactersFromSet:rightOperandTerminatingCharacterSet intoString:&rightValueStr];
            NSAssert(scalarAfterMultiplication, @"No scalar given after '*' on right side");
            if (scalarAfterMultiplication) {}
            rightMetricNumber = metrics[rightValueStr];
            NSAssert1(rightMetricNumber, @"Right scalar '%@' not found in metrics dictionary", rightValueStr);
            rightScalar = [rightMetricNumber doubleValue];
        }

        if ([valueOperator isEqualToString:@"/"]) rightScalar = 1.0 / rightScalar;
    }

    if ([scanner scanCharactersFromSet:additionOperatorCharacterSet intoString:&valueOperator]) {
        if (! [scanner scanDouble:&rightConstant]) {
            // see if the scalar is a metric instead of a literal number
            BOOL constantAfterAddition = [scanner scanUpToCharactersFromSet:rightOperandTerminatingCharacterSet intoString:&rightValueStr];
            NSAssert(constantAfterAddition, @"No constant given after '+' on right side");
            if (constantAfterAddition) {}
            if ([rightValueStr isEqualToString:@"std"] && !rightOperandIsMetric) {
                if ([leftOperand isDescendantOfView:rightOperand] || [rightOperand isDescendantOfView:leftOperand]) {
                    rightConstant = standardSpacingToSuperview;
                } else {
                    rightConstant = standardSpacingToView;
                }
            } else {
                rightMetricNumber = metrics[rightValueStr];
                NSAssert1(rightMetricNumber, @"Right constant '%@' not found in metrics dictionary", rightValueStr);
                rightConstant = [rightMetricNumber doubleValue];
            }
        }

        if ([valueOperator isEqualToString:@"-"]) rightConstant = -rightConstant;
    }

    if (rightOperandIsMetric) {
        rightConstant = rightMetric * rightScalar + rightConstant;
        rightScalar = 1.0;
    }

    return [NSLayoutConstraint constraintWithItem:leftOperand attribute:leftAttribute relatedBy:relation toItem:rightOperand attribute:rightAttribute multiplier:rightScalar constant:rightConstant];
}

+ (void) setStandardSpacingToSuperview:(CGFloat)value {
    standardSpacingToSuperview = value;
}

+ (void) setStandardSpacingToView:(CGFloat)value {
    standardSpacingToView = value;
}
@end
