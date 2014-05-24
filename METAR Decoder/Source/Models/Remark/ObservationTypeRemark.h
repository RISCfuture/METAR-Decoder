typedef enum _ObservationType {
    ObservationTypeAutomated = 1,
    ObservationTypeAutomatedWithPrecipiation = 2,
} ObservationType;

@interface ObservationTypeRemark : Remark

@property (assign) ObservationType type;

@end