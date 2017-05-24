#import "METAR+Decoding.h"

@implementation METAR (Decoding)

- (NSDateComponents *) decodeDate:(NSString *)dateString {
    NSTimeZone *timezone;
    NSString *timezoneCode = [dateString substringWithRange:NSMakeRange(6, 1)];
    if ([timezoneCode isEqualToString:@"Z"])
        timezone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    else
        [[NSException exceptionWithName:@"METARException" reason:@"Unknown timezone code" userInfo:nil] raise];
    
    NSDateComponents *date = [self.calendar componentsInTimeZone:timezone fromDate:[NSDate date]];
    
    date.day = [[dateString substringWithRange:NSMakeRange(0, 2)] integerValue];
    date.hour = [[dateString substringWithRange:NSMakeRange(2, 2)] integerValue];
    date.minute = [[dateString substringWithRange:NSMakeRange(4, 2)] integerValue];
    date.second = date.nanosecond = 0;
    
    return date;
}

- (PrecipitationType) decodePrecipitationType:(NSString *)string {
    if ([string isEqualToString:@"DZ"]) return PrecipitationDrizzle;
    else if ([string isEqualToString:@"RA"]) return PrecipitationRain;
    else if ([string isEqualToString:@"SN"]) return PrecipitationSnow;
    else if ([string isEqualToString:@"SG"]) return PrecipitationSnowGrains;
    else if ([string isEqualToString:@"IC"]) return PrecipitationIceCrystals;
    else if ([string isEqualToString:@"PL"]) return PrecipitationIcePellets;
    else if ([string isEqualToString:@"GR"]) return PrecipitationHail;
    else if ([string isEqualToString:@"GS"]) return PrecipitationSmallHail;
    else if ([string isEqualToString:@"UP"]) return PrecipitationUnknown;
    else {
        [[NSException exceptionWithName:@"METARException" reason:@"Unknown precipitation type" userInfo:nil] raise];
        return PrecipitationUnspecified;
    }
}

- (PrecipitationDescriptor) decodePrecipitationDescriptor:(NSString *)string {
    if ([string isEqualToString:@"MI"]) return DescriptorShallow;
    else if ([string isEqualToString:@"PR"]) return DescriptorPartial;
    else if ([string isEqualToString:@"BC"]) return DescriptorPatches;
    else if ([string isEqualToString:@"DR"]) return DescriptorLowDrifting;
    else if ([string isEqualToString:@"BL"]) return DescriptorBlowing;
    else if ([string isEqualToString:@"SH"]) return DescriptorShower;
    else if ([string isEqualToString:@"TS"]) return DescriptorThunderstorm;
    else if ([string isEqualToString:@"FZ"]) return DescriptorFreezing;
    else {
        [[NSException exceptionWithName:@"METARException" reason:@"Unknown precipitation descriptor" userInfo:nil] raise];
        return DescriptorUnspecified;
    }
}

- (ObscurationType) decodeObscurationType:(NSString *)string {
    if ([string isEqualToString:@"BR"]) return ObscurationMist;
    else if ([string isEqualToString:@"FG"]) return ObscurationFog;
    else if ([string isEqualToString:@"FU"]) return ObscurationSmoke;
    else if ([string isEqualToString:@"VA"]) return ObscurationVolcanicAsh;
    else if ([string isEqualToString:@"DU"]) return ObscurationWidespreadDust;
    else if ([string isEqualToString:@"SA"]) return ObscurationSand;
    else if ([string isEqualToString:@"HZ"]) return ObscurationHaze;
    else if ([string isEqualToString:@"PY"]) return ObscurationSpray;
    else {
        [[NSException exceptionWithName:@"METARException" reason:@"Unknown obscuration type" userInfo:nil] raise];
        return -1;
    }
}

- (CoverageAmount) decodeCoverage:(NSString *)string {
    if ([string isEqualToString:@"FEW"]) return CoverageFew;
    else if ([string isEqualToString:@"SCT"]) return CoverageScattered;
    else if ([string isEqualToString:@"BKN"]) return CoverageBroken;
    else if ([string isEqualToString:@"OVC"]) return CoverageOvercast;
    else {
        [[NSException exceptionWithName:@"METARException" reason:@"Unknown coverage amount" userInfo:nil] raise];
        return CoverageUnspecified;
    }
}

- (ImproperFraction *) parseVisibilityFromMatch:(NSTextCheckingResult *)match index:(NSUInteger)index inString:(NSString *)string {
    NSInteger whole;
    Rational *fraction;

    if ([match rangeAtIndex:index].location != NSNotFound) {
        whole = [[string substringWithRange:[match rangeAtIndex:index]] integerValue];
    }
    else if ([match rangeAtIndex:index+5].location != NSNotFound) {
        whole = [[string substringWithRange:[match rangeAtIndex:index+5]] integerValue];
    }
    else {
        whole = 0;
    }

    if ([match rangeAtIndex:index+1].location == NSNotFound) {
        fraction = NULL;
    }
    else {
        fraction = [[Rational alloc] initWith:[[string substringWithRange:[match rangeAtIndex:index+1]] integerValue]
                                                   over:[[string substringWithRange:[match rangeAtIndex:index+2]] integerValue]];
    }
    return [[ImproperFraction alloc] initWithWhole:whole fraction:fraction];
}

- (Wind) parseWindFromMatch:(NSTextCheckingResult *)match index:(NSUInteger)index inString:(NSString *)string {
    Wind wind;
    wind.direction = [[string substringWithRange:[match rangeAtIndex:index]] integerValue];
    wind.speed = [[string substringWithRange:[match rangeAtIndex:index+1]] integerValue];
    return wind;
}

- (NSDateComponents *) parseDateFromMatch:(NSTextCheckingResult *)match index:(NSUInteger)index inString:(NSString *)string {
    NSString *hoursString = nil;
    if ([match rangeAtIndex:index].location != NSNotFound)
        hoursString = [string substringWithRange:[match rangeAtIndex:index]];
    NSString *minutesString = [string substringWithRange:[match rangeAtIndex:index+1]];
    if (hoursString) return [self dateWithHours:[hoursString integerValue] minutes:[minutesString integerValue]];
    else return [self dateWithMinutes:[minutesString integerValue]];
}

@end
