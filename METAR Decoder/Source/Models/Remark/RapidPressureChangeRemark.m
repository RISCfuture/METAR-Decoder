#import "RapidPressureChangeRemark.h"

// PRESRR
// PRESFR
static NSString *RapidPressureChangeRegex = @"\\b(PRES[RF]R)\\b\\s*";

@implementation RapidPressureChangeRemark

@synthesize rising;

+ (void) load {
    [Remark registerSubclass:self];
}

- (instancetype) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:RapidPressureChangeRegex];
        if (!match) return (self = nil);
        
        NSString *codedRemark = [remarks substringWithRange:[match rangeAtIndex:1]];
        self.rising = [codedRemark isEqualToString:@"PRESRR"];
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyCaution;
}

- (NSString *) stringValue {
    if (self.rising)
        return MDLocalizedString(@"METAR.Remark.RapidPressureChange.Rising", nil);
    else
        return MDLocalizedString(@"METAR.Remark.RapidPressureChange.Falling", nil);
}

@end
