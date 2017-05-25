#import "NoSPECIRemark.h"

// (ACFT MSHP)
static NSString *NoSPECIRegex = @"\\bNOSPECI\\b\\s*";

@implementation NoSPECIRemark

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:NoSPECIRegex];
        if (!match) return (self = nil);
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    return MDLocalizedString(@"METAR.Remark.NoSPECI", nil);
}

@end
