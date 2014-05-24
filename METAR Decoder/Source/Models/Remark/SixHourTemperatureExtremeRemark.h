typedef enum _ExtremeType {
    ExtremeLow = 0,
    ExtremeHigh = 1
} ExtremeType;

@interface SixHourTemperatureExtremeRemark : Remark

@property (assign) ExtremeType type;
@property (assign) float temperature;

@end
