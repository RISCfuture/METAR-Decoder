#import "Remark.h"

#define NOCAP_PRECIPITATION_DESCRIPTOR_REGEX @"MI|PR|BC|DR|BL|SH|TS|FZ"
#define NOCAP_PRECIPITATION_TYPE_REGEX @"DZ|RA|SN|SG|IC|PL|GR|GS|UP"
#define PRECIPITATION_DESCRIPTOR_REGEX @"(" NOCAP_PRECIPITATION_DESCRIPTOR_REGEX ")"
#define PRECIPITATION_TYPE_REGEX @"(" NOCAP_PRECIPITATION_TYPE_REGEX ")"
#define OBSCURATION_TYPE_REGEX @"(BR|FG|FU|VA|DU|SA|HZ|PY)"
#define COVERAGE_REGEX @"(FEW|SCT|BKN|OVC)"

#define REMARK_TIME_REGEX @"(\\d{2})?(\\d{2})"
#define NOCAP_REMARK_DIRECTION_REGEX @"N[EW]?|S[EW]?|E|W|ALQD?S"
#define REMARK_PROXIMITY_REGEX @"(OHD|VC|DSNT)"
#define REMARK_FREQUENCY_REGEX @"(OCNL|FRQ|CONS)"

#define REMARK_DIRECTION_REGEX @"(" NOCAP_REMARK_DIRECTION_REGEX @")"
#define REMARK_DIRECTIONS_REGEX @"(" NOCAP_REMARK_DIRECTION_REGEX @")(?:(-| THRU | AND )(" NOCAP_REMARK_DIRECTION_REGEX @"))*"

@interface Remark (Decoding)

- (DirectionMask) parseDirectionsFromMatch:(NSTextCheckingResult *)match index:(NSUInteger)index inString:(NSString *)string;

- (RemarkDirection) decodeDirection:(NSString *)direction;
- (RemarkFrequency) decodeFrequency:(NSString *)frequency;
- (RemarkProximity) decodeProximity:(NSString *)proximity;

@end

int DirectionToMask(RemarkDirection direction);
