#import "METARDecoder.h"

@interface METARDecoder (Network)

- (NSString *) codedMETARForAirport:(NSString *)airportCode;

@end

@implementation METARDecoder

- (METAR *) loadMETARForAirport:(NSString *)airportCode {
    NSString *codedMETAR = [self codedMETARForAirport:airportCode];
    if (codedMETAR.length == 0) return nil;
    return [self parseMETAR:codedMETAR];
}

- (METAR *) parseMETAR:(NSString *)METARString {
    METAR *airportMETAR = [[METAR alloc] initWithString:METARString];

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
        [[NSException exceptionWithName:@"METARException" reason:error.localizedDescription userInfo:nil] raise];

    NSArray *lines = [response componentsSeparatedByString:@"\n"];
    NSString *METARLine = lines[6];
    NSArray *elements = [METARLine componentsSeparatedByString:@","];
    return elements[0];
}

@end
