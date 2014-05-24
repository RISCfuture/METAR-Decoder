typedef enum _PressureCharacter {
    PressureChangeInflectedDown = 0,
    PressureChangeDeceleratingUp = 1,
    PressureChangeSteadyUp = 2,
    PressureChangeAcceleratingUp = 3,
    PressureChangeZero = 4,
    PressureChangeInflectedUp = 5,
    PressureChangeDeceleratingDown = 6,
    PressureChangeSteadyDown = 7,
    PressureChangeAcceleratingDown = 8
} PressureCharacter;

@interface PressureTendencyRemark : Remark

@property (assign) PressureCharacter character;
@property (assign) float pressureChange; // hPa

@end
