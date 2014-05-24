#import "ThunderstormLocationRemark.h"

// TS SE MOV NE
static NSString *ThunderstormLocationRegex = @"\\bTS " REMARK_DIRECTIONS_REGEX @"(?: MOV " REMARK_DIRECTION_REGEX ")?\\b\\s*";

@implementation ThunderstormLocationRemark

@synthesize directions;
@synthesize movingDirection;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:ThunderstormLocationRegex];
        if (!match) return (self = nil);
        
        self.directions = [self parseDirectionsFromMatch:match index:1 inString:remarks];
        
        if ([match rangeAtIndex:4].location != NSNotFound) {
            NSString *codedTrend = [remarks substringWithRange:[match rangeAtIndex:4]];
            self.movingDirection = [self decodeDirection:codedTrend];
        }
        else self.movingDirection = DirectionNone;
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyUrgent;
}

- (NSString *) stringValue {
    if (self.movingDirection == DirectionNone)
        return [NSString localizedStringWithFormat:NSLocalizedString(@"thunderstorms %@", @"direction"),
                [self localizedDirections:self.directions]];
    else
        return [NSString localizedStringWithFormat:NSLocalizedString(@"thunderstorms %@ moving %@", @"direction, movement direction"),
                [self localizedDirections:self.directions],
                [self localizedDirection:self.movingDirection]];
}

@end
