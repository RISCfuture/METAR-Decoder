#define METAR_WIND_REGEX @"(\\d{3})(\\d{2,3})"
#define METAR_VISIBILITY_REGEX @"(?:(\\d+) )?(?:(\\d+)/(\\d+))?"

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
