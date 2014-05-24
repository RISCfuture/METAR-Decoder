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

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:DailyPrecipitationAmountRegex];
        if (!match) return (self = nil);
        
        if ([match rangeAtIndex:2].location == NSNotFound) {
            NSString *codedAmount = [remarks substringWithRange:[match rangeAtIndex:1]];
            self.amount = [codedAmount integerValue]/100.0;
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
        return NSLocalizedString(@"indeterminate precipitation in the last 24 hours", @"remark");
    if (self.amount == 0)
        return NSLocalizedString(@"trace precipitation in the last 24 hours", @"remark");
    else
        return [NSString localizedStringWithFormat:NSLocalizedString(@"%0.2f inches of precipitation in the last 24 hours", @"precipitation amount"),
                self.amount];
}

@end
