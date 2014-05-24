#import "VirgaRemark.h"

// VIRGA SW
static NSString *VirgaRegex = @"\\bVIRGA(?: " REMARK_DIRECTIONS_REGEX ")?\\b\\s*";

@implementation VirgaRemark

@synthesize directions;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:VirgaRegex];
        if (!match) return (self = nil);
        
        if ([match rangeAtIndex:1].location != NSNotFound)
            self.directions = [self parseDirectionsFromMatch:match index:1 inString:remarks];
        else self.directions = DirectionNone;
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    if (self.directions)
        return [NSString localizedStringWithFormat:NSLocalizedString(@"virga observed %@", @"remark: direction"),
                [self localizedDirections:self.directions]];
    else
        return NSLocalizedString(@"virga observed", @"remark");
}

@end
