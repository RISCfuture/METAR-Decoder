#include "mach-o/dyld.h"

@interface METARDecoder : NSObject

- (METAR *) loadMETARForAirport:(NSString *)airportCode;
- (METAR *) parseMETAR:(NSString *)METARString;

@end
