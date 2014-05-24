typedef enum _LowCloudType {
    LowObscured = -1,
    LowNone = 0,
    LowCuHum = 1,
    LowCuMedOrCon = 2,
    LowCbCal = 3,
    LowScCugen = 4,
    LowSc = 5,
    LowStNeb = 6,
    LowStFra = 7,
    LowCuPlusSc = 8,
    LowCbCap = 9
} LowCloudType;

typedef enum _MiddleCloudType {
    MiddleObscured = -1,
    MiddleNone = 0,
    MiddleAsTr = 1,
    MiddleAsOp = 2,
    MiddleAcPe = 3,
    MiddleAcLen = 4,
    MiddleAc = 5,
    MiddleAcCugen = 6,
    MiddleAcPlusAcAs = 7,
    MiddleAcCasOrFlo = 8,
    MiddleAcChaoticSky = 9
} MiddleCloudType;

typedef enum _HighCloudType {
    HighObscured = -1,
    HighNone = 0,
    HighCiFib = 1,
    HighCiSpi = 2,
    HighCiInc = 3,
    HighCiUnc = 4,
    HighCsIncreasingLess45 = 5,
    HighCsIncreasingGreater45 = 6,
    HighCsTotalCover = 7,
    HighCsPartialCover = 8,
    HighCc = 9
} HighCloudType;

@interface CloudTypesRemark : Remark

@property (assign) LowCloudType low;
@property (assign) MiddleCloudType middle;
@property (assign) HighCloudType high;

- (NSString *) localizedLowCloudType:(LowCloudType)type;
- (NSString *) localizedMiddleCloudType:(MiddleCloudType)type;
- (NSString *) localizedHighCloudType:(HighCloudType)type;

@end
