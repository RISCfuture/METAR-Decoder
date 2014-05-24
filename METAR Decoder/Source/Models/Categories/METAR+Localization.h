@interface METAR (Localization)

- (NSString *) localizedPrecipitationDescriptor:(PrecipitationDescriptor)descriptor;
- (NSString *) localizedPrecipitationType:(PrecipitationType)type;
- (NSString *) localizedCoverage:(CoverageAmount)coverage;
- (NSString *) localizedObscuration:(ObscurationType)obscuration;

@end
