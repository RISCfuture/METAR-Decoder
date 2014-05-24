#import "ThunderstormBeginEndRemark.h"

// TSB0159E30
static NSString *ThunderstormBeginEndRegex = @"\\bTSB" REMARK_TIME_REGEX @"E" REMARK_TIME_REGEX @"\\b\\s*";

@implementation ThunderstormBeginEndRemark

@synthesize begin;
@synthesize end;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:ThunderstormBeginEndRegex];
        if (!match) return (self = nil);
        
        self.begin = [self.parent parseDateFromMatch:match index:1 inString:remarks];
        self.end = [self.parent parseDateFromMatch:match index:3 inString:remarks];
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyCaution;
}

- (NSString *) stringValue {
    return [NSString localizedStringWithFormat:NSLocalizedString(@"thunderstorm began at %@ and ended at %@", @"remark"),
            [self.parent.timeOnlyFormatter stringFromDate:[self.parent.calendar dateFromComponents:self.begin]],
            [self.parent.timeOnlyFormatter stringFromDate:[self.parent.calendar dateFromComponents:self.end]]];
}

@end
