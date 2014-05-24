#import "WindShiftRemark.h"

// WSHFT 30
// WSHFT 30 FROPA
static NSString *WindShiftRegex = @"\\bWSHFT " REMARK_TIME_REGEX @"(?: (FROPA))?\\b\\s*";

@implementation WindShiftRemark

@synthesize date;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:WindShiftRegex];
        if (!match) return (self = nil);
        
        self.date = [self.parent parseDateFromMatch:match index:1 inString:remarks];
        self.frontalPassage = [match rangeAtIndex:3].location != NSNotFound;
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (NSString *) stringValue {
    NSString *dateString = [self.parent.timeOnlyFormatter stringFromDate:[self.parent.calendar dateFromComponents:date]];
    if (self.frontalPassage)
        return [NSString localizedStringWithFormat:NSLocalizedString(@"wind shift at %@ due to frontal passage", @"remark: time"), dateString];
    else
        return [NSString localizedStringWithFormat:NSLocalizedString(@"wind shift at %@", @"remark: time"), dateString];
        
}

- (RemarkUrgency) urgency {
    return UrgencyCaution;
}

@end
