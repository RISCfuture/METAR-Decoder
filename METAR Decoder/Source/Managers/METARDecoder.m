#import "METARDecoder.h"

@interface METARDecoder (Network)

- (NSString *) codedMETARForAirport:(NSString *)airportCode;

@end

@interface METARDecoder (Decoding)

- (NSString *) remarksPortionOfMETAR:(NSString *)METAR;

@end

@implementation METARDecoder

- (METAR *) loadMETARForAirport:(NSString *)airportCode {
    NSString *codedMETAR = [self codedMETARForAirport:airportCode];
    if (codedMETAR.length == 0) return nil;
    return [self parseMETAR:codedMETAR];
}

- (METAR *) parseMETAR:(NSString *)METARString {
    METAR *airportMETAR = [METAR new];
    airportMETAR.date = [airportMETAR decodeDate:METARString];
    airportMETAR.remarks = [self remarksPortionOfMETAR:METARString];

    return airportMETAR;
}

@end

@implementation METARDecoder (Network)

- (NSString *) codedMETARForAirport:(NSString *)airportCode {
    NSString *URLString = [NSString stringWithFormat:@"https://aviationweather.gov/adds/dataserver_current/httpparam?dataSource=metars&requestType=retrieve&format=csv&stationString=%@&hoursBeforeNow=1", airportCode];
    NSURL *URL = [[NSURL alloc] initWithString:URLString];

    NSError *error;
    NSString *response = [NSString stringWithContentsOfURL:URL encoding:NSASCIIStringEncoding error:&error];
    if (error)
        [[NSException exceptionWithName:@"METARException" reason:[error localizedDescription] userInfo:nil] raise];

    NSArray *lines = [response componentsSeparatedByString:@"\n"];
    NSString *METARLine = lines[6];
    NSArray *elements = [METARLine componentsSeparatedByString:@","];
    return elements[0];
}

@end

@implementation METARDecoder (Decoding)

- (NSString *) remarksPortionOfMETAR:(NSString *)METAR {
    NSArray *elements = [METAR componentsSeparatedByString:@" "];
    NSUInteger RMKOffset = [elements indexOfObject:@"RMK"];
    if (RMKOffset == NSNotFound) return nil;

    return [[elements subarrayWithRange:NSMakeRange(RMKOffset+1, elements.count - RMKOffset - 1)] componentsJoinedByString:@" "];
}

@end

