#import "TornadicActivityRemark.h"

// TORNADO B13 6 NE MOV W
// WATERSPOUT E13 6 W
// FUNNEL CLOUD B1213 12 NW
static NSString *TornadicActivityRegex = @"\\b(TORNADO|FUNNEL CLOUD|WATERSPOUT) (B|E)" REMARK_TIME_REGEX @" (\\d+) " REMARK_DIRECTION_REGEX @"(?: MOV " REMARK_DIRECTION_REGEX @")?\\b\\s*";

@implementation TornadicActivityRemark

@synthesize type;
@synthesize beginTime;
@synthesize endTime;
@synthesize location;
@synthesize movingDirection;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:TornadicActivityRegex];
        if (!match) return (self = nil);
        
        NSString *codedType = [remarks substringWithRange:[match rangeAtIndex:1]];
        if ([codedType isEqualToString:@"TORNADO"]) self.type = TornadicTypeTorando;
        else if ([codedType isEqualToString:@"FUNNEL CLOUD"]) self.type = TornadicTypeFunnelCloud;
        else if ([codedType isEqualToString:@"WATERSPOUT"]) self.type = TornadicTypeWaterspout;
        else return (self = nil);
        
        NSString *codedDateType = [remarks substringWithRange:[match rangeAtIndex:2]];
        NSDateComponents *date = [self.parent parseDateFromMatch:match index:3 inString:remarks];
        if ([codedDateType isEqualToString:@"B"])
            self.beginTime = date;
        else if ([codedDateType isEqualToString:@"E"])
            self.endTime = date;
        else return (self = nil);
        
        RemarkLocation loc;
        loc.distance = [[remarks substringWithRange:[match rangeAtIndex:5]] integerValue];
        loc.direction = [self decodeDirection:[remarks substringWithRange:[match rangeAtIndex:6]]];
        self.location = loc;
        
        if ([match rangeAtIndex:7].location != NSNotFound)
            self.movingDirection = [self decodeDirection:[remarks substringWithRange:[match rangeAtIndex:7]]];
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyUrgent;
}

- (NSString *) stringValue {
    NSString *typeString;
    switch (self.type) {
        case TornadicTypeTorando:
            typeString = NSLocalizedString(@"tornado", @"tornadic type");
            break;
        case TornadicTypeFunnelCloud:
            typeString = NSLocalizedString(@"funnel cloud", @"tornadic type");
            break;
        case TornadicTypeWaterspout:
            typeString = NSLocalizedString(@"waterspout", @"tornadic type");
            break;
    }
    
    if (self.beginTime) {
        if (self.movingDirection != DirectionNone)
            return [NSString localizedStringWithFormat:NSLocalizedString(@"%@ began at %@, %ld SM %@ moving %@", @"tornadic remark: type, time, distance, direction, moving direction"),
                    typeString,
                    [self.parent.timeOnlyFormatter stringFromDate:[self.parent.calendar dateFromComponents:self.beginTime]],
                    self.location.distance,
                    [self localizedDirection:self.location.direction],
                    [self localizedDirection:self.movingDirection]];
        else
            return [NSString localizedStringWithFormat:NSLocalizedString(@"%@ began at %@, %ld SM %@", @"tornadic remark: type, time, distance, direction"),
                    typeString,
                    [self.parent.timeOnlyFormatter stringFromDate:[self.parent.calendar dateFromComponents:self.beginTime]],
                    self.location.distance,
                    [self localizedDirection:self.location.direction]];
    } else {
        if (self.movingDirection)
            return [NSString localizedStringWithFormat:NSLocalizedString(@"%@ ended at %@, %ld SM %@ moving %@", @"tornadic remark: type, time, distance, direction, moving direction"),
                    typeString,
                    [self.parent.timeOnlyFormatter stringFromDate:[self.parent.calendar dateFromComponents:self.beginTime]],
                    self.location.distance,
                    [self localizedDirection:self.location.direction],
                    [self localizedDirection:self.movingDirection]];
        else
            return [NSString localizedStringWithFormat:NSLocalizedString(@"%@ ended at %@, %ld SM %@", @"tornadic remark: type, time, distance, direction"),
                    typeString,
                    [self.parent.timeOnlyFormatter stringFromDate:[self.parent.calendar dateFromComponents:self.beginTime]],
                    self.location.distance,
                    [self localizedDirection:self.location.direction]];
    }
}

@end
