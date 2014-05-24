#import "SeaLevelPressureRemark.h"

static float SLPNotAvailable = -1;

// SLP982
// SLPNO
static NSString *SeaLevelPressureRegex = @"\\bSLP(\\d{3}|NO)\\b\\s*";

@implementation SeaLevelPressureRemark

@synthesize pressure;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:SeaLevelPressureRegex];
        if (!match) return (self = nil);
        
        NSString *codedPressure = [remarks substringWithRange:[match rangeAtIndex:1]];
        if ([codedPressure isEqualToString:@"NO"]) self.pressure = SLPNotAvailable;
        else self.pressure = [codedPressure integerValue]/10.0 + 900;
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    if (self.pressure == SLPNotAvailable)
        return NSLocalizedString(@"sea-level pressure not available", @"remark");
    else
        return [NSString localizedStringWithFormat:NSLocalizedString(@"sea-level pressure %0.1f hPa", @"pressure in hPa"),
                self.pressure];
}

@end