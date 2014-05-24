#import "VariableCeilingHeightRemark.h"

// CIG 005V010
static NSString *VariableCeilingHeightRegex = @"\\bCIG (\\d{3})V(\\d{3})\\b\\s*";

@implementation VariableCeilingHeightRemark

@synthesize low;
@synthesize high;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:VariableCeilingHeightRegex];
        if (!match) return (self = nil);
        
        NSString *lowValue = [remarks substringWithRange:[match rangeAtIndex:1]];
        self.low = [lowValue integerValue]*100;
        
        NSString *highValue = [remarks substringWithRange:[match rangeAtIndex:2]];
        self.high = [highValue integerValue]*100;
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    return [NSString localizedStringWithFormat:NSLocalizedString(@"ceiling variable between %lu and %lu feet", @"low and high ceilings"),
            self.low, self.high];
}

@end
