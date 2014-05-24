#import "PeakWindsRemark.h"

// PK WND 28045/15
// PK WND 28045/1215
static NSString *PeakWindsRegex = @"\\bPK WND " METAR_WIND_REGEX @"\\/" REMARK_TIME_REGEX @"\\b\\s*";

@implementation PeakWindsRemark

@synthesize wind;
@synthesize date;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:PeakWindsRegex];
        if (!match) return (self = nil);
        
        self.wind = [self.parent parseWindFromMatch:match index:1 inString:remarks];
        self.date = [self.parent parseDateFromMatch:match index:3 inString:remarks];
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (NSString *) stringValue {
    NSString *dateString = [self.parent.timeOnlyFormatter stringFromDate:[self.parent.calendar dateFromComponents:self.date]];
    return [NSString localizedStringWithFormat:NSLocalizedString(@"peak winds %ld° at %ld knots (%@)", @"remark"),
            wind.direction, wind.speed, dateString];
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

@end
