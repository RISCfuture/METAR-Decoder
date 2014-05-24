#import "Remark+Decoding.h"

@implementation Remark (Decoding)

- (DirectionMask) parseDirectionsFromMatch:(NSTextCheckingResult *)match index:(NSUInteger)index inString:(NSString *)string {
    DirectionMask directions = 0;
    
    NSString *direction1String = [string substringWithRange:[match rangeAtIndex:index]];
    RemarkDirection direction1 = [self decodeDirection:direction1String];
    directions |= DirectionToMask(direction1);
    
    if ([match rangeAtIndex:index+1].location != NSNotFound) {
        NSString *spanString = [string substringWithRange:[match rangeAtIndex:index+1]];
        NSString *direction2String = [string substringWithRange:[match rangeAtIndex:index+2]];
        RemarkDirection direction2 = [self decodeDirection:direction2String];
        
        if ([spanString isEqualToString:@" AND "])
            directions |= DirectionToMask(direction2);
        else if (direction1 >= 0 && direction2 >= 0) {
            RemarkDirection interpolatedDirection = direction1;
            while (interpolatedDirection != direction2) {
                directions |= DirectionToMask(interpolatedDirection);
                interpolatedDirection += 45;
                interpolatedDirection %= 360;
            }
            directions |= DirectionToMask(direction2);
        }
    }
    
    return directions;
}

- (RemarkDirection) decodeDirection:(NSString *)direction {
    if ([direction isEqualToString:@"N"]) return DirectionNorth;
    else if ([direction isEqualToString:@"NE"]) return DirectionNortheast;
    else if ([direction isEqualToString:@"E"]) return DirectionEast;
    else if ([direction isEqualToString:@"SE"]) return DirectionSoutheast;
    else if ([direction isEqualToString:@"S"]) return DirectionSouth;
    else if ([direction isEqualToString:@"SW"]) return DirectionSouthwest;
    else if ([direction isEqualToString:@"W"]) return DirectionWest;
    else if ([direction isEqualToString:@"NW"]) return DirectionNorthwest;
    else if ([direction isEqualToString:@"ALQS"]) return DirectionAll;
    else if ([direction isEqualToString:@"ALQDS"]) return DirectionAll;
    else
        [[NSException exceptionWithName:@"METARException" reason:@"Unknown direction" userInfo:nil] raise];
    return DirectionNone;
}

- (RemarkFrequency) decodeFrequency:(NSString *)frequency {
    if ([frequency isEqualToString:@"OCNL"]) return FrequencyOccasional;
    else if ([frequency isEqualToString:@"FRQ"]) return FrequencyFrequent;
    else if ([frequency isEqualToString:@"CONS"]) return FrequencyConstant;
    else
        [[NSException exceptionWithName:@"METARException" reason:@"Unknown frequency" userInfo:nil] raise];
    return FrequencyUnknown;
}

- (RemarkProximity) decodeProximity:(NSString *)proximity {
    if ([proximity isEqualToString:@"OHD"]) return ProximityOverhead;
    else if ([proximity isEqualToString:@"VC"]) return ProximityVicinity;
    else if ([proximity isEqualToString:@"DSNT"]) return ProximityDistant;
    else
        [[NSException exceptionWithName:@"METARException" reason:@"Unknown proximity" userInfo:nil] raise];
    return ProximityUnknown;
}

@end

int DirectionToMask(RemarkDirection direction) {
    switch (direction) {
        case DirectionAll: return (1 << 8) - 1;
        case DirectionEast: return DirectionMaskEast;
        case DirectionNone: return 0;
        case DirectionNorth: return DirectionMaskNorth;
        case DirectionNortheast: return DirectionMaskNortheast;
        case DirectionNorthwest: return DirectionMaskNorthwest;
        case DirectionSouth: return DirectionMaskSouth;
        case DirectionSoutheast: return DirectionMaskSoutheast;
        case DirectionSouthwest: return DirectionMaskSouthwest;
        case DirectionWest: return DirectionMaskWest;
    }
}
