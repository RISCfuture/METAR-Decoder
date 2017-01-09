#define METAR_WIND_REGEX @"(\\d{3})(\\d{2,3})"
#define METAR_WHOLE_VIS_REGEX @"(\\d+)"
#define METAR_FRACTIONAL_VIS_REGEX @"(\\d+)/(\\d+)"
#define METAR_IRRATIONAL_VIS_REGEX @"(\\d+) (\\d+)/(\\d+)"
#define METAR_VISIBILITY_REGEX @"(?:" METAR_IRRATIONAL_VIS_REGEX "|" METAR_FRACTIONAL_VIS_REGEX "|" METAR_WHOLE_VIS_REGEX ")"

@interface METAR (Decoding)

- (Wind) parseWindFromMatch:(NSTextCheckingResult *)match index:(NSUInteger)index inString:(NSString *)string;
- (ImproperFraction *) parseVisibilityFromMatch:(NSTextCheckingResult *)match index:(NSUInteger)index inString:(NSString *)string;
- (NSDateComponents *) parseDateFromMatch:(NSTextCheckingResult *)match index:(NSUInteger)index inString:(NSString *)string;

- (NSDateComponents *) decodeDate:(NSString *)METARString;
- (PrecipitationType) decodePrecipitationType:(NSString *)string;
- (PrecipitationDescriptor) decodePrecipitationDescriptor:(NSString *)string;
- (ObscurationType) decodeObscurationType:(NSString *)string;
- (CoverageAmount) decodeCoverage:(NSString *)string;

@end
