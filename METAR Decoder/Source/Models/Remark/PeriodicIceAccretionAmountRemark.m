#import "PeriodicIceAccretionAmountRemark.h"

// I3000
static NSString *PeriodicIceAccretionAmountRemarkRegex = @"\\bI([136])(\\d{3})\\b\\s*";

@implementation PeriodicIceAccretionAmountRemark

@synthesize period;
@synthesize amount;

+ (void) load {
    [Remark registerSubclass:self];
}

- (instancetype) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:PeriodicIceAccretionAmountRemarkRegex];
        if (!match) return (self = nil);

        NSString *codedPeriod = [remarks substringWithRange:[match rangeAtIndex:1]];
        self.period = (int)codedPeriod.integerValue;
        NSString *codedAmount = [remarks substringWithRange:[match rangeAtIndex:2]];
        self.amount = codedAmount.integerValue/100.0;

        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    if (self.amount == 0)
        return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.PeriodicIceAccretionAmount.Trace", @"{period}"),
                self.period];
    else
        return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.PeriodicIceAccretionAmount", @"{amount}, {period}"),
                self.amount, self.period];
}

@end
