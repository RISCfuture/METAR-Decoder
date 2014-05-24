#import "Remark+Localization.h"

@implementation Remark (Localization)

- (NSString *) localizedDirection:(RemarkDirection)direction {
    switch (direction) {
        case DirectionNorth: return NSLocalizedString(@"north", @"direction");
        case DirectionNortheast: return NSLocalizedString(@"northeast", @"direction");
        case DirectionEast: return NSLocalizedString(@"east", @"direction");
        case DirectionSoutheast: return NSLocalizedString(@"southeast", @"direction");
        case DirectionSouth: return NSLocalizedString(@"south", @"direction");
        case DirectionSouthwest: return NSLocalizedString(@"southwest", @"direction");
        case DirectionWest: return NSLocalizedString(@"west", @"direction");
        case DirectionNorthwest: return NSLocalizedString(@"northwest", @"direction");
        case DirectionAll: return NSLocalizedString(@"all quadrants", @"direction");
        default:
            [[NSException exceptionWithName:@"METARException" reason:@"Unknown direction" userInfo:nil] raise];
    }
    
    return nil;
}

- (NSString *) localizedFrequency:(RemarkFrequency)frequency {
    switch (frequency) {
        case FrequencyOccasional: return NSLocalizedString(@"occasional", @"frequency");
        case FrequencyFrequent: return NSLocalizedString(@"frequent", @"frequency");
        case FrequencyConstant: return NSLocalizedString(@"constant", @"frequency");
        default:
            [[NSException exceptionWithName:@"METARException" reason:@"Unknown frequency" userInfo:nil] raise];
    }
    return nil;
}

- (NSString *) localizedProximity:(RemarkProximity)proximity {
    switch (proximity) {
        case ProximityOverhead: return NSLocalizedString(@"overhead", @"proximity");
        case ProximityVicinity: return NSLocalizedString(@"in the vicinity", @"proximity");
        case ProximityDistant: return NSLocalizedString(@"distant", @"proximity");
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
            return NSLocalizedString(@"all directions", @"range of directions");
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
                [directionStrings addObject:[NSString localizedStringWithFormat:NSLocalizedString(@"%@ through %@", @"direction range (e.g. north through west)"),
                                             [self localizedDirection:start],
                                             [self localizedDirection:stop]]];
                break;
            }
        }
    }
    
    if (directionStrings.count == 0) return nil;
    return [directionStrings componentsJoinedByString:NSLocalizedString(@" and ", @"direction list (e.g. north and west)")];
}

@end
