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

- (instancetype) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
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
                [newTypes addObject:@(LightningCloudToGround)];
            if ([codedTypes containsObject:@"IC"])
                [newTypes addObject:@(LightningWithinCloud)];
            if ([codedTypes containsObject:@"CC"])
                [newTypes addObject:@(LightningCloudToCloud)];
            if ([codedTypes containsObject:@"CA"])
                [newTypes addObject:@(LightningCloudToAir)];
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
        lightningString = MDLocalizedString(@"METAR.Remark.Lightning.Description.NoFrequency", nil);
    else
        lightningString = [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.Lightning.Description.WithFrequency", nil),
                           [self localizedFrequency:self.frequency]];
    
    NSString *typesString;
    if (self.types.count > 0)
        typesString = [[self.types map:^(id typeNumber) {
            return [self localizedType:((NSNumber *)typeNumber).intValue];
        }].allObjects componentsJoinedByString:MDLocalizedString(@"Common.ListSeparator", nil)];
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
        return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.Lightning.TypeProximityDirection", @"{description}, {type}, {proximity}, {direction}"),
                lightningString,
                typesString,
                proximityString,
                directionString];
    else if (typesString && directionString)
        return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.Lightning.TypeDirection", @"{description}, {type}, {direction}"),
                lightningString,
                typesString,
                directionString];
    else if (typesString && proximityString)
        return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.Lightning.TypeProximity", @"{description}, {type}, {proximity}"),
                lightningString,
                typesString,
                proximityString];
    else if (directionString && proximityString)
        return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.Lightning.ProximityDirection", @"{description}, {proximity}, {direction}"),
                lightningString,
                proximityString,
                directionString];
    else if (typesString)
        return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.Lightning.Type", @"{description}, {type}"),
                lightningString,
                typesString];
    else if (directionString)
        return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.Lightning.Direction", @"{description}, {direction}"),
                lightningString,
                directionString];
    else if (proximityString)
        return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.Lightning.Proximity", @"{description}, {proximity}"),
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
            return MDLocalizedString(@"METAR.Remark.Lightning.Type.CA", nil);
        case LightningCloudToCloud:
            return MDLocalizedString(@"METAR.Remark.Lightning.Type.CC", nil);
        case LightningCloudToGround:
            return MDLocalizedString(@"METAR.Remark.Lightning.Type.CG", nil);
        case LightningWithinCloud:
            return MDLocalizedString(@"METAR.Remark.Lightning.Type.IC", nil);
    }
}

@end
