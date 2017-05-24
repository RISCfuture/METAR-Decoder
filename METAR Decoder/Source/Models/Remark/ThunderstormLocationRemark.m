#import "ThunderstormLocationRemark.h"

// TS SE MOV NE
// TS OHD MOV N
// TS MOV N
static NSString *ThunderstormLocationRegex = @"\\bTS(?: " REMARK_PROXIMITY_REGEX ")?(?: " REMARK_DIRECTIONS_REGEX @")?(?: MOV " REMARK_DIRECTION_REGEX ")?\\b\\s*";

@implementation ThunderstormLocationRemark

@synthesize proximity;
@synthesize directions;
@synthesize movingDirection;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:ThunderstormLocationRegex];
        if (!match) return (self = nil);

        if ([match rangeAtIndex:1].location != NSNotFound)
            self.proximity = [self decodeProximity:[remarks substringWithRange:[match rangeAtIndex:1]]];
        else self.proximity = ProximityUnknown;

        if ([match rangeAtIndex:2].location != NSNotFound)
            self.directions = [self parseDirectionsFromMatch:match index:2 inString:remarks];
        else self.directions = 0;
        
        if ([match rangeAtIndex:5].location != NSNotFound) {
            NSString *codedTrend = [remarks substringWithRange:[match rangeAtIndex:5]];
            self.movingDirection = [self decodeDirection:codedTrend];
        }
        else self.movingDirection = DirectionNone;

        if (self.proximity == ProximityUnknown && self.directions == 0 && self.movingDirection == DirectionNone)
            return (self = nil);
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyUrgent;
}


- (NSString *) stringValue {
    if (self.directions) {
        if (self.proximity != ProximityUnknown) {
            if (self.movingDirection == DirectionNone) {
                return [NSString localizedStringWithFormat:NSLocalizedString(@"thunderstorms %@ %@", @"proximity, direction"),
                        [self localizedProximity:self.proximity],
                        [self localizedDirections:self.directions]];
            } else {
                return [NSString localizedStringWithFormat:NSLocalizedString(@"thunderstorms %@ %@ moving %@", @"proximity, direction, movement direction"),
                        [self localizedProximity:self.proximity],
                        [self localizedDirections:self.directions],
                        [self localizedDirection:self.movingDirection]];
            }
        } else {
            if (self.movingDirection == DirectionNone) {
                return [NSString localizedStringWithFormat:NSLocalizedString(@"thunderstorms %@", @"direction"),
                        [self localizedDirections:self.directions]];
            } else {
                return [NSString localizedStringWithFormat:NSLocalizedString(@"thunderstorms %@ moving %@", @"direction, movement direction"),
                        [self localizedDirections:self.directions],
                        [self localizedDirection:self.movingDirection]];
            }
        }
    } else {
        if (self.proximity != ProximityUnknown) {
            if (self.movingDirection == DirectionNone) {
                return [NSString localizedStringWithFormat:NSLocalizedString(@"thunderstorms %@ ", @"proximity"),
                        [self localizedProximity:self.proximity]];
            } else {
                return [NSString localizedStringWithFormat:NSLocalizedString(@"thunderstorms %@ moving %@", @"proximity, movement direction"),
                        [self localizedProximity:self.proximity],
                        [self localizedDirection:self.movingDirection]];
            }
        } else {
            if (self.movingDirection == DirectionNone) {
                return nil; // impossible case
            } else {
                return [NSString localizedStringWithFormat:NSLocalizedString(@"thunderstorms moving %@", @"movement direction"),
                        [self localizedDirection:self.movingDirection]];
            }
        }
    }


}

@end
