typedef enum _RemarkUrgency {
    UrgencyUnknown = -1,
    UrgencyRoutine = 0,
    UrgencyCaution,
    UrgencyUrgent
} RemarkUrgency;

typedef enum _RemarkDirection {
    DirectionAll = -2,
    DirectionNone = -1,
    DirectionNorth = 0,
    DirectionNortheast = 45,
    DirectionEast = 90,
    DirectionSoutheast = 135,
    DirectionSouth = 180,
    DirectionSouthwest = 225,
    DirectionWest = 270,
    DirectionNorthwest = 315
} RemarkDirection;

typedef unsigned char DirectionMask;
enum _DirectionMaskValues {
    DirectionMaskNorth = 1,
    DirectionMaskNortheast = 1 << 1,
    DirectionMaskEast = 1 << 2,
    DirectionMaskSoutheast = 1 << 3,
    DirectionMaskSouth = 1 << 4,
    DirectionMaskSouthwest = 1 << 5,
    DirectionMaskWest = 1 << 6,
    DirectionMaskNorthwest = 1 << 7
};

typedef enum _RemarkProximity {
    ProximityUnknown = -1,
    ProximityOverhead = 0,
    ProximityVicinity,
    ProximityDistant
} RemarkProximity;

typedef enum _RemarkFrequency {
    FrequencyUnknown = -1,
    FrequencyOccasional = 0,
    FrequencyFrequent,
    FrequencyConstant
} RemarkFrequency;

typedef struct _RemarkLocation {
    RemarkDirection direction;
    NSInteger distance;
} RemarkLocation;

@class METAR;

@interface Remark : NSObject

@property (weak) METAR *parent;
@property (readonly) RemarkUrgency urgency;

+ (void) registerSubclass:(Class)klass;
+ (NSSet *) subclasses;

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR;
- (NSString *) stringValue;

- (NSTextCheckingResult *) matchRemarks:(NSString *)remarks withRegex:(NSString *)regexString;

@end

#import "UnknownRemark.h"
#import "ObservationTypeRemark.h"
#import "TornadicActivityRemark.h"
#import "PeakWindsRemark.h"
#import "WindShiftRemark.h"
#import "ObservedVisibilityRemark.h"
#import "VariablePrevailingVisibilityRemark.h"
#import "SectorVisibilityRemark.h"
#import "RunwayVisibilityRemark.h"
#import "LightningRemark.h"
#import "PrecipitationBeginEndRemark.h"
#import "ThunderstormBeginEndRemark.h"
#import "ThunderstormLocationRemark.h"
#import "HailstoneSizeRemark.h"
#import "VirgaRemark.h"
#import "VariableCeilingHeightRemark.h"
#import "ObscurationRemark.h"
#import "VariableSkyConditionRemark.h"
#import "SignificantCloudsRemark.h"
#import "RunwayCeilingRemark.h"
#import "RapidPressureChangeRemark.h"
#import "SeaLevelPressureRemark.h"
#import "AircraftMishapRemark.h"
#import "NoSPECIRemark.h"
#import "RapidSnowIncreaseRemark.h"
#import "HourlyPrecipitationAmountRemark.h"
#import "PeriodicPrecipitationAmountRemark.h"
#import "DailyPrecipitationAmountRemark.h"
#import "SnowDepthRemark.h"
#import "WaterEquivalentDepthRemark.h"
#import "CloudTypesRemark.h"
#import "SunshineDurationRemark.h"
#import "TemperatureDewpointRemark.h"
#import "SixHourTemperatureExtremeRemark.h"
#import "DailyTemperatureExtremeRemark.h"
#import "PressureTendencyRemark.h"
#import "SensorStatusRemark.h"
#import "MaintenanceRemark.h"
