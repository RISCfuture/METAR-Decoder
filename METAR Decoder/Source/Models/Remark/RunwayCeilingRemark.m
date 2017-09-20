#import "RunwayCeilingRemark.h"

// CIG 002 RWY11
static NSString *RunwayCeilingRegex = @"\\bCIG (\\d{3}) RWY(\\d{1,2})\\b\\s*";

@implementation RunwayCeilingRemark

@synthesize runwayName;
@synthesize height;

+ (void) load {
    [Remark registerSubclass:self];
}

- (instancetype) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:RunwayCeilingRegex];
        if (!match) return (self = nil);
        
        NSString *codedHeight = [remarks substringWithRange:[match rangeAtIndex:1]];
        self.height = codedHeight.integerValue*100;
        
        self.runwayName = [remarks substringWithRange:[match rangeAtIndex:2]];
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.RunwayCeiling", @"{runway}, {ceiling}"),
            self.runwayName,
            self.height];
}

@end
