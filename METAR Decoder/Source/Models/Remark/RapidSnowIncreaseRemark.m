#import "RapidSnowIncreaseRemark.h"

// SNINCR 2/10
static NSString *RapidSnowIncreaseRegex = @"\\bSNINCR (\\d+)\\/(\\d+)\\b\\s*";

@implementation RapidSnowIncreaseRemark

@synthesize depthIncrease;
@synthesize totalDepth;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:RapidSnowIncreaseRegex];
        if (!match) return (self = nil);
        
        NSString *codedDepthIncrease = [remarks substringWithRange:[match rangeAtIndex:1]];
        self.depthIncrease = [codedDepthIncrease integerValue];
        
        NSString *codedTotal = [remarks substringWithRange:[match rangeAtIndex:2]];
        self.totalDepth = [codedTotal integerValue];
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyCaution;
}

- (NSString *) stringValue {
    return [NSString localizedStringWithFormat:NSLocalizedString(@"rapid snow increase: %lu inches in the past hour (%lu inches total)", @"snow depths"),
            self.depthIncrease, self.totalDepth];
}

@end
