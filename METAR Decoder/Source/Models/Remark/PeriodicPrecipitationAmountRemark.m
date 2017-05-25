#import "PeriodicPrecipitationAmountRemark.h"

static float IndeterminateAmount = -1.0;
static NSInteger UnknownPeriod = -1;

// 60217
// 60000
// 6////
static NSString *DailyPrecipitationAmountRegex = @"\\b6(?:(\\d{4})\\b|(\\/{4}))\\s*";

@implementation PeriodicPrecipitationAmountRemark

@synthesize amount;
@synthesize period;

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
        
        switch (self.parent.date.hour) {
            case 0:
            case 6:
            case 12:
            case 18:
                self.period = 6;
                break;
            case 3:
            case 9:
            case 15:
            case 21:
                self.period = 3;
                break;
            default:
                self.period = UnknownPeriod;
                break;
        }
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    NSString *periodString;
    if (self.period == UnknownPeriod)
        periodString = MDLocalizedString(@"METAR.Remark.PeriodicPrecipitationAmount.Period.Unknown", @"…hours");
    else periodString = [[NSNumber numberWithInteger:self.period] stringValue];
    
    if (self.amount == IndeterminateAmount)
        return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.PeriodicPrecipitationAmount.Indeterminate", @"{period}"),
                periodString];
    if (self.amount == 0)
        return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.PeriodicPrecipitationAmount.Trace", @"{period}"),
                periodString];
    else
        return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.PeriodicPrecipitationAmount", @"{amount}, {period}"),
                self.amount, periodString];
}

@end
