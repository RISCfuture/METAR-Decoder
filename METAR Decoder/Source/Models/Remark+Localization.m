#import "Remark+Localization.h"

@implementation Remark (Localization)

- (NSString *) localizedDirection:(RemarkDirection)direction {
    switch (direction) {
        case DirectionNorth: return MDLocalizedString(@"METAR.Remark.Common.Direction.N", nil);
        case DirectionNortheast: return MDLocalizedString(@"METAR.Remark.Common.Direction.NE", @"direction");
        case DirectionEast: return MDLocalizedString(@"METAR.Remark.Common.Direction.E", nil);
        case DirectionSoutheast: return MDLocalizedString(@"METAR.Remark.Common.Direction.SE", @"direction");
        case DirectionSouth: return MDLocalizedString(@"METAR.Remark.Common.Direction.S", nil);
        case DirectionSouthwest: return MDLocalizedString(@"METAR.Remark.Common.Direction.SW", @"direction");
        case DirectionWest: return MDLocalizedString(@"METAR.Remark.Common.Direction.W", nil);
        case DirectionNorthwest: return MDLocalizedString(@"METAR.Remark.Common.Direction.NW", @"direction");
        case DirectionAll: return MDLocalizedString(@"METAR.Remark.Common.Direction.ALQDS", nil);
        default:
            [[NSException exceptionWithName:@"METARException" reason:@"Unknown direction" userInfo:nil] raise];
    }
    
    return nil;
}

- (NSString *) localizedFrequency:(RemarkFrequency)frequency {
    switch (frequency) {
        case FrequencyOccasional: return MDLocalizedString(@"METAR.Remark.Common.Frequency.OCSNL", nil);
        case FrequencyFrequent: return MDLocalizedString(@"METAR.Remark.Common.Frequency.FRQ", nil);
        case FrequencyConstant: return MDLocalizedString(@"METAR.Remark.Common.Frequency.CSNT", nil);
        default:
            [[NSException exceptionWithName:@"METARException" reason:@"Unknown frequency" userInfo:nil] raise];
    }
    return nil;
}

- (NSString *) localizedProximity:(RemarkProximity)proximity {
    switch (proximity) {
        case ProximityOverhead: return MDLocalizedString(@"METAR.Remark.Common.Proximity.OHD", nil);
        case ProximityVicinity: return MDLocalizedString(@"METAR.Remark.Common.Proximity.INVC", nil);
        case ProximityDistant: return MDLocalizedString(@"METAR.Remark.Common.Proximity.DSNT", nil);
        default:
            [[NSException exceptionWithName:@"METARException" reason:@"Unknown proximity" userInfo:nil] raise];
    }
    return nil;
}

- (NSString *) localizedDirections:(DirectionMask)directions {
    NSRange ranges[8];
    for (int i=0; i!=8; i++) ranges[i] = NSMakeRange(NSNotFound, 0);
    
    // find an unset bit to start our iteration from
    int firstUnsetDirection = 0;
    while (directions & DirectionToMask(firstUnsetDirection)) {
        firstUnsetDirection += 45;
        firstUnsetDirection %= 360;
        if (firstUnsetDirection == 0) {
            // they're all set
            return MDLocalizedString(@"METAR.Remark.Common.Direction.All", @"range of directions");
        }
    }
    
    // now advance forward until we find a set direction to start our first range
    int direction = firstUnsetDirection;
    int rangeIndex = 0;
    do {
        if (ranges[rangeIndex].location == NSNotFound) {
            // not currently in a range, advance forward until we find the start
            // of the range
            if (directions & DirectionToMask(direction))
                ranges[rangeIndex].location = direction;
        } else {
            // currently in a range, advance forward until we find the end of
            // the range
            if (directions & DirectionToMask(direction))
                ranges[rangeIndex].length += 45;
            else
                rangeIndex++;
        }
        
        direction += 45;
        direction %= 360;
    } while (direction != firstUnsetDirection);
    
    // now we've got a set of rangeIndex ranges to convert into strings
    // some ranges will have size 1 or 2, they are formatted differently
    NSMutableArray *directionStrings = [[NSMutableArray alloc] initWithCapacity:rangeIndex];
    
    for (rangeIndex=0; rangeIndex!=8; rangeIndex++) {
        if (ranges[rangeIndex].location == NSNotFound) break;
        switch (ranges[rangeIndex].length) {
            case 0:
                [directionStrings addObject:[self localizedDirection:(RemarkDirection)ranges[rangeIndex].location]];
                break;
            case 45:
                [directionStrings addObject:[self localizedDirection:(RemarkDirection)ranges[rangeIndex].location]];
                [directionStrings addObject:[self localizedDirection:(RemarkDirection)((ranges[rangeIndex].location + ranges[rangeIndex].length) % 360)]];
                break;
            default: {
                RemarkDirection start = (RemarkDirection)ranges[rangeIndex].location;
                RemarkDirection stop = (RemarkDirection)(ranges[rangeIndex].location + ranges[rangeIndex].length) % 360;
                [directionStrings addObject:[NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.Common.DirectionRange.Thru", @"{direction}, {direction}"),
                                             [self localizedDirection:start],
                                             [self localizedDirection:stop]]];
                break;
            }
        }
    }
    
    if (directionStrings.count == 0) return nil;
    return [directionStrings componentsJoinedByString:MDLocalizedString(@"Common.PairSeparator", nil)];
}

@end
