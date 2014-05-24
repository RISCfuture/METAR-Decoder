#import "LightningRemark.h"

// OCNL LTGICCG OHD
// FRQ LTG VC
// LTG DSNT W
static NSString *LightningRegex = @"\\b(?:" REMARK_FREQUENCY_REGEX @" )?LTG((?:CG|IC|CC|CA)*)(?: " REMARK_PROXIMITY_REGEX @")?(?: " REMARK_DIRECTIONS_REGEX @")?\\b\\s*";

@implementation LightningRemark

@synthesize directions;
@synthesize frequency;
@synthesize types;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSMutableSet *newTypes = [NSMutableSet new];
        
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:LightningRegex];
        if (!match) return (self = nil);
        
        if ([match rangeAtIndex:1].location != NSNotFound)
            self.frequency = [self decodeFrequency:[remarks substringWithRange:[match rangeAtIndex:1]]];
        else self.frequency = FrequencyUnknown;
        
        if ([match rangeAtIndex:2].location != NSNotFound) {
            NSString *codedTypeString = [remarks substringWithRange:[match rangeAtIndex:2]];
            NSArray *codedTypes = [codedTypeString componentsPartitionedByLength:2];
            if ([codedTypes containsObject:@"CG"])
                [newTypes addObject:[NSNumber numberWithInt:LightningCloudToGround]];
            if ([codedTypes containsObject:@"IC"])
                [newTypes addObject:[NSNumber numberWithInt:LightningWithinCloud]];
            if ([codedTypes containsObject:@"CC"])
                [newTypes addObject:[NSNumber numberWithInt:LightningCloudToCloud]];
            if ([codedTypes containsObject:@"CA"])
                [newTypes addObject:[NSNumber numberWithInt:LightningCloudToAir]];
        }
        self.types = newTypes;
        
        if ([match rangeAtIndex:3].location != NSNotFound)
            self.proximity = [self decodeProximity:[remarks substringWithRange:[match rangeAtIndex:3]]];
        else self.proximity = ProximityUnknown;
        
        if ([match rangeAtIndex:4].location != NSNotFound)
            self.directions = [self parseDirectionsFromMatch:match index:4 inString:remarks];
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (NSString *) stringValue {
    NSString *lightningString;
    if (self.frequency == FrequencyUnknown)
        lightningString = NSLocalizedString(@"lightning", @"lightning remark: frequency unknown");
    else
        lightningString = [NSString localizedStringWithFormat:NSLocalizedString(@"%@ lightning", @"lightning remark: frequency known"),
                           [self localizedFrequency:self.frequency]];
    
    NSString *typesString;
    if (self.types.count > 0)
        typesString = [[[self.types map:^(id typeNumber) {
            return [self localizedType:[(NSNumber *)typeNumber intValue]];
        }] allObjects] componentsJoinedByString:NSLocalizedString(@", ", @"list separator")];
    else typesString = nil;
    
    NSString *directionString;
    if (self.directions)
        directionString = [self localizedDirections:self.directions];
    
    NSString *proximityString;
    if (self.proximity == ProximityUnknown)
        proximityString = nil;
    else
        proximityString = [self localizedProximity:self.proximity];
    
    if (typesString && directionString && proximityString)
        return [NSString localizedStringWithFormat:NSLocalizedString(@"%@ (%@) %@ %@", @"remark: lightning frequency, type, proximity, direction"),
                lightningString,
                typesString,
                proximityString,
                directionString];
    else if (typesString && directionString)
        return [NSString localizedStringWithFormat:NSLocalizedString(@"%@ (%@) %@", @"remark: lightning frequency, type, direction"),
                lightningString,
                typesString,
                directionString];
    else if (typesString && proximityString)
        return [NSString localizedStringWithFormat:NSLocalizedString(@"%@ (%@) %@", @"remark: lightning frequency, type, proximity"),
                lightningString,
                typesString,
                proximityString];
    else if (directionString && proximityString)
        return [NSString localizedStringWithFormat:NSLocalizedString(@"%@ %@ %@", @"remark: lightning frequency, proximity, direction"),
                lightningString,
                proximityString,
                directionString];
    else if (typesString)
        return [NSString localizedStringWithFormat:NSLocalizedString(@"%@ (%@)", @"remark: lightning frequency, type"),
                lightningString,
                typesString];
    else if (directionString)
        return [NSString localizedStringWithFormat:NSLocalizedString(@"%@ %@", @"remark: lightning frequency, direction"),
                lightningString,
                directionString];
    else if (proximityString)
        return [NSString localizedStringWithFormat:NSLocalizedString(@"%@ %@", @"remark: lightning frequency, proximity"),
                lightningString,
                directionString];
    else
        return lightningString;
}

- (RemarkUrgency) urgency {
    return UrgencyUrgent;
}

- (NSString *) localizedType:(LightningType)type {
    switch (type) {
        case LightningCloudToAir:
            return NSLocalizedString(@"cloud-to-air", @"lightning type");
        case LightningCloudToCloud:
            return NSLocalizedString(@"cloud-to-cloud", @"lightning type");
        case LightningCloudToGround:
            return NSLocalizedString(@"cloud-to-ground", @"lightning type");
        case LightningWithinCloud:
            return NSLocalizedString(@"in-cloud", @"lightning type");
    }
}

@end
