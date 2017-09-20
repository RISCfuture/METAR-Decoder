#import "DailyPrecipitationAmountRemark.h"

static float IndeterminateAmount = -1.0;

// 70125
// 7////
static NSString *DailyPrecipitationAmountRegex = @"\\b7(?:(\\d{4})\\b|(\\/{4}))\\s*";

@implementation DailyPrecipitationAmountRemark

@synthesize amount;

+ (void) load {
    [Remark registerSubclass:self];
}

- (instancetype) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:DailyPrecipitationAmountRegex];
        if (!match) return (self = nil);
        
        if ([match rangeAtIndex:2].location == NSNotFound) {
            NSString *codedAmount = [remarks substringWithRange:[match rangeAtIndex:1]];
            self.amount = codedAmount.integerValue/100.0;
        }
        else self.amount = IndeterminateAmount;
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    if (self.amount == IndeterminateAmount)
        return MDLocalizedString(@"METAR.Remark.DailyPrecipitationAmount.Indeterminate", nil);
    if (self.amount == 0)
        return MDLocalizedString(@"METAR.Remark.DailyPrecipitationAmount.Trace", nil);
    else
        return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.DailyPrecipitationAmount", @"{precipitation amount}"),
                self.amount];
}

@end
