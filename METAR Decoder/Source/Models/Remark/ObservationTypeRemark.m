#import "ObservationTypeRemark.h"

// AO1
// AO2
static NSString *ObservationTypeRegex = @"\\bAO(\\d+)\\b\\s*";

@implementation ObservationTypeRemark

@synthesize type;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:ObservationTypeRegex];
        if (!match) return (self = nil);
        
        NSString *codedType = [remarks substringWithRange:[match rangeAtIndex:1]];
        if ([codedType isEqualToString:@"1"]) self.type = ObservationTypeAutomated;
        else if ([codedType isEqualToString:@"2"]) self.type = ObservationTypeAutomatedWithPrecipiation;
        else return (self = nil);
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (NSString *) stringValue {
    switch (self.type) {
        case ObservationTypeAutomated:
            return NSLocalizedString(@"automated weather observing", @"remark");
        case ObservationTypeAutomatedWithPrecipiation:
            return NSLocalizedString(@"automated weather observing (plus precipiation sensor)", @"remark");
        default:
            return NSLocalizedString(@"unknown weather observing", @"remark");
    }
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

@end
