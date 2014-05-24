#define CLOUD_TYPE_REGEX @"(CB|CBMAM|TCU|ACC|SCSL|CCSL|ACSL|ROTOR CLD)"

typedef enum _SignificantCloudType {
    SignificantTypeCumulonimbus = 0,
    SignificantTypeCumulonimbusMammatus,
    SignificantTypeToweringCumulus,
    SignificantTypeAltocumulusCastellanus,
    SignificantTypeStratocumulusStandingLenticular,
    SignificantTypeAltocumulusStandingLenticular,
    SignificantTypeCirrocumulusStandingLenticular,
    SignificantTypeRotor
} SignificantCloudType;

@interface SignificantCloudsRemark : Remark

@property (assign) SignificantCloudType type;
@property (assign) RemarkDirection direction1;
@property (assign) RemarkDirection direction2;
@property (assign) RemarkDirection movingDirection;
@property (assign) BOOL distant;
@property (assign) BOOL apparent;

- (SignificantCloudType) decodeCloudType:(NSString *)string;
- (NSString *) localizedCloudType:(SignificantCloudType)type;

@end
