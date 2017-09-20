#import "ImproperFraction.h"

@implementation ImproperFraction

@synthesize whole;
@synthesize fraction;

- (instancetype) initWithWhole:(NSInteger)wholePart fraction:(Rational *)fractionalPart {
    if (self = [super init]) {
        self.whole = wholePart;
        self.fraction = fractionalPart;
    }
    return self;
}

- (NSString *) stringValue {
    if (self.whole && self.fraction)
        return [NSString localizedStringWithFormat:MDLocalizedString(@"Common.ImproperFraction", @"{whole}, {fractional}"),
                self.whole, [self.fraction stringValue]];
    else if (self.whole)
        return @(self.whole).stringValue;
    else
        return [self.fraction stringValue];
}

@end
