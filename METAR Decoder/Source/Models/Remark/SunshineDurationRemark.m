#import "SunshineDurationRemark.h"

// 98096
static NSString *SunshineDurationRegex = @"\\b98(\\d{3})\\b\\s*";

@implementation SunshineDurationRemark

@synthesize duration;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:SunshineDurationRegex];
        if (!match) return (self = nil);
        
        NSString *codedDuration = [remarks substringWithRange:[match rangeAtIndex:1]];
        self.duration = [codedDuration integerValue];
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.SunshineDuration", @"{duration}"),
            self.duration];
}

@end
