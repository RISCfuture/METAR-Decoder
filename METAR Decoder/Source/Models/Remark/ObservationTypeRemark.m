#import "ObservationTypeRemark.h"

// AO1
// AO2
// A02A
static NSString *ObservationTypeRegex = @"\\bAO(\\d+)(A)?\\b\\s*";

@implementation ObservationTypeRemark

@synthesize type;
@synthesize augmented;

+ (void) load {
    [Remark registerSubclass:self];
}

- (instancetype) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:ObservationTypeRegex];
        if (!match) return (self = nil);
        
        NSString *codedType = [remarks substringWithRange:[match rangeAtIndex:1]];
        if ([codedType isEqualToString:@"1"]) self.type = ObservationTypeAutomated;
        else if ([codedType isEqualToString:@"2"]) self.type = ObservationTypeAutomatedWithPrecipitation;
        else return (self = nil);

        self.augmented = [match rangeAtIndex:2].location != NSNotFound;
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (NSString *) stringValue {
    NSString *string;
    switch (self.type) {
        case ObservationTypeAutomated:
            string = MDLocalizedString(@"METAR.Remark.ObservationType.AO", nil);
            break;
        case ObservationTypeAutomatedWithPrecipitation:
            string = MDLocalizedString(@"METAR.Remark.ObservationType.AO2", nil);
            break;
        default:
            string = MDLocalizedString(@"METAR.Remark.ObservationType.Unknown", nil);
            break;
    }

    if (self.augmented) {
        return [string stringByAppendingString:MDLocalizedString(@"METAR.Remark.ObservationType.HumanAugmented", nil)];
    }
    else return string;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

@end
