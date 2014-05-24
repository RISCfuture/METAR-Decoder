typedef enum _SensorType {
    SensorRVR = 0,
    SensorPresentWeather,
    SensorRain,
    SensorFreezingRain,
    SensorLightning,
    SensorSecondaryVisibility,
    SensorSecondaryCeiling
} SensorType;

@interface SensorStatusRemark : Remark

@property (assign) SensorType type;
@property (strong) NSString *secondaryLocation;

- (SensorType) decodeSensorType:(NSString *)string;

@end
