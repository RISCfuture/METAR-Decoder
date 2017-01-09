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

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:ObservationTypeRegex];
        if (!match) return (self = nil);
        
        NSString *codedType = [remarks substringWithRange:[match rangeAtIndex:1]];
        if ([codedType isEqualToString:@"1"]) self.type = ObservationTypeAutomated;
        else if ([codedType isEqualToString:@"2"]) self.type = ObservationTypeAutomatedWithPrecipiation;
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
            string = NSLocalizedString(@"automated weather observing", @"remark");
            break;
        case ObservationTypeAutomatedWithPrecipiation:
            string = NSLocalizedString(@"automated weather observing (plus precipiation sensor)", @"remark");
            break;
        default:
            string = NSLocalizedString(@"unknown weather observing", @"remark");
            break;
    }

    if (self.augmented) {
        return [string stringByAppendingString:NSLocalizedString(@" augmented with human observer", @"observation type")];
    }
    else return string;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

@end
