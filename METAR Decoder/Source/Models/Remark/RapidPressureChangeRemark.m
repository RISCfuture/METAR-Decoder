#import "RapidPressureChangeRemark.h"

// PRESRR
// PRESFR
static NSString *RapidPressureChangeRegex = @"\\b(PRESRR|PRESFR)\\b\\s*";

@implementation RapidPressureChangeRemark

@synthesize rising;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:RapidPressureChangeRegex];
        if (!match) return (self = nil);
        
        NSString *codedRemark = [remarks substringWithRange:[match rangeAtIndex:1]];
        self.rising = [codedRemark isEqualToString:@"PRESRR"];
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyCaution;
}

- (NSString *) stringValue {
    if (self.rising)
        return NSLocalizedString(@"pressure rising rapidly", @"remark");
    else
        return NSLocalizedString(@"pressure falling rapidly", @"remark");
}

@end
