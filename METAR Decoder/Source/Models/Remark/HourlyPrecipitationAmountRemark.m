#import "HourlyPrecipitationAmountRemark.h"

// P0009
// P0000
static NSString *HourlyPrecipitationAmountRegex = @"\\bP(\\d{4})\\b\\s*";

@implementation HourlyPrecipitationAmountRemark

@synthesize amount;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:HourlyPrecipitationAmountRegex];
        if (!match) return (self = nil);
        
        NSString *codedAmount = [remarks substringWithRange:[match rangeAtIndex:1]];
        self.amount = [codedAmount integerValue]/100.0;
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    if (self.amount == 0)
        return NSLocalizedString(@"trace precipitation in the last hour", @"remark");
    else
        return [NSString localizedStringWithFormat:NSLocalizedString(@"%0.2f inches of precipitation in the last hour", @"precipitation amount"),
                self.amount];
}

@end
