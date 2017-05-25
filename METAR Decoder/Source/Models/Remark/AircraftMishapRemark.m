#import "AircraftMishapRemark.h"

// (ACFT MSHP)
static NSString *AircraftMishapRegex = @"\\(ACFT MSHP\\)\\s*";

@implementation AircraftMishapRemark

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:AircraftMishapRegex];
        if (!match) return (self = nil);
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyUrgent;
}

- (NSString *) stringValue {
    return MDLocalizedString(@"METAR.Remark.AircraftMishap", @"remark");
}

@end
