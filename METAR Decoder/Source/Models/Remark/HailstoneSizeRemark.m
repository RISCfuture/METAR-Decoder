#import "HailstoneSizeRemark.h"

// GR 1 3/4
static NSString *HailstoneSizeRegex = @"\\bGR " METAR_VISIBILITY_REGEX @"\\b\\s*";

@implementation HailstoneSizeRemark

@synthesize size;

+ (void) load {
    [Remark registerSubclass:self];
}

- (instancetype) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:HailstoneSizeRegex];
        if (!match) return (self = nil);
        
        self.size = [self.parent parseVisibilityFromMatch:match index:1 inString:remarks];
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyUrgent;
}

- (NSString *) stringValue {
    return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.HailstoneSize", @"{diameter}"),
            [self.size stringValue]];
}

@end
